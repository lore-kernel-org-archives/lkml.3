Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab3GZKgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:36:08 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37011 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab3GZKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:36:03 -0400
Date: Fri, 26 Jul 2013 12:35:59 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/10] ARM: sun6i: Add restart code for the A31
Message-ID: <20130726123559.66216580@skate>
In-Reply-To: <1374618312-19001-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
	<1374618312-19001-5-git-send-email-maxime.ripard@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Maxime Ripard,

On Wed, 24 Jul 2013 00:25:06 +0200, Maxime Ripard wrote:
> The Allwinner A31 has a sligthly different watchdog that requires a
> different restart code.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-sunxi/sunxi.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> index 11326d9..c18ef3a 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -32,6 +32,15 @@
>  #define SUN4I_WATCHDOG_MODE_ENABLE		(1 << 0)
>  #define SUN4I_WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
>  
> +#define SUN6I_WATCHDOG1_IRQ_REG		0x00
> +#define SUN6I_WATCHDOG1_CTRL_REG	0x10
> +#define SUN6I_WATCHDOG1_CTRL_RESTART		(1 << 0)
> +#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
> +#define SUN6I_WATCHDOG1_CONFIG_RESTART		(1 << 0)
> +#define SUN6I_WATCHDOG1_CONFIG_IRQ		(1 << 1)
> +#define SUN6I_WATCHDOG1_MODE_REG	0x18
> +#define SUN6I_WATCHDOG1_MODE_ENABLE		(1 << 0)

Alignment is not nice, and the BIT() macro should be used.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
