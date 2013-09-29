Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3I2GzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 02:55:08 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:43159 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3I2GzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 02:55:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Chanho Min <chanho.min@lge.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, HyoJun Im <hyojun.im@lge.com>
Subject: Re: [PATCH] [media] uvcvideo: fix data type for pan/tilt control
Date: Sun, 29 Sep 2013 08:55:06 +0200
Message-ID: <1512831.Q6pZeWPU68@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1380257860-14075-1-git-send-email-chanho.min@lge.com>
References: <1380257860-14075-1-git-send-email-chanho.min@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanho,

Thank you for the patch.

On Friday 27 September 2013 13:57:40 Chanho Min wrote:
> The pan/tilt absolute control value is signed value. If minimum value
> is minus, It will be changed to plus by clamp_t() as commit 64ae9958a62.
> ([media] uvcvideo: Fix control value clamping for unsigned integer
> controls).
> 
> It leads to wrong setting of the control values. For example,
> when min and max are -36000 and 36000, the setting value between of this
> range is always 36000. So, Its data type should be changed to signed.
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patch in my tree and will send a pull request for the next 
kernel version.

> ---
>  drivers/media/usb/uvc/uvc_ctrl.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index a2f4501..0eb82106 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -664,7 +664,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] =
> { .size		= 32,
>  		.offset		= 0,
>  		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> -		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
>  	},
>  	{
>  		.id		= V4L2_CID_TILT_ABSOLUTE,
> @@ -674,7 +674,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] =
> { .size		= 32,
>  		.offset		= 32,
>  		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> -		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
>  	},
>  	{
>  		.id		= V4L2_CID_PRIVACY,
-- 
Regards,

Laurent Pinchart

