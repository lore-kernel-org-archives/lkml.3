Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3IMTII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:08:08 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43518 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3IMTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:08:06 -0400
Message-ID: <52336299.6070508@cogentembedded.com>
Date: Fri, 13 Sep 2013 23:08:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Chavent <Paul.Chavent@onera.fr>
CC: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] USB : serial : call handle_dcd_change in ftdi driver.
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr> <1379086513-2434-2-git-send-email-paul.chavent@onera.fr>
In-Reply-To: <1379086513-2434-2-git-send-email-paul.chavent@onera.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/13/2013 07:35 PM, Paul Chavent wrote:

> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
> ---
>   drivers/usb/serial/ftdi_sio.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)

> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index c45f9c0..df66495 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -1966,8 +1966,14 @@ static int ftdi_process_packet(struct usb_serial_port *port,
>   			port->icount.dsr++;
>   		if (diff_status & FTDI_RS0_RI)
>   			port->icount.rng++;
> -		if (diff_status & FTDI_RS0_RLSD)
> +		if (diff_status & FTDI_RS0_RLSD) {
>   			port->icount.dcd++;
> +			struct tty_struct *tty = tty_port_tty_get(&port->port);

    Don't mix declaration and code. And add an empty line between them please.

> +			if (tty)
> +				usb_serial_handle_dcd_change(port, tty,
> +						status & FTDI_RS0_RLSD);
> +			tty_kref_put(tty);
> +		}

WBR, Sergei


