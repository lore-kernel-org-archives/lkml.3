Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3A2RTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:19:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab3A2RTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:19:16 -0500
Message-ID: <1359479958.1635.8.camel@dcbw.foobar.com>
Subject: Re: [PATCH 1/1] USB: option: add support for Telit LE920
From: Dan Williams <dcbw@redhat.com>
To: Daniele Palmas <dnlplm@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Jan 2013 11:19:18 -0600
In-Reply-To: <1359388030-2821-1-git-send-email-dnlplm@gmail.com>
References: <1359388030-2821-1-git-send-email-dnlplm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 16:47 +0100, Daniele Palmas wrote:
> From: danielepa <danielepa@L2011.(none)>
> 
> Add PID and special handling for Telit LE920

Any idea what interfaces 1 and 5 are?  Is one perhaps a pseudo-ethernet
interface that could be used instead of PPP?  What's the lsusb -v output
for the device?

Dan

> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  drivers/usb/serial/option.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 0d9dac9..384bb92 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -242,6 +242,7 @@ static void option_instat_callback(struct urb *urb);
>  #define TELIT_PRODUCT_CC864_DUAL		0x1005
>  #define TELIT_PRODUCT_CC864_SINGLE		0x1006
>  #define TELIT_PRODUCT_DE910_DUAL		0x1010
> +#define TELIT_PRODUCT_LE920			0x1200
>  
>  /* ZTE PRODUCTS */
>  #define ZTE_VENDOR_ID				0x19d2
> @@ -534,6 +535,11 @@ static const struct option_blacklist_info zte_1255_blacklist = {
>  	.reserved = BIT(3) | BIT(4),
>  };
>  
> +static const struct option_blacklist_info telit_le920_blacklist = {
> +	.sendsetup = BIT(0),
> +	.reserved = BIT(1) | BIT(5),
> +};
> +
>  static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
> @@ -784,6 +790,8 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
>  	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
>  	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
> +	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
> +		.driver_info = (kernel_ulong_t)&telit_le920_blacklist },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
>  		.driver_info = (kernel_ulong_t)&net_intf1_blacklist },


