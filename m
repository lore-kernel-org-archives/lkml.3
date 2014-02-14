Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaBNKb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:31:57 -0500
Received: from [216.32.180.31] ([216.32.180.31]:42371 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbaBNKb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:31:56 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 11
X-BigFish: VS11(z3197rzzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21bch1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Steven Miao <realmz6@gmail.com>, <pebolle@tiscali.nl>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] blackfin: Remove non-existed Kconfig symbol VIDEO_MT9M114
Date: Fri, 14 Feb 2014 18:32:43 +0800
Message-ID: <1392373963-29517-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Bind different groups of one pinmux function to respective state names.
Add all states at once, no need to exclude each other by Kconfig symbol.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 arch/blackfin/mach-bf548/boards/ezkit.c |  6 ++++--
 arch/blackfin/mach-bf609/boards/ezkit.c | 17 ++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index d495000..b5a8c87 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -2124,7 +2124,7 @@ static struct pinctrl_map __initdata bfin_pinmux_map[] = {
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-rotary",  "pinctrl-adi2.0", NULL, "rotary"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin_can.0",  "pinctrl-adi2.0", NULL, "can0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin_can.1",  "pinctrl-adi2.0", NULL, "can1"),
-	PIN_MAP_MUX_GROUP_DEFAULT("bf54x-lq043",  "pinctrl-adi2.0", NULL, "ppi0_24b"),
+	PIN_MAP_MUX_GROUP_DEFAULT("bf54x-lq043",  "pinctrl-adi2.0", "ppi0_24bgrp", "ppi0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-i2s.0",  "pinctrl-adi2.0", NULL, "sport0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-tdm.0",  "pinctrl-adi2.0", NULL, "sport0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-ac97.0",  "pinctrl-adi2.0", NULL, "sport0"),
@@ -2146,7 +2146,9 @@ static struct pinctrl_map __initdata bfin_pinmux_map[] = {
 	PIN_MAP_MUX_GROUP_DEFAULT("pata-bf54x",  "pinctrl-adi2.0", NULL, "atapi_alter"),
 #endif
 	PIN_MAP_MUX_GROUP_DEFAULT("bf5xx-nand.0",  "pinctrl-adi2.0", NULL, "nfc0"),
-	PIN_MAP_MUX_GROUP_DEFAULT("bf54x-keys",  "pinctrl-adi2.0", NULL, "keys_4x4"),
+	PIN_MAP_MUX_GROUP_DEFAULT("bf54x-keys",  "pinctrl-adi2.0", "keys_4x4grp", "keys"),
+	PIN_MAP_MUX_GROUP("bf54x-keys", "4bit",  "pinctrl-adi2.0", "keys_4x4grp", "keys"),
+	PIN_MAP_MUX_GROUP("bf54x-keys", "8bit",  "pinctrl-adi2.0", "keys_8x8grp", "keys"),
 };
 
 static int __init ezkit_init(void)
diff --git a/arch/blackfin/mach-bf609/boards/ezkit.c b/arch/blackfin/mach-bf609/boards/ezkit.c
index 8de8bc6..b3147f0 100644
--- a/arch/blackfin/mach-bf609/boards/ezkit.c
+++ b/arch/blackfin/mach-bf609/boards/ezkit.c
@@ -2073,15 +2073,14 @@ static struct pinctrl_map __initdata bfin_pinmux_map[] = {
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-rotary",  "pinctrl-adi2.0", NULL, "rotary"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin_can.0",  "pinctrl-adi2.0", NULL, "can0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("physmap-flash.0",  "pinctrl-adi2.0", NULL, "smc0"),
-	PIN_MAP_MUX_GROUP_DEFAULT("bf609_nl8048.2",  "pinctrl-adi2.0", NULL, "ppi2_16b"),
-	PIN_MAP_MUX_GROUP_DEFAULT("bfin_display.0",  "pinctrl-adi2.0", NULL, "ppi0_16b"),
-#if defined(CONFIG_VIDEO_MT9M114) || defined(CONFIG_VIDEO_MT9M114_MODULE)
-	PIN_MAP_MUX_GROUP_DEFAULT("bfin_capture.0",  "pinctrl-adi2.0", NULL, "ppi0_8b"),
-#elif defined(CONFIG_VIDEO_VS6624) || defined(CONFIG_VIDEO_VS6624_MODULE)
-	PIN_MAP_MUX_GROUP_DEFAULT("bfin_capture.0",  "pinctrl-adi2.0", NULL, "ppi0_16b"),
-#else
-	PIN_MAP_MUX_GROUP_DEFAULT("bfin_capture.0",  "pinctrl-adi2.0", NULL, "ppi0_24b"),
-#endif
+	PIN_MAP_MUX_GROUP_DEFAULT("bf609_nl8048.2",  "pinctrl-adi2.0", "ppi2_16bgrp", "ppi2"),
+	PIN_MAP_MUX_GROUP("bfin_display.0", "8bit",  "pinctrl-adi2.0", "ppi2_8bgrp", "ppi2"),
+	PIN_MAP_MUX_GROUP_DEFAULT("bfin_display.0",  "pinctrl-adi2.0", "ppi2_16bgrp", "ppi2"),
+	PIN_MAP_MUX_GROUP("bfin_display.0", "16bit",  "pinctrl-adi2.0", "ppi2_16bgrp", "ppi2"),
+	PIN_MAP_MUX_GROUP("bfin_capture.0", "8bit",  "pinctrl-adi2.0", "ppi0_8bgrp", "ppi0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("bfin_capture.0",  "pinctrl-adi2.0", "ppi0_16bgrp", "ppi0"),
+	PIN_MAP_MUX_GROUP("bfin_capture.0", "16bit",  "pinctrl-adi2.0", "ppi0_16bgrp", "ppi0"),
+	PIN_MAP_MUX_GROUP("bfin_capture.0", "24bit",  "pinctrl-adi2.0", "ppi0_24bgrp", "ppi0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-i2s.0",  "pinctrl-adi2.0", NULL, "sport0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-tdm.0",  "pinctrl-adi2.0", NULL, "sport0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("bfin-i2s.1",  "pinctrl-adi2.0", NULL, "sport1"),
-- 
1.8.2.3


