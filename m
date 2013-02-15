Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935342Ab3BOEyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 23:54:14 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42257 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3BOEyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 23:54:13 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1360880818-4071454-4-git-send-email-arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Maxime Ripard <maxime.ripard@anandra.org>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
 <1360880818-4071454-4-git-send-email-arnd@arndb.de>
Message-ID: <20130215045404.11471.91270@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 3/9] clk: sunxi: remove stale Makefile entry
Date: Thu, 14 Feb 2013 20:54:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (2013-02-14 14:26:52)
> Patch 85a18198 "clk: sunxi: Use common of_clk_init() function"
> removed the clk-sunxi.c file but left the Makefile entry, which
> causes a build error in multi_v7_defconfig:
> 
> make[4]: *** No rule to make target `drivers/clk/clk-sunxi.o', needed by `drivers/clk/built-in.o'.
> 
> The obvious fix is to remove the extraneous line from the
> Makefile.
> 

The fix is correct.  I can't rebase my branch since there is an existing
dependency with the tegra tree, so I have taken this patch as-is with
the addition of my SoB.

Thanks,
Mike

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Prashant Gaikwad <pgaikwad@nvidia.com>
> Cc: Maxime Ripard <maxime.ripard@anandra.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/Makefile | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index ce77077..be9392e 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -25,7 +25,6 @@ endif
>  obj-$(CONFIG_MACH_LOONGSON1)   += clk-ls1x.o
>  obj-$(CONFIG_ARCH_U8500)       += ux500/
>  obj-$(CONFIG_ARCH_VT8500)      += clk-vt8500.o
> -obj-$(CONFIG_ARCH_SUNXI)       += clk-sunxi.o
>  obj-$(CONFIG_ARCH_ZYNQ)                += clk-zynq.o
>  obj-$(CONFIG_X86)              += x86/
>  obj-$(CONFIG_ARCH_TEGRA)       += tegra/
> -- 
> 1.8.1.2
