Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaFTEvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:51:36 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52308 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaFTEvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140619215140.259138132@linutronix.de>
References: <20140619214858.755664030@linutronix.de>
	<20140619215140.259138132@linutronix.de>
Date: Fri, 20 Jun 2014 10:21:34 +0530
X-Google-Sender-Auth: 34ZuvqcA59P43AKVfRvjAbpIsiA
Message-ID: <CAOh2x==Z3506u2DGZfRyTPs809npg0kZwMmNVV2C3X3dBKmDOw@mail.gmail.com>
Subject: Re: [patch 1/2] clk: spear3xx: Use proper control register offset
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        spear-devel <spear-devel@list.st.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 3:22 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The control register is at offset 0x10, not 0x0. This is wreckaged
> since commit 5df33a62c (SPEAr: Switch to common clock framework).
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/clk/spear/spear3xx_clock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/drivers/clk/spear/spear3xx_clock.c
> ===================================================================
> --- linux.orig/drivers/clk/spear/spear3xx_clock.c
> +++ linux/drivers/clk/spear/spear3xx_clock.c
> @@ -211,7 +211,7 @@ static inline void spear310_clk_init(voi
>  /* array of all spear 320 clock lookups */
>  #ifdef CONFIG_MACH_SPEAR320
>
> -#define SPEAR320_CONTROL_REG           (soc_config_base + 0x0000)
> +#define SPEAR320_CONTROL_REG           (soc_config_base + 0x0010)
>  #define SPEAR320_EXT_CTRL_REG          (soc_config_base + 0x0018)
>
>         #define SPEAR320_UARTX_PCLK_MASK                0x1

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
