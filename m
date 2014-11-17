Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaKQIkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:40:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:60498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaKQIkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:40:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="417498481"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Nicholas Krause <xerofoify@gmail.com>, airlied@linux.ie
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drivers: Change calls to mdelay to msleep in order to stop CPU busy looping in mdfld_dsi_pkg_sender.c
In-Reply-To: <1416075673-23281-1-git-send-email-xerofoify@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1416075673-23281-1-git-send-email-xerofoify@gmail.com>
User-Agent: Notmuch/0.19~rc1+1~g08b4944 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Nov 2014 10:40:43 +0200
Message-ID: <87ioieusms.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2014, Nicholas Krause <xerofoify@gmail.com> wrote:
> Changes the calls of mdelay to msleep in the driver file mdfld_dsi_pkg_sender.c
> in order to prevent CPU busy looping in order to save CPU cycles as this is
> considered bad form over sleeping the CPU for high resolution timer function
> calls as this driver needs in order to function properly.

The code paths are called with sender->lock spinlock held.

BR,
Jani.

>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
> index 87885d8..77c656a 100644
> --- a/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
> +++ b/drivers/gpu/drm/gma500/mdfld_dsi_pkg_sender.c
> @@ -335,13 +335,11 @@ static int send_pkg_prepare(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
>  
>  	/*wait for 120 milliseconds in case exit_sleep_mode just be sent*/
>  	if (unlikely(cmd == DCS_ENTER_SLEEP_MODE)) {
> -		/*TODO: replace it with msleep later*/
> -		mdelay(120);
> +		msleep(120);
>  	}
>  
>  	if (unlikely(cmd == DCS_EXIT_SLEEP_MODE)) {
> -		/*TODO: replace it with msleep later*/
> -		mdelay(120);
> +		msleep(120);
>  	}
>  	return 0;
>  }
> @@ -364,15 +362,12 @@ static int send_pkg_done(struct mdfld_dsi_pkg_sender *sender, u8 data_type,
>  	/*update panel status*/
>  	if (unlikely(cmd == DCS_ENTER_SLEEP_MODE)) {
>  		sender->panel_mode |= MDFLD_DSI_PANEL_MODE_SLEEP;
> -		/*TODO: replace it with msleep later*/
> -		mdelay(120);
> +		msleep(120);
>  	} else if (unlikely(cmd == DCS_EXIT_SLEEP_MODE)) {
>  		sender->panel_mode &= ~MDFLD_DSI_PANEL_MODE_SLEEP;
> -		/*TODO: replace it with msleep later*/
> -		mdelay(120);
> +		msleep(120);
>  	} else if (unlikely(cmd == DCS_SOFT_RESET)) {
> -		/*TODO: replace it with msleep later*/
> -		mdelay(5);
> +		msleep(5);
>  	}
>  
>  	sender->status = MDFLD_DSI_PKG_SENDER_FREE;
> -- 
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
