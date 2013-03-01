Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3CACAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:00:03 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53997 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3CACAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:00:01 -0500
Date: Thu, 28 Feb 2013 18:00:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 10/30] staging: sync: Export sync API symbols
Message-ID: <20130301020008.GB13367@kroah.com>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
 <1362098606-26469-11-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362098606-26469-11-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:43:06PM -0800, John Stultz wrote:
> From: Erik Gilling <konkers@android.com>
> 
> This is needed to allow modules to link against the sync subsystem
> 
> Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: Erik Gilling <konkers@android.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Rob Clark <robclark@gmail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Signed-off-by: Erik Gilling <konkers@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/sync.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
> index 54f84d9..6739a84 100644
> --- a/drivers/staging/android/sync.c
> +++ b/drivers/staging/android/sync.c
> @@ -15,6 +15,7 @@
>   */
>  
>  #include <linux/debugfs.h>
> +#include <linux/export.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/kernel.h>
> @@ -64,6 +65,7 @@ struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
>  
>  	return obj;
>  }
> +EXPORT_SYMBOL(sync_timeline_create);

As these are now global, should they be a bit more "specific"?  "sync_"
seems pretty broad.

Also, EXPORT_SYMBOL_GPL() perhaps?

And who is using these exports?

thanks,

greg k-h
