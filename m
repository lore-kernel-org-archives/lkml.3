Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3IMTMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:12:41 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:62487 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3IMTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:12:38 -0400
Message-ID: <523363A9.6080102@cogentembedded.com>
Date: Fri, 13 Sep 2013 23:12:41 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Chavent <Paul.Chavent@onera.fr>
CC: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] USB : serial : invoke dcd_change ldisc's handler.
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr> <1379086513-2434-3-git-send-email-paul.chavent@onera.fr>
In-Reply-To: <1379086513-2434-3-git-send-email-paul.chavent@onera.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/13/2013 07:35 PM, Paul Chavent wrote:

> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
> ---
>   Documentation/pps/pps.txt    | 15 +++++++++++++++
>   drivers/usb/serial/generic.c |  9 +++++++++
>   2 files changed, 24 insertions(+)

> diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
> index d35dcdd..67b9a94 100644
> --- a/Documentation/pps/pps.txt
> +++ b/Documentation/pps/pps.txt
> @@ -66,6 +66,21 @@ In LinuxPPS the PPS sources are simply char devices usually mapped
>   into files /dev/pps0, /dev/pps1, etc..
>
>
> +PPS with USB to serial devices
> +------------------------------
> +
> +It is possible to grab the PPS from an USB to serial device. However,
> +you should take into account the latencies and jitter introduced by
> +the USB stack. Users has reported clock instability around +-1ms when
> +synchronized with PPS through USB. This isn't suited for time server
> +synchronisation.

    Thunderbird spellchecker underlines this word -- "synchronization" is 
probably better.

[...]
> diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> index 1f31e6b..877d6e0 100644
> --- a/drivers/usb/serial/generic.c
> +++ b/drivers/usb/serial/generic.c
> @@ -568,6 +568,15 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
>   {
>   	struct tty_port *port = &usb_port->port;
>
> +	if (tty) {
> +		struct tty_ldisc *ld = tty_ldisc_ref(tty);

    Insert an empty line after declaration as above -- keep the style 
consistent, please.

> +		if (ld) {
> +			if (ld->ops->dcd_change)
> +				ld->ops->dcd_change(tty, status);
> +			tty_ldisc_deref(ld);
> +		}
> +	}
> +

WBR, Sergei

