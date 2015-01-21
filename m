Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbbAUMY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:24:56 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:37203 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbAUMYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:24:49 -0500
Message-ID: <54BF9A8E.7000202@cogentembedded.com>
Date: Wed, 21 Jan 2015 15:24:46 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: Andri Yngvason <andri.yngvason@marel.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 4/5] can: kvaser_usb: Retry the first bulk transfer
 on -ETIMEDOUT
References: <20141223154654.GB6460@vivalin-002> <20150120214409.GA16828@linux> <20150120214537.GB16828@linux> <20150120214709.GC16828@linux> <20150120214834.GD16828@linux>
In-Reply-To: <20150120214834.GD16828@linux>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/21/2015 12:48 AM, Ahmed S. Darwish wrote:

> From: Ahmed S. Darwish <ahmed.darwish@valeo.com>

> On some x86 laptops, plugging a Kvaser device again after an
> unplug makes the firmware always ignore the very first command.
> For such a case, provide some room for retries instead of
> completly exiting the driver init code.

    Completely.

> Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> ---
>   drivers/net/can/usb/kvaser_usb.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
> index 640b0eb..068e76c 100644
> --- a/drivers/net/can/usb/kvaser_usb.c
> +++ b/drivers/net/can/usb/kvaser_usb.c
[...]
> @@ -1632,7 +1632,15 @@ static int kvaser_usb_probe(struct usb_interface *intf,
>
>   	usb_set_intfdata(intf, dev);
>
> -	err = kvaser_usb_get_software_info(dev);
> +	/* On some x86 laptops, plugging a Kvaser device again after
> +	 * an unplug makes the firmware always ignore the very first
> +	 * command. For such a case, provide some room for retries
> +	 * instead of completly exiting the driver.

    Completely.

[...]

WBR, Sergei

