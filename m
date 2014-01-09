Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaAIIvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:51:36 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:57009 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaAIIvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:51:31 -0500
Date: Thu, 9 Jan 2014 17:51:28 +0900
From: Simon Horman <horms@verge.net.au>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH CFT] ARM:SHMOBILE: Enable AUTO_ZRELADDR by default
Message-ID: <20140109085128.GI9267@verge.net.au>
References: <1389256274-6308-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389256274-6308-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does not enable AUTO_ZRELADDR by default.
It forces AUTO_ZRELADDR to be enabled to be used unless ZBOOT_ROM is enabled.

I'm not opposed to this approach but I think the changelog is misleading.


AUTO_ZRELADDR is known to work on the Genmai, Koelsch, KZM9D and Lager
boards and is enabled in their defconfigs.

I will defer to Magnus on weather he is comfortable with being
enable globally for shmobile but if not perhaps it could be selected
on a per-board or per-SoC basis.

On Thu, Jan 09, 2014 at 02:01:14PM +0530, panchaxari wrote:
> This patch enables AUTO_ZRELADDR as default config to Renasas R-Mobile and
> SH-Mobile platforms.
> 
> AUTO_ZRELADDR config enables auto calculation of the decompressed kernel image
> address. AUTO_ZRELADDR config is mutually exclusive to ZBOOT_ROM, and also
> assumes zImage to be loaded in the first 128MiB from start of memory.
> 
> CFT::Call For Testing
> 
> Requesting maintainers of R-Mobile and SH-Mobile platforms to evaluate the
> changes on the board and comment, as I dont have the board for testing, and
> also requesting an ACK.
> 
> Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>

Please use your first name and last  name in the From address and
Signed-off-by line.

e.g.

Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>

> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <damm@opensource.se>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Below lkml link is a quoting by Russell which clears the concept of PHYS_VIRT
> and ZRELADDR
> ---------------------------------------------------
> 
> https://lkml.org/lkml/2011/10/14/434
> 
> -------------------------------------------------
> ---
>  arch/arm/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 8e668e2..077ef9d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -674,6 +674,7 @@ config ARCH_MSM
>  config ARCH_SHMOBILE
>  	bool "Renesas SH-Mobile / R-Mobile"
>  	select ARM_PATCH_PHYS_VIRT
> +	select AUTO_ZRELADDR
>  	select CLKDEV_LOOKUP
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_ARM_SCU if SMP
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
