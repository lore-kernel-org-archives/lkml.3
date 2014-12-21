Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaLUCqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 21:46:46 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49122 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaLUCqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 21:46:45 -0500
Date: Sat, 20 Dec 2014 21:46:35 -0500 (EST)
From: Ben Skeggs <bskeggs@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: David Airlie <airlied@linux.ie>, Alexandre Courbot <acourbot@nvidia.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <652559297.245180.1419129995022.JavaMail.zimbra@redhat.com>
In-Reply-To: <1419094456-9446-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419094456-9446-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] gpu: drm: nouveau: core: subdev: clock: base.c:  Remove
 unused function
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC40 (Linux)/8.0.6_GA_5922)
Thread-Topic: nouveau: core: subdev: clock: base.c: Remove unused function
Thread-Index: tVL33WgzgJM0G9fIe/l08b77uW3ydw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Rickard Strandqvist" <rickard_strandqvist@spectrumdigital.se>
> To: "David Airlie" <airlied@linux.ie>, "Ben Skeggs" <bskeggs@redhat.com>
> Cc: "Rickard Strandqvist" <rickard_strandqvist@spectrumdigital.se>, "Alexandre Courbot" <acourbot@nvidia.com>, "Ilia
> Mirkin" <imirkin@alum.mit.edu>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
> Sent: Sunday, 21 December, 2014 2:54:16 AM
> Subject: [PATCH] gpu: drm: nouveau: core: subdev: clock: base.c:  Remove unused function
> 
> Remove the function nouveau_clock_astate() that is not used anywhere.
No, don't remove this.  It's only not used because noone got around to finishing load-based reclocking yet.

NVIDIA has an implementation for the GK20A in the works that uses it.

Ben.

> 
> This was partially found by using a static code analysis program called
> cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/gpu/drm/nouveau/core/include/subdev/clock.h |    1 -
>  drivers/gpu/drm/nouveau/core/subdev/clock/base.c    |   10 ----------
>  2 files changed, 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
> b/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
> index 36ed035..8577945 100644
> --- a/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
> +++ b/drivers/gpu/drm/nouveau/core/include/subdev/clock.h
> @@ -159,7 +159,6 @@ int nva3_clock_pll_calc(struct nouveau_clock *, struct
> nvbios_pll *,
>  			int clk, struct nouveau_pll_vals *);
>  
>  int nouveau_clock_ustate(struct nouveau_clock *, int req, int pwr);
> -int nouveau_clock_astate(struct nouveau_clock *, int req, int rel);
>  int nouveau_clock_dstate(struct nouveau_clock *, int req, int rel);
>  int nouveau_clock_tstate(struct nouveau_clock *, int req, int rel);
>  
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> index e51b72d..b2c852a 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
> @@ -430,16 +430,6 @@ nouveau_clock_ustate(struct nouveau_clock *clk, int req,
> int pwr)
>  }
>  
>  int
> -nouveau_clock_astate(struct nouveau_clock *clk, int req, int rel)
> -{
> -	if (!rel) clk->astate  = req;
> -	if ( rel) clk->astate += rel;
> -	clk->astate = min(clk->astate, clk->state_nr - 1);
> -	clk->astate = max(clk->astate, 0);
> -	return nouveau_pstate_calc(clk, true);
> -}
> -
> -int
>  nouveau_clock_tstate(struct nouveau_clock *clk, int req, int rel)
>  {
>  	if (!rel) clk->tstate  = req;
> --
> 1.7.10.4
> 
> 
