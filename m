Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaGJMl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:41:56 -0400
Received: from cnc.isely.net ([75.149.91.89]:42723 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbaGJMlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:41:55 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2014 08:41:55 EDT
Date: Thu, 10 Jul 2014 07:36:50 -0500 (CDT)
From: isely@isely.net
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        m.chehab@samsung.com, dcb314@hotmail.com
Subject: Re: [PATCH] media: pvrusb2: make logging code sane
In-Reply-To: <1404995545-4286-1-git-send-email-andrey.krieger.utkin@gmail.com>
Message-ID: <alpine.DEB.2.02.1407100735110.19815@ivanova.isely.net>
References: <1404995545-4286-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nice.  I wonder if a previous merge mechanically resulted in this.  I 
can't imagine deliberately writing code like that.

  -Mike


Acked-by: Mike Isely <isely@pobox.com>

On Thu, 10 Jul 2014, Andrey Utkin wrote:

> The issue was discovered by static analysis. It turns out that code is
> somewhat insane, being
> if (x) {...} else { if (x) {...} }
> 
> Edited it to do the only reasonable thing, which is to log the
> information about the failed call. The most descriptive logging commands
> set is taken from original code.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79801
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> index 7c280f3..1b158f1 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -951,15 +951,9 @@ static long pvr2_v4l2_ioctl(struct file *file,
>  	if (ret < 0) {
>  		if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL) {
>  			pvr2_trace(PVR2_TRACE_V4LIOCTL,
> -				   "pvr2_v4l2_do_ioctl failure, ret=%ld", ret);
> -		} else {
> -			if (pvrusb2_debug & PVR2_TRACE_V4LIOCTL) {
> -				pvr2_trace(PVR2_TRACE_V4LIOCTL,
> -					   "pvr2_v4l2_do_ioctl failure, ret=%ld"
> -					   " command was:", ret);
> -				v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw),
> -						cmd);
> -			}
> +				   "pvr2_v4l2_do_ioctl failure, ret=%ld"
> +				   " command was:", ret);
> +			v4l_printk_ioctl(pvr2_hdw_get_driver_name(hdw), cmd);
>  		}
>  	} else {
>  		pvr2_trace(PVR2_TRACE_V4LIOCTL,
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
