Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423466Ab3FUXzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 19:55:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423208Ab3FUXzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 19:55:23 -0400
Date: Fri, 21 Jun 2013 16:56:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
Message-ID: <20130621235603.GA1603@kroah.com>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se>
 <20130619225315.GB12282@kroah.com>
 <201306212308.r5LN8C7M020720@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306212308.r5LN8C7M020720@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 01:08:12AM +0200, Anders Hammarquist wrote:
> In a message of Wed, 19 Jun 2013 15:53:15 -0700, Greg KH writes:
> >I think you forgot a Subject :)
> 
> Indeed. I blame it on my first fight with git format-patch ;-)
> 
> >On Wed, Jun 19, 2013 at 02:05:07AM +0200, Anders Hammarquist wrote:
> >> This patch set adds the product id to the driver, and makes the
> >> product type more explicit. Arguably, the ABBOTT_PRODUCT_ID
> >> define could be removed, but I left it on the off chance that
> >> someone other that the TI 3410 driver uses it.
> >
> >No, it doesn't, please fix up that last patch and resend it.
> 
> Right, and in removing it I actually found that it was used in
> two places in the driver. I lost my second fight with format-patch
> so I'll just enclose the fixed patch below.
> 
> /Anders
> 
> ---8<---
> ti_usb_3410_5052:
> * Remove unspecific ABBOTT_PRODUCT_ID
> * Fix size of statically sized arrays
> 
> Signed-off-by: Anders Hammarquist <iko@iko.pp.se>

Please resend this in a format that I can apply it in (i.e. one that
does not require me to edit it by hand...)

Also, please cc: the linux-usb@vger.kernel.org mailing list for usb
patches.

> diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
> index e581c25..26c1161 100644
> --- a/drivers/usb/serial/ti_usb_3410_5052.c
> +++ b/drivers/usb/serial/ti_usb_3410_5052.c
> @@ -158,7 +158,7 @@ static unsigned int product_5052_count;
>  /* the array dimension is the number of default entries plus */
>  /* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
>  /* null entry */
> -static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
> +static struct usb_device_id ti_id_table_3410[16+TI_EXTRA_VID_PID_COUNT+1] = {

That's a mess, why have it be a static array at all?  Just include an
empty one at the end.


>  	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
>  	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
>  	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
> @@ -172,8 +172,8 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
>  	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
>  	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
>  	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
> -	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_ID) },
> -	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
> +	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_PRODUCT_ID) },
> +	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_PRODUCT_ID) },
>  	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
>  };
>  
> @@ -184,7 +184,7 @@ static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
>  	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
>  };
>  
> -static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COUNT+1] = {
> +static struct usb_device_id ti_id_table_combined[20+2*TI_EXTRA_VID_PID_COUNT+1] = {

Same here.  Although that might take another patch, to handle it all
correctly, separate from this "change the device id names" patch.

thanks,

greg k-h
