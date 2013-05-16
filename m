Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3EPMCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:02:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47808 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3EPMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:02:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: joseph.salisbury@canonical.com
Cc: linux-kernel@vger.kernel.org, mchehab@redhat.com,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] uvcvideo: quirk PROBE_DEF for Alienware X51 OmniVision webcam
Date: Thu, 16 May 2013 14:03:04 +0200
Message-ID: <4475290.i8RRTUStdI@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1368650328-21128-1-git-send-email-joseph.salisbury@canonical.com>
References: <1368650328-21128-1-git-send-email-joseph.salisbury@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

Thank you for the patch.

On Wednesday 15 May 2013 16:38:48 joseph.salisbury@canonical.com wrote:
> From: Joseph Salisbury <joseph.salisbury@canonical.com>
> 
> BugLink: http://bugs.launchpad.net/bugs/1180409
> 
> OminiVision webcam 0x05a9:0x2643 needs the same UVC_QUIRK_PROBE_DEF as other
> OmniVision models to work properly.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>

There's already a 05a9:2643 webcam model, found in a Dell monitor, that has 
been reported to work properly without the UVC_QUIRK_PROBE_DEF. Enabling the 
quirk shouldn't hurt, but I'd like to check differences between the two 
devices. Could you please send me the output of

lsusb -v -d 05a9:2643

(running as root if possible) ?

> ---
>  drivers/media/usb/uvc/uvc_driver.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 5dbefa6..411682c 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2163,6 +2163,15 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
> + 	/* Alienware X51*/
> +        { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
> +                                | USB_DEVICE_ID_MATCH_INT_INFO,
> +          .idVendor             = 0x05a9,
> +          .idProduct            = 0x2643,
> +          .bInterfaceClass      = USB_CLASS_VIDEO,
> +          .bInterfaceSubClass   = 1,
> +          .bInterfaceProtocol   = 0,
> +          .driver_info          = UVC_QUIRK_PROBE_DEF },

Your mailer messed up formatting. As the patch is small I've fixed it 
manually, but please make sure to use a proper mail client next time. I advise 
using git-send-email to send patches.

>  	/* Apple Built-In iSight */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
Regards,

Laurent Pinchart

