Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaJIWM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:12:28 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:57514 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaJIWM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:12:26 -0400
Message-ID: <543707BB.1040603@gmail.com>
Date: Fri, 10 Oct 2014 02:10:03 +0400
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: swarren@wwwdotorg.org, josephl@nvidia.com, thierry.reding@gmail.com,
        balbi@ti.com
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: tegra: Re-add removed SoC id macro to tegra_resume()
References: <20141008190432.GN22688@saruman> <1412796255-10589-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1412796255-10589-1-git-send-email-digetx@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08.10.2014 23:24, Dmitry Osipenko пишет:
> Commit d127e9c5c5bc1ee22a7b1fe804397cddd132f756 ("ARM: tegra: make tegra_resume
> can work with current and later chips") removed tegra_get_soc_id macro leaving
> used cpu register unassigned and as result causing execution of unintended code
> on tegra20. Fix it by re-adding macro.
> 
> Fixes: d127e9c (ARM: tegra: make tegra_resume can work with current and later chips)
> Cc: <stable@vger.kernel.org> # v3.13+
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
> V2: added Cc's for lakml and stable, added "Reviewed-by:" Felipe Balbi
> 
>  arch/arm/mach-tegra/reset-handler.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-tegra/reset-handler.S b/arch/arm/mach-tegra/reset-handler.S
> index 7b2baab..71be4af 100644
> --- a/arch/arm/mach-tegra/reset-handler.S
> +++ b/arch/arm/mach-tegra/reset-handler.S
> @@ -51,6 +51,7 @@ ENTRY(tegra_resume)
>   THUMB(	it	ne )
>  	bne	cpu_resume			@ no
>  
> +	tegra_get_soc_id TEGRA_APB_MISC_BASE, r6
>  	/* Are we on Tegra20? */
>  	cmp	r6, #TEGRA20
>  	beq	1f				@ Yes
> 
Ugh, I just noticed that r6 is expected to be SoC id func argument. It was bug
in my emulator that blinded me, so please drop that patch.
But, seems tegra20_lp1_reset() doesn't set r6, at least for now I don't see
where. I'll check it on real hw and send patch if needed.

-- 
Dmitry
