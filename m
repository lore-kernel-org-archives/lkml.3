Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaAMF7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 00:59:51 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:10114
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbaAMF7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 00:59:49 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579ehz98dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 13 Jan 2014 14:01:04 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: John Tobias <john.tobias.ph@gmail.com>
CC: <rjw@rjwysocki.net>, Viresh Kumar <viresh.kumar@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<kernel@pengutronix.de>" <kernel@pengutronix.de>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: imx: add select on ARCH_MXC for cpufreq
 support
Message-ID: <20140113060102.GO23525@S2101-09.ap.freescale.net>
References: <1389321592-33220-1-git-send-email-john.tobias.ph@gmail.com>
 <20140113032043.GF23525@S2101-09.ap.freescale.net>
 <CACUGKYMx_o6TLsvMxK3Gb+cmOUCX3Toj+6MeJmo=ahfyc=vXCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACUGKYMx_o6TLsvMxK3Gb+cmOUCX3Toj+6MeJmo=ahfyc=vXCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 08:54:18PM -0800, John Tobias wrote:
> I tested leaving the HAVE_IMX_ANATOP under SOC_IMX6Q and SOC_IMX6SL.
> The iMX6Q cpufreq driver won't show up in menu config / gconfig and
> that's the reason why I added it.

I tested the following changes against my for-next branch, and I can see
iMX6Q cpufreq driver in menuconfig.  Note, the
drivers/cpufreq/Kconfig.arm change is on cpufreq tree, so I have to make
the change locally for the testing.

Shawn

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 1e70150..7071468 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -1,5 +1,7 @@
 config ARCH_MXC
        bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 ||
ARCH_MULTI_V6_V7
+       select ARCH_HAS_CPUFREQ
+       select ARCH_HAS_OPP
        select ARCH_REQUIRE_GPIOLIB
        select ARM_CPU_SUSPEND if PM
        select ARM_PATCH_PHYS_VIRT
@@ -12,6 +14,7 @@ config ARCH_MXC
        select MIGHT_HAVE_CACHE_L2X0 if ARCH_MULTI_V6_V7
        select MULTI_IRQ_HANDLER
        select PINCTRL
+       select PM_OPP if PM
        select SOC_BUS
        select SPARSE_IRQ
        select USE_OF
@@ -787,8 +790,6 @@ config      SOC_IMX53

 config SOC_IMX6Q
        bool "i.MX6 Quad/DualLite support"
-       select ARCH_HAS_CPUFREQ
-       select ARCH_HAS_OPP
        select ARM_ERRATA_754322
        select ARM_ERRATA_764369 if SMP
        select ARM_ERRATA_775420
@@ -808,7 +809,6 @@ config SOC_IMX6Q
        select PL310_ERRATA_588369 if CACHE_PL310
        select PL310_ERRATA_727915 if CACHE_PL310
        select PL310_ERRATA_769419 if CACHE_PL310
-       select PM_OPP if PM

        help
          This enables support for Freescale i.MX6 Quad processor.
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index ce52ed9..21e069e 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -80,7 +80,7 @@ config ARM_HIGHBANK_CPUFREQ

 config ARM_IMX6Q_CPUFREQ
        tristate "Freescale i.MX6Q cpufreq support"
-       depends on SOC_IMX6Q
+       depends on ARCH_MXC
        depends on REGULATOR_ANATOP
        help
          This adds cpufreq driver support for Freescale i.MX6Q SOC.


