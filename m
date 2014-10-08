Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaJHU0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:26:53 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64646 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaJHU0v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:26:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 0/7] ARM: SoC changes for 3.18
Date: Wed, 08 Oct 2014 22:23:29 +0200
Message-ID: <1922034.HH2lvbiFi0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:tcFKULP1+0fKv/W6A+R0OReU64UxdC0S/bweqmGEsOG
 n+uGcYnF/R61RniG7JgTtOz+zL/txYAd7H8cvhOsK16PMBFUtG
 fh/C9ba1YFkwhT3MVMG2gF1I4mO3KYprAvS7wb7POvcQIpvrpO
 ljADrje00UPk/e5U/6NKNflTjVRhsh1o6/SH1IQ3Fs4yaG4++o
 8MsYITYbgzMXyh0AUpxIf8hdoiIrUMt9gJopL3KHIyJHUoGMrO
 PHLyyuDqXaAaaRCPP7g3ir1qTuClucmSDbQ6rDIC4PyLMOfEOJ
 Sh7Wrq4elbioWxPcIZKuVaHC6v49JrLsMdNaaYBS+GSABe9oky
 x/41Pl7iFNrbk3llUyQg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sending out the main pull requests for arm-soc now. It feels smaller than
usual, but we also rejected a number of branches late in the cycle after
you announced that you'd do an early 3.17 release.

As usual, DT changes make up the bulk of this, although less so than
previously. One reason for this is a relatively large driver for the TI
keystone platform that skews the statistics.

The total size of arch/arm/mach-*/ keeps going down (2782 insertions,
5825 deletions) as we remove files that are obsoleted by the DT
migration, which is good. Unfortunately, no additional platforms have
become 'multiplatform' aware this time. I have plans and patches for
at least five platforms that are still mutually exclusive with all others,
but it did not work out this time.

Platform-wise the majority of the patches this time are for shmobile
and omap, which is fairly common. However, a lot of work is going into
sunxi as well, which is largely driven by hobbyists and has not
traditionally seen such a bulk of work going in in the past.
imx and at91 show up high in the dirstat because of removed code.
A couple of new platforms have just started appearing, but support
is very minimal.

	Arnd

Some brief statistics:

 702 non-merge changesets
  98 merges
 139 individual contributors
 625 files changed, 26029 insertions(+), 9052 deletions(-)

Contributors with 5 patches/merges or more:
79 Arnd Bergmann  
40 Magnus Damm 
39 Felipe Balbi
37 Geert Uytterhoeven
36 Maxime Ripard
25 Olof Johansson
25 Nishanth Menon
22 Chen-Yu Tsai 
19 Fabio Estevam 
19 Alexandre Belloni
18 Tony Lindgren
16 Simon Horman 
14 Laurent Pinchart
12 Ulrich Hecht 
11 Soren Brinkmann
11 Alexander Shiyan
10 Shawn Guo 
10 Nicolas Ferre 
10 Marek Belisko
9 Santosh Shilimkar
9 Heiko Stuebner
8 Peter Ujfalusi
8 Matthias Brugger
8 Doug Anderson
8 Andrew Lunn 
7 Tim Harvey 
7 Stephen Warren
7 Stefan Agner 
7 Linus Walleij 
7 Haojian Zhuang
7 Dmitry Lifshitz
7 Carlo Caione
7 Boris BREZILLON 
6 Zhangfei Gao 
6 Thomas Petazzoni
6 Shengjiu Wang 
6 Rajendra Nayak
6 Michal Simek 
6 Mark Brown 
6 Grygorii Strashko
6 Florian Fainelli
6 Ezequiel Garcia
6 Emilio López 
6 Bo Shen 
5 Thierry Reding 
5 Stephen Boyd 
5 Krzysztof Ha�~Basa
5 Javier Martinez Canillas
5 Heiko Stübner 
5 Georgi Djakov 
5 Anson Huang 

Dirstat (0.1% cutoff):

   0.7% Documentation/devicetree/bindings/arm/
   0.2% Documentation/devicetree/bindings/leds/
   0.4% Documentation/devicetree/bindings/mailbox/
   1.2% Documentation/devicetree/bindings/soc/ti/
   0.1% Documentation/devicetree/bindings/
  42.2% arch/arm/boot/dts/
   0.9% arch/arm/configs/
   0.1% arch/arm/include/debug/
   0.3% arch/arm/mach-at91/include/mach/
   6.1% arch/arm/mach-at91/
   0.1% arch/arm/mach-bcm/
   0.6% arch/arm/mach-clps711x/
   0.2% arch/arm/mach-cns3xxx/
   1.1% arch/arm/mach-hisi/
   8.4% arch/arm/mach-imx/
   0.1% arch/arm/mach-integrator/
   0.1% arch/arm/mach-meson/
   0.2% arch/arm/mach-msm/
   4.1% arch/arm/mach-omap2/
   0.2% arch/arm/mach-pxa/
   0.3% arch/arm/mach-s3c24xx/
   3.5% arch/arm/mach-shmobile/
   0.2% arch/arm/mach-sunxi/
   0.1% arch/arm/mach-tegra/
   0.6% arch/arm/mach-zynq/
   1.9% arch/arm/plat-omap/
   2.0% arch/arm/
   1.3% arch/arm64/boot/dts/
   0.3% drivers/clk/at91/
   0.9% drivers/clocksource/
   1.2% drivers/edac/
   0.9% drivers/irqchip/
   0.5% drivers/leds/
   0.5% drivers/mailbox/
   0.3% drivers/memory/
   0.1% drivers/mfd/
   0.2% drivers/misc/
   1.6% drivers/power/reset/
   1.3% drivers/rtc/
  10.1% drivers/soc/ti/
   0.4% drivers/soc/versatile/
   0.1% drivers/
   0.7% include/dt-bindings/clock/
   0.1% include/linux/irqchip/
   0.8% include/linux/soc/ti/
   0.3% include/linux/

