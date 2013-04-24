Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab3DXJR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:17:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42216 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3DXJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:17:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: adam.lee@canonical.com
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "open list:USB VIDEO CLASS" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert "V4L/DVB: uvc: Enable USB autosuspend by default on uvcvideo"
Date: Wed, 24 Apr 2013 11:17:52 +0200
Message-ID: <6159110.qEtHHiJYtm@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366790239-838-1-git-send-email-adam.lee@canonical.com>
References: <1366790239-838-1-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

Thanks for the patch.

On Wednesday 24 April 2013 15:57:19 adam.lee@canonical.com wrote:
> From: Adam Lee <adam.lee@canonical.com>
> 
> This reverts commit 3dae8b41dc5651f8eb22cf310e8b116480ba25b7.
> 
> 1, I do have a Chicony webcam, implements autosuspend in a broken way,
> make `poweroff` performs rebooting when its autosuspend enabled.
> 
> 2, There are other webcams which don't support autosuspend too, like
> https://patchwork.kernel.org/patch/2356141/
> 
> 3, kernel removed USB_QUIRK_NO_AUTOSUSPEND in
> a691efa9888e71232dfb4088fb8a8304ffc7b0f9, because autosuspend is
> disabled by default.
> 
> So, we need to disable autosuspend in uvcvideo, maintaining a quirk list
> only for uvcvideo is not a good idea.
> 
> Signed-off-by: Adam Lee <adam.lee@canonical.com>

I've received very few bug reports about broken auto-suspend support in UVC 
devices. Most of them could be solved by setting the RESET_RESUME quirk in USB 
core, only the Creative Live! Cam Optia AF required a quirk in the uvcvideo 
driver. I would thus rather use the available quirks (USB_QUIRK_RESET_RESUME 
if possible, UVC_QUIRK_DISABLE_AUTOSUSPEND otherwise) than killing power 
management for the vast majority of webcams that behave correctly.

> ---
>  drivers/media/usb/uvc/uvc_driver.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index 5dbefa6..8556f7c 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1914,7 +1914,6 @@ static int uvc_probe(struct usb_interface *intf,
>  	}
> 
>  	uvc_trace(UVC_TRACE_PROBE, "UVC device initialized.\n");
> -	usb_enable_autosuspend(udev);
>  	return 0;
> 
>  error:

-- 
Regards,

Laurent Pinchart

