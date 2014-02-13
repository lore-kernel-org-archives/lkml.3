Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaBMMbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:31:16 -0500
Received: from mx1.bahnhof.se ([213.80.101.11]:8479 "EHLO mx1.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbaBMMbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:31:15 -0500
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2014 07:31:14 EST
X-Spam-Score: 0.056
Message-ID: <52FCB63E.1080601@shipmail.org>
Date: Thu, 13 Feb 2014 13:10:38 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie
Subject: Re: [PATCH] drm/ttm: Fix memory leak in ttm_agp_backend.c
References: <1392212785-23150-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1392212785-23150-1-git-send-email-standby24x7@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 02:46 PM, Masanari Iida wrote:
> This patch fix a memory leak found by cppcheck.
> [drivers/gpu/drm/ttm/ttm_agp_backend.c:129]:
> (error) Memory leak: agp_be
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/gpu/drm/ttm/ttm_agp_backend.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
> index 3302f99..764be36 100644
> --- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
> +++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
> @@ -126,6 +126,7 @@ struct ttm_tt *ttm_agp_tt_create(struct ttm_bo_device *bdev,
>  	agp_be->ttm.func = &ttm_agp_func;
>  
>  	if (ttm_tt_init(&agp_be->ttm, bdev, size, page_flags, dummy_read_page)) {
> +		kfree(agp_be);
>  		return NULL;
>  	}
>  

Thanks, I'll include in the next ttm-fixes pull request.

/Thomas



