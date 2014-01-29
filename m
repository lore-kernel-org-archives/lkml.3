Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaA2T3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:29:52 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51500 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaA2T3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:29:50 -0500
MIME-Version: 1.0
In-Reply-To: <1391019557-22313-3-git-send-email-nm@ti.com>
References: <1391019557-22313-1-git-send-email-nm@ti.com>
	<1391019557-22313-3-git-send-email-nm@ti.com>
Date: Wed, 29 Jan 2014 13:29:50 -0600
Message-ID: <CAOCHtYjaCBn2oOk66ef9wiz_GJnVwHDyx446_mrkipPoENaeUQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: OMAP3+: add clock nodes for CPU
From: Robert Nelson <robertcnelson@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 12:19 PM, Nishanth Menon <nm@ti.com> wrote:
> OMAP34xx, AM3517 and OMAP36xx platforms use dpll1 clock.
>
> OMAP443x, OMAP446x, OMAP447x, OMAP5, DRA7, AM43xx platforms use
> dpll_mpu clock.
>
> Latency used is the generic latency defined in omap-cpufreq
> driver.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Hi Nishanth,

After this patch, do you see any limitation to finally enabling 1Ghz
operation on the beagle-xm by default? Or are we still missing a
dependicy somewhere?

cpufreq stats: 300 MHz:98.64%, 600 MHz:0.04%, 800 MHz:0.09%, 1000
MHz:1.23%  (11)
full cpufreq output: http://paste.debian.net/79073/

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts
b/arch/arm/boot/dts/omap3-beagle-xm.dts
index bb5dad0..b0e5863 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -16,9 +16,36 @@
        cpus {
                cpu@0 {
                        cpu0-supply = <&vcc>;
+                       operating-points = <
+                               /* kHz    uV */
+                               300000   1012500
+                               600000   1200000
+                               800000   1325000
+                               1000000  1380000
+                       >;
                };
        };

+       abb: regulator-abb {
+               compatible = "ti,abb-v1";
+               regulator-name = "abb";
+               #address-cell = <0>;
+               #size-cells = <0>;
+               reg = <0x483072f0 0x8>, <0x48306818 0x4>;
+               reg-names = "base-address", "int-address";
+               ti,tranxdone-status-mask = <0x4000000>;
+               clocks = <&dpll1_ck>;
+               ti,settling-time = <30>;
+               ti,clock-cycles = <8>;
+               ti,abb_info = <
+                       /* uV           ABB     efuse   rbb_m   fbb_m
 vset_m */
+                       1012500         0       0       0       0
 0 /* Bypass */
+                       1200000         3       0       0       0
 0 /* RBB mandatory */
+                       1320000         1       0       0       0
 0 /* FBB mandatory */
+                       1380000         1       0       0       0       0
+                       >;
+       };
+
        memory {
                device_type = "memory";
                reg = <0x80000000 0x20000000>; /* 512 MB */
-- 
1.8.5.3

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
