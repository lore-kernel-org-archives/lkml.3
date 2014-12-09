Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaLIVVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:21:37 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:62876 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaLIVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:21:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/9] ARM: SoC changes for 3.19
Date: Tue, 09 Dec 2014 22:20:34 +0100
Message-ID: <4491193.a6KEQb1tZH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:N9qqRomL8OubAxKS/238H88TwPt9j56zyijKwZNu36H6Lq6wBYu
 n68inxrDpgv5HCnuvs9P22cMSkNbWbtQvm5Npv63QCK1zKpMCkGYG94lyhqjQHahGo1rHjq
 aLcmu7YA4t+YCscn8c505Hn4dVLd6UTLfzaH3OONXnSG8Lqr69uYhHRYjiiSdTIzI2KnnEB
 NBzQI6vU0+q4BNSkr7Afw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the 3.19 set of branches for ARM SoC related changes. As usual,
about half the additions are for device tree files, both counting the
number of patches and number of lines. The other changes are all dwarfed
by the removal of the remaining legacy machine support in the Atmel at91
platform, now that this platform has sufficient DT support.

Aside from this one-time peak for at91, the most active platforms remain
shmobile, omap, sunxi and exynos.

We are also adding a record number of 12 new arm32 SoC types and 2
arm64 SoC types in this merge window, with at least four more that
almost made it in but were a little late.

This is also the first time we do not have 'boards' branch that tracks
changes to board specific files any more: We now support 527 individual
machine types with device tree and have 258 old-style board files, but
the latter are rarely updated these days.

Total number of changesets (including merges): 1120
Total number of merge changesets: 147
Total number of contributors: 170

Overall diffstat:
 867 files changed, 37747 insertions(+), 36520 deletions(-)

Dirstat:
$ git diff --dirstat=0.2 v3.18..for-next
   0.4% Documentation/devicetree/bindings/arm/
   0.5% Documentation/devicetree/bindings/
  31.7% arch/arm/boot/dts/
   1.4% arch/arm/configs/
   0.2% arch/arm/include/
   0.8% arch/arm/kernel/
  30.4% arch/arm/mach-at91/
   0.5% arch/arm/mach-bcm/
   0.4% arch/arm/mach-davinci/
   3.9% arch/arm/mach-exynos/
   0.6% arch/arm/mach-imx/
   0.6% arch/arm/mach-integrator/
   1.1% arch/arm/mach-mvebu/
   5.0% arch/arm/mach-omap2/
   0.3% arch/arm/mach-pxa/
   0.2% arch/arm/mach-rockchip/
   2.9% arch/arm/mach-shmobile/
   1.0% arch/arm/mach-vexpress/
   0.2% arch/arm/mm/
   1.9% arch/arm/
   0.3% arch/arm64/boot/dts/amd/
   0.5% arch/arm64/boot/dts/arm/
   1.3% drivers/bus/
   0.3% drivers/clk/
   0.3% drivers/clocksource/
   2.5% drivers/dma/
   2.5% drivers/iommu/
   2.8% drivers/memory/tegra/
   1.1% drivers/memory/
   0.3% drivers/reset/sti/
   0.2% drivers/rtc/
   0.2% drivers/soc/versatile/
   0.6% drivers/
   0.4% include/dt-bindings/
   0.6% include/linux/

Top 20 contributors by patch count (no merges):
$ git log --format=%an --no-merges v3.18..for-next  | sort | uniq -c  |sort -nr | head -n 20
     56 Geert Uytterhoeven
     48 Maxime Ripard
     31 Tero Kristo
     29 Nicolas Ferre
     28 Chen-Yu Tsai
     26 Linus Walleij
     24 Thomas Petazzoni
     24 Kuninori Morimoto
     24 Hans de Goede
     22 Peter Griffin
     20 Tony Lindgren
     20 Laurent Pinchart
     19 Sebastian Hesselbarth
     18 Roger Quadros
     15 Arnaud Ebalard
     14 Simon Horman
     13 Arnd Bergmann
     12 Thierry Reding
     12 Dmitry Lifshitz
     11 Zhangfei Gao

