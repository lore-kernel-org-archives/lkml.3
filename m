Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3EHW0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:26:44 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14381 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3EHW0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:26:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18heKobMnBvlneuu6koIgHv
Date: Wed, 8 May 2013 15:26:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Vincent =?utf-8?Q?Stehl=C3=A9?= <v-stehle@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] ARM: omap2: gpmc: fix compilation warning
Message-ID: <20130508222639.GM32546@atomide.com>
References: <1367839093-13033-1-git-send-email-v-stehle@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367839093-13033-1-git-send-email-v-stehle@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vincent Stehlé <v-stehle@ti.com> [130506 04:24]:
> Fix the following compilation warning:
> 
>   arch/arm/mach-omap2/gpmc.c: In function 'gpmc_probe_generic_child':
>   arch/arm/mach-omap2/gpmc.c:1477:4: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> 
> Signed-off-by: Vincent Stehlé <v-stehle@ti.com>
> Cc: trivial@kernel.org
> ---
>  arch/arm/mach-omap2/gpmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index ed946df..3cd7074 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -1474,7 +1474,7 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
>  	ret = gpmc_cs_remap(cs, res.start);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "cannot remap GPMC CS %d to 0x%x\n",
> -			cs, res.start);
> +			cs, (unsigned)res.start);
>  		goto err;
>  	}

You should just change the format for dev_err instead of the casting.

Regards,

Tony
