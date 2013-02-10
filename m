Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3BJR2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 12:28:31 -0500
Received: from mout.gmx.net ([212.227.17.20]:52576 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab3BJR23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 12:28:29 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX19Yay1tFrhY0/CatIxwpKKxE2iMREJu3sV1qG8gbA
	7u0Mp+YePX4M2Z
From: Marc Dietrich <marvin24@gmx.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        arnd@arndb.de, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Date: Sun, 10 Feb 2013 18:28:14 +0100
Message-ID: <2499199.srlLvkihNZ@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-21-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <51153136.7010705@wwwdotorg.org>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com> <340098510.UosBEPkrGv@fb07-iapwap2> <51153136.7010705@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2013 10:09:10 Stephen Warren wrote:
> On 02/08/2013 05:29 AM, Marc Dietrich wrote:
> > Hiroshi,
> > 
> > Am Freitag, 8. Februar 2013, 09:29:31 schrieb Hiroshi Doyu:
> >> Refactored tegra{20,30,114}_init_early() so that we have the unified
> >> tegra_init_early().
> >> 
> >> diff --git a/arch/arm/mach-tegra/hotplug.c
> >> b/arch/arm/mach-tegra/hotplug.c
> >> 
> >> +void __init tegra_hotplug_init(void)
> >> 
> >>  {
> >> 
> >> +	switch (tegra_chip_id) {
> >> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> >> +	case TEGRA20:
> >> +		tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
> >> +		break;
> >> 
> >>  #endif
> >> 
> >> +#if defined(CONFIG_ARCH_TEGRA_3x_SOC)
> >> +	case TEGRA30:
> >> +		tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
> >> +		break;
> >> 
> >>  #endif
> >> 
> >> +	default:
> >> +		BUG_ON(IS_ENABLED(CONFIG_HOTPLUG_CPU));
> >> +		break;
> >> +	}
> >> +}
> > 
> > are these ifdefs really needed? Multisoc kernels will enable them all
> > anyway and there is a case structure which protects the assignments. Also
> > the hotplug functions are very tiny, so there shouldn't be a big loss.
> 
> The files that contain/implement those functions are separate for each
> SoC and only included in the build when the individual SoCs are enabled.
> 
> While multi-platform SoCs do make sense for distros, we also very
> specifically want to support the case where only Tegra, and only a
> single Tegra SoC, is enabled, hence this separation.

Huh? so tegra_defconfig is not supported?

grep "TEGRA_.*_SOC" tegra_defconfig:

CONFIG_ARCH_TEGRA_2x_SOC=y
CONFIG_ARCH_TEGRA_3x_SOC=y

Marc

