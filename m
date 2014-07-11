Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaGKOXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:23:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35780 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbaGKOSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:37 -0400
Date: Fri, 11 Jul 2014 11:19:04 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] [RFC] mmc: tmio-mmc: Add support for SDHI on new
 R-Car Gen2 SoCs
Message-ID: <20140711091904.GP12420@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-12-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404908623-909-12-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:23:41PM +0200, Geert Uytterhoeven wrote:
>   - r8a7792 (R-Car V2H)
>   - r8a7793 (R-Car M2-N)
>   - r8a7794 (R-Car E2)
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

This seems to be in keeping with the approach we ave taken for these
SoCs for other drivers. And from that point of view it is fine by me.
But I wonder how sure are we that the hardware on the SoCs will work
with this approach.

> ---
>  Documentation/devicetree/bindings/mmc/tmio_mmc.txt | 3 +++
>  drivers/mmc/host/sh_mobile_sdhi.c                  | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
> index fa0f327cde01..400b640fabc7 100644
> --- a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
> @@ -19,6 +19,9 @@ Required properties:
>  		"renesas,sdhi-r8a7779" - SDHI IP on R8A7779 SoC
>  		"renesas,sdhi-r8a7790" - SDHI IP on R8A7790 SoC
>  		"renesas,sdhi-r8a7791" - SDHI IP on R8A7791 SoC
> +		"renesas,sdhi-r8a7792" - SDHI IP on R8A7792 SoC
> +		"renesas,sdhi-r8a7793" - SDHI IP on R8A7793 SoC
> +		"renesas,sdhi-r8a7794" - SDHI IP on R8A7794 SoC
>  
>  Optional properties:
>  - toshiba,mmc-wrprotect-disable: write-protect detection is unavailable
> diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
> index 91058dabd11a..443c20969bd7 100644
> --- a/drivers/mmc/host/sh_mobile_sdhi.c
> +++ b/drivers/mmc/host/sh_mobile_sdhi.c
> @@ -68,6 +68,9 @@ static const struct of_device_id sh_mobile_sdhi_of_match[] = {
>  	{ .compatible = "renesas,sdhi-r8a7779", .data = &of_rcar_gen1_compatible, },
>  	{ .compatible = "renesas,sdhi-r8a7790", .data = &of_rcar_gen2_compatible, },
>  	{ .compatible = "renesas,sdhi-r8a7791", .data = &of_rcar_gen2_compatible, },
> +	{ .compatible = "renesas,sdhi-r8a7792", .data = &of_rcar_gen2_compatible, },
> +	{ .compatible = "renesas,sdhi-r8a7793", .data = &of_rcar_gen2_compatible, },
> +	{ .compatible = "renesas,sdhi-r8a7794", .data = &of_rcar_gen2_compatible, },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, sh_mobile_sdhi_of_match);
> -- 
> 1.9.1
> 
