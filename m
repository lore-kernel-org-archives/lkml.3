Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaE0Gkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:40:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:28804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaE0Gk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:40:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="545340942"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Benoit Taine <benoit.taine@lip6.fr>, David Airlie <airlied@linux.ie>
Cc: benoit.taine@lip6.fr, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 13/18] drm/edid: Use kmemdup instead of kmalloc + memcpy
In-Reply-To: <1401117687-28911-14-git-send-email-benoit.taine@lip6.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr> <1401117687-28911-14-git-send-email-benoit.taine@lip6.fr>
User-Agent: Notmuch/0.18+16~gec02089 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 27 May 2014 09:40:14 +0300
Message-ID: <87ha4biv1t.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014, Benoit Taine <benoit.taine@lip6.fr> wrote:
> This issue was reported by coccicheck using the semantic patch 
> at scripts/coccinelle/api/memdup.cocci

Reviewed-by: Jani Nikula <jani.nikula@intel.com>


>
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> ---
> Tested by compilation without errors.
>
>  drivers/gpu/drm/drm_edid.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 7a4fd2e..d74239f 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -3228,10 +3228,9 @@ int drm_edid_to_speaker_allocation(struct edid *edid, u8 **sadb)
>  
>  			/* Speaker Allocation Data Block */
>  			if (dbl == 3) {
> -				*sadb = kmalloc(dbl, GFP_KERNEL);
> +				*sadb = kmemdup(&db[1], dbl, GFP_KERNEL);
>  				if (!*sadb)
>  					return -ENOMEM;
> -				memcpy(*sadb, &db[1], dbl);
>  				count = dbl;
>  				break;
>  			}
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
