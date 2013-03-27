Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3C0TCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:02:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3C0TCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:02:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.10 #2
Date: Wed, 27 Mar 2013 19:01:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>
References: <5152B357.3020500@atmel.com>
In-Reply-To: <5152B357.3020500@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303271902.00068.arnd@arndb.de>
X-Provags-ID: V02:K0:rk792K/swKdDwX1SMTVFDxkFgxPW2qvjXlDFoVeLokC
 IzQ96pBXJ6Ng45JYrvVoxdbCJMNteZZPD9SNYeH5n0ZKH9yZLY
 TtS1cqhjhIAz5TE/bZeXnisF1YO2BI3bMs0fSc0yM0b5XGk6VE
 bP4C774wIZMr1fU5oiUl/VaUjaeX3OT2prQ992byzpvr9Uo03/
 Dg2KyxMKZUNAdn8Be1s74VrDhH/GSe1bGjnXwlZ7Q9GJSpvFKa
 ZgL8EWom0gG+vLSaYONXenQUdvUWl8RXUNB61c1wDpka2f2MlV
 52CBA0UMPD14+k2XsKLjzo33VbMRNaTW2RbYk4MUAN5hxc3FMx
 +AjoTSi3RW4O3ee4w58c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 March 2013, Nicolas Ferre wrote:

> ----------------------------------------------------------------
> Introduction of new Atmel Cortex-A5: SAMA5D3 family.
> - Modify AT91 Kconfig to plit ARMv4/5 and ARMv7 arch
> - Modify PMC driver (clocks)
> - Core SAMA5 support
> - Board file, DT files and defconfig

Looks really good. Olof said he'd take over merging tomorrow,
so I'll leave it for him.

> ----------------------------------------------------------------
> Ludovic Desroches (6):
>       ARM: at91: change name template in AT91_SOC_START macro
>       ARM: at91: add AT91_SAM9_TIME entry to select at91sam926x_time.c compilation
>       ARM: at91: introduce the core type choice to split ARMv4/5 and ARMv7 arch
>       ARM: at91: introduce SAMA5 support
>       ARM: at91: dt: add device tree files for SAMA5D3 family
>       ARM: at91: add defconfig for SAMA5

There is one obvious change that would be nice to include here,
can you add this on top (either Nicolas or Olof)?

8<---------
Subject: ARM: at91: make ATAGS support conditional on CONFIG_ATAGS

We have the global CONFIG_ATAGS symbol that is used to determine
whether ATAGS based boot is possible or not. Since we are
splitting out the legacy boards from the main Kconfig on at91,
we can use that symbol to easily hide the old options.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 0280238..119a0a4 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -137,8 +137,9 @@ config SOC_AT91SAM9N12
 	  Select this if you are using Atmel's AT91SAM9N12 SoC.
 
 # ----------------------------------------------------------
-
+if ATAGS
 source arch/arm/mach-at91/Kconfig.non_dt
+endif
 endif # SOC_SAM_V4_V5
 
 comment "Generic Board Type"
