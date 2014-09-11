Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaIKI7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:59:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:63882 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbaIKI7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:59:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571645195"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: David Herrmann <dh.herrmann@gmail.com>, dri-devel@lists.freedesktop.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC 1/4] backlight: use static initializers
In-Reply-To: <1410364463-12692-2-git-send-email-dh.herrmann@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com> <1410364463-12692-2-git-send-email-dh.herrmann@gmail.com>
User-Agent: Notmuch/0.18.1+85~gcca05ac (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 11 Sep 2014 11:59:47 +0300
Message-ID: <87wq9acz24.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, David Herrmann <dh.herrmann@gmail.com> wrote:
> Use static initializers instead of setting up global variables during
> runtime. This reduces code size and execution time.
>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/video/backlight/backlight.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index bddc8b1..726c6c6 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -21,9 +21,9 @@
>  #include <asm/backlight.h>
>  #endif
>  
> -static struct list_head backlight_dev_list;
> -static struct mutex backlight_dev_list_mutex;
> -static struct blocking_notifier_head backlight_notifier;
> +static LIST_HEAD(backlight_dev_list);
> +static DEFINE_MUTEX(backlight_dev_list_mutex);
> +static BLOCKING_NOTIFIER_HEAD(backlight_notifier);
>  
>  static const char *const backlight_types[] = {
>  	[BACKLIGHT_RAW] = "raw",
> @@ -582,9 +582,6 @@ static int __init backlight_class_init(void)
>  
>  	backlight_class->dev_groups = bl_device_groups;
>  	backlight_class->pm = &backlight_class_dev_pm_ops;
> -	INIT_LIST_HEAD(&backlight_dev_list);
> -	mutex_init(&backlight_dev_list_mutex);
> -	BLOCKING_INIT_NOTIFIER_HEAD(&backlight_notifier);
>  
>  	return 0;
>  }
> -- 
> 2.1.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
