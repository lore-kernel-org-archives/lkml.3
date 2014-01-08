Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbaAHUAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:00:21 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:51548 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaAHUAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:00:15 -0500
MIME-Version: 1.0
In-Reply-To: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
References: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
Date: Wed, 8 Jan 2014 18:00:14 -0200
Message-ID: <CAOMZO5CxKrc4_q6xRpkxxD3i5RRkTqm=zTy3txujyjf8-qVNkw@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: imx: add select on ARCH_MXC for cpufreq support
From: Fabio Estevam <festevam@gmail.com>
To: John Tobias <john.tobias.ph@gmail.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Wed, Jan 8, 2014 at 5:56 PM, John Tobias <john.tobias.ph@gmail.com> wrote:
> Moved ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP on ARCH_MXC so that
> the user can enable the cpufreq support for iMX6Q and/or iMX6SL.
>
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
> ---
>  arch/arm/mach-imx/Kconfig | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 7a6e6f7..3c326be 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -1,5 +1,6 @@
>  config ARCH_MXC
>         bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
> +       select ARCH_HAS_CPUFREQ
>         select ARCH_REQUIRE_GPIOLIB
>         select ARM_CPU_SUSPEND if PM
>         select ARM_PATCH_PHYS_VIRT
> @@ -9,8 +10,10 @@ config ARCH_MXC
>         select GENERIC_ALLOCATOR
>         select GENERIC_CLOCKEVENTS
>         select GENERIC_IRQ_CHIP
> +       select HAVE_IMX_ANATOP

This option is for mx6 only, so better not put it inside ARCH_MXC.

Regards,

Fabio Estevam
