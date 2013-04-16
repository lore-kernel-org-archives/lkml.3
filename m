Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965603Ab3DPXFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:05:00 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46017 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565Ab3DPXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:04:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] uvcvideo: quirk PROBE_DEF for Dell Studio / OmniVision webcam
Date: Wed, 17 Apr 2013 01:05:05 +0200
Message-ID: <3233904.U6nm1cedXx@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366052511-27284-1-git-send-email-kamal@canonical.com>
References: <1366052511-27284-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

On Monday 15 April 2013 12:01:51 Kamal Mostafa wrote:
> BugLink: https://bugs.launchpad.net/bugs/1168430
> 
> OminiVision webcam 0x05a9:0x264a (in Dell Studio Hybrid 140g) needs the
> same UVC_QUIRK_PROBE_DEF as other OmniVision model to be recognized
> consistently.
> 
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>

Thank you for the patch.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patch in my tree and will submit it upstream for v3.11.

Could you please try to get the full 'lsusb -v -d 05a9:264a' output from the 
bug reporter ?

> ---
>  drivers/media/usb/uvc/uvc_driver.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 5dbefa6..17bd48d 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2163,6 +2163,15 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
> +	/* Dell Studio Hybrid 140g (OmniVision webcam) */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x05a9,
> +	  .idProduct		= 0x264a,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info		= UVC_QUIRK_PROBE_DEF },
>  	/* Apple Built-In iSight */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,

-- 
Regards,

Laurent Pinchart

