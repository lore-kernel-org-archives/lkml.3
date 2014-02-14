Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaBNKSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:18:25 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:22113
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbaBNKSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:18:23 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VS9(zze0eaha1fflb922lzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21bch1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Steven Miao <realmz6@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] pinctrl: pinctrl-adi: combine multiple groups of one function together
Date: Fri, 14 Feb 2014 18:21:06 +0800
Message-ID: <1392373266-28806-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The data pins of some peripheral are different if connecting to different
devices in one pinmux function. In the PPI case, data pins can be used
in 8, 16 and 24 pin groups individually. Add these groups into one ppi
function.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/pinctrl/pinctrl-adi2-bf54x.c | 138 +++++++++++++++++------------------
 drivers/pinctrl/pinctrl-adi2-bf60x.c | 128 ++++++++++++++++----------------
 drivers/pinctrl/pinctrl-adi2.c       |  12 +--
 drivers/pinctrl/pinctrl-adi2.h       |   8 +-
 4 files changed, 139 insertions(+), 147 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-adi2-bf54x.c b/drivers/pinctrl/pinctrl-adi2-bf54x.c
index ea9d9ab..008a29e 100644
--- a/drivers/pinctrl/pinctrl-adi2-bf54x.c
+++ b/drivers/pinctrl/pinctrl-adi2-bf54x.c
@@ -309,39 +309,6 @@ static const unsigned keys_8x8_pins[] = {
 	GPIO_PE4, GPIO_PE5, GPIO_PE6, GPIO_PE7,
 };
 
-static const struct adi_pin_group adi_pin_groups[] = {
-	ADI_PIN_GROUP("uart0grp", uart0_pins),
-	ADI_PIN_GROUP("uart1grp", uart1_pins),
-	ADI_PIN_GROUP("uart1ctsrtsgrp", uart1_ctsrts_pins),
-	ADI_PIN_GROUP("uart2grp", uart2_pins),
-	ADI_PIN_GROUP("uart3grp", uart3_pins),
-	ADI_PIN_GROUP("uart3ctsrtsgrp", uart3_ctsrts_pins),
-	ADI_PIN_GROUP("rsi0grp", rsi0_pins),
-	ADI_PIN_GROUP("spi0grp", spi0_pins),
-	ADI_PIN_GROUP("spi1grp", spi1_pins),
-	ADI_PIN_GROUP("twi0grp", twi0_pins),
-	ADI_PIN_GROUP("twi1grp", twi1_pins),
-	ADI_PIN_GROUP("rotarygrp", rotary_pins),
-	ADI_PIN_GROUP("can0grp", can0_pins),
-	ADI_PIN_GROUP("can1grp", can1_pins),
-	ADI_PIN_GROUP("smc0grp", smc0_pins),
-	ADI_PIN_GROUP("sport0grp", sport0_pins),
-	ADI_PIN_GROUP("sport1grp", sport1_pins),
-	ADI_PIN_GROUP("sport2grp", sport2_pins),
-	ADI_PIN_GROUP("sport3grp", sport3_pins),
-	ADI_PIN_GROUP("ppi0_8bgrp", ppi0_8b_pins),
-	ADI_PIN_GROUP("ppi0_16bgrp", ppi0_16b_pins),
-	ADI_PIN_GROUP("ppi0_24bgrp", ppi0_24b_pins),
-	ADI_PIN_GROUP("ppi1_8bgrp", ppi1_8b_pins),
-	ADI_PIN_GROUP("ppi1_16bgrp", ppi1_16b_pins),
-	ADI_PIN_GROUP("ppi2_8bgrp", ppi2_8b_pins),
-	ADI_PIN_GROUP("atapigrp", atapi_pins),
-	ADI_PIN_GROUP("atapialtergrp", atapi_alter_pins),
-	ADI_PIN_GROUP("nfc0grp", nfc0_pins),
-	ADI_PIN_GROUP("keys_4x4grp", keys_4x4_pins),
-	ADI_PIN_GROUP("keys_8x8grp", keys_8x8_pins),
-};
-
 static const unsigned short uart0_mux[] = {
 	P_UART0_TX, P_UART0_RX,
 	0
@@ -513,6 +480,39 @@ static const unsigned short keys_8x8_mux[] = {
 	0
 };
 
+static const struct adi_pin_group adi_pin_groups[] = {
+	ADI_PIN_GROUP("uart0grp", uart0_pins, uart0_mux),
+	ADI_PIN_GROUP("uart1grp", uart1_pins, uart1_mux),
+	ADI_PIN_GROUP("uart1ctsrtsgrp", uart1_ctsrts_pins, uart1_ctsrts_mux),
+	ADI_PIN_GROUP("uart2grp", uart2_pins, uart2_mux),
+	ADI_PIN_GROUP("uart3grp", uart3_pins, uart3_mux),
+	ADI_PIN_GROUP("uart3ctsrtsgrp", uart3_ctsrts_pins, uart3_ctsrts_mux),
+	ADI_PIN_GROUP("rsi0grp", rsi0_pins, rsi0_mux),
+	ADI_PIN_GROUP("spi0grp", spi0_pins, spi0_mux),
+	ADI_PIN_GROUP("spi1grp", spi1_pins, spi1_mux),
+	ADI_PIN_GROUP("twi0grp", twi0_pins, twi0_mux),
+	ADI_PIN_GROUP("twi1grp", twi1_pins, twi1_mux),
+	ADI_PIN_GROUP("rotarygrp", rotary_pins, rotary_mux),
+	ADI_PIN_GROUP("can0grp", can0_pins, can0_mux),
+	ADI_PIN_GROUP("can1grp", can1_pins, can1_mux),
+	ADI_PIN_GROUP("smc0grp", smc0_pins, smc0_mux),
+	ADI_PIN_GROUP("sport0grp", sport0_pins, sport0_mux),
+	ADI_PIN_GROUP("sport1grp", sport1_pins, sport1_mux),
+	ADI_PIN_GROUP("sport2grp", sport2_pins, sport2_mux),
+	ADI_PIN_GROUP("sport3grp", sport3_pins, sport3_mux),
+	ADI_PIN_GROUP("ppi0_8bgrp", ppi0_8b_pins, ppi0_8b_mux),
+	ADI_PIN_GROUP("ppi0_16bgrp", ppi0_16b_pins, ppi0_16b_mux),
+	ADI_PIN_GROUP("ppi0_24bgrp", ppi0_24b_pins, ppi0_24b_mux),
+	ADI_PIN_GROUP("ppi1_8bgrp", ppi1_8b_pins, ppi1_8b_mux),
+	ADI_PIN_GROUP("ppi1_16bgrp", ppi1_16b_pins, ppi1_16b_mux),
+	ADI_PIN_GROUP("ppi2_8bgrp", ppi2_8b_pins, ppi2_8b_mux),
+	ADI_PIN_GROUP("atapigrp", atapi_pins, atapi_mux),
+	ADI_PIN_GROUP("atapialtergrp", atapi_alter_pins, atapi_alter_mux),
+	ADI_PIN_GROUP("nfc0grp", nfc0_pins, nfc0_mux),
+	ADI_PIN_GROUP("keys_4x4grp", keys_4x4_pins, keys_4x4_mux),
+	ADI_PIN_GROUP("keys_8x8grp", keys_8x8_pins, keys_8x8_mux),
+};
+
 static const char * const uart0grp[] = { "uart0grp" };
 static const char * const uart1grp[] = { "uart1grp" };
 static const char * const uart1ctsrtsgrp[] = { "uart1ctsrtsgrp" };
@@ -532,49 +532,45 @@ static const char * const sport0grp[] = { "sport0grp" };
 static const char * const sport1grp[] = { "sport1grp" };
 static const char * const sport2grp[] = { "sport2grp" };
 static const char * const sport3grp[] = { "sport3grp" };
-static const char * const ppi0_8bgrp[] = { "ppi0_8bgrp" };
-static const char * const ppi0_16bgrp[] = { "ppi0_16bgrp" };
-static const char * const ppi0_24bgrp[] = { "ppi0_24bgrp" };
-static const char * const ppi1_8bgrp[] = { "ppi1_8bgrp" };
-static const char * const ppi1_16bgrp[] = { "ppi1_16bgrp" };
-static const char * const ppi2_8bgrp[] = { "ppi2_8bgrp" };
+static const char * const ppi0grp[] = { "ppi0_8bgrp",
+					"ppi0_16bgrp",
+					"ppi0_24bgrp" };
+static const char * const ppi1grp[] = { "ppi1_8bgrp",
+					"ppi1_16bgrp" };
+static const char * const ppi2grp[] = { "ppi2_8bgrp" };
 static const char * const atapigrp[] = { "atapigrp" };
 static const char * const atapialtergrp[] = { "atapialtergrp" };
 static const char * const nfc0grp[] = { "nfc0grp" };
-static const char * const keys_4x4grp[] = { "keys_4x4grp" };
-static const char * const keys_8x8grp[] = { "keys_8x8grp" };
+static const char * const keysgrp[] = { "keys_4x4grp",
+					"keys_8x8grp" };
 
 static const struct adi_pmx_func adi_pmx_functions[] = {
-	ADI_PMX_FUNCTION("uart0", uart0grp, uart0_mux),
-	ADI_PMX_FUNCTION("uart1", uart1grp, uart1_mux),
-	ADI_PMX_FUNCTION("uart1_ctsrts", uart1ctsrtsgrp, uart1_ctsrts_mux),
-	ADI_PMX_FUNCTION("uart2", uart2grp, uart2_mux),
-	ADI_PMX_FUNCTION("uart3", uart3grp, uart3_mux),
-	ADI_PMX_FUNCTION("uart3_ctsrts", uart3ctsrtsgrp, uart3_ctsrts_mux),
-	ADI_PMX_FUNCTION("rsi0", rsi0grp, rsi0_mux),
-	ADI_PMX_FUNCTION("spi0", spi0grp, spi0_mux),
-	ADI_PMX_FUNCTION("spi1", spi1grp, spi1_mux),
-	ADI_PMX_FUNCTION("twi0", twi0grp, twi0_mux),
-	ADI_PMX_FUNCTION("twi1", twi1grp, twi1_mux),
-	ADI_PMX_FUNCTION("rotary", rotarygrp, rotary_mux),
-	ADI_PMX_FUNCTION("can0", can0grp, can0_mux),
-	ADI_PMX_FUNCTION("can1", can1grp, can1_mux),
-	ADI_PMX_FUNCTION("smc0", smc0grp, smc0_mux),
-	ADI_PMX_FUNCTION("sport0", sport0grp, sport0_mux),
-	ADI_PMX_FUNCTION("sport1", sport1grp, sport1_mux),
-	ADI_PMX_FUNCTION("sport2", sport2grp, sport2_mux),
-	ADI_PMX_FUNCTION("sport3", sport3grp, sport3_mux),
-	ADI_PMX_FUNCTION("ppi0_8b", ppi0_8bgrp, ppi0_8b_mux),
-	ADI_PMX_FUNCTION("ppi0_16b", ppi0_16bgrp, ppi0_16b_mux),
-	ADI_PMX_FUNCTION("ppi0_24b", ppi0_24bgrp, ppi0_24b_mux),
-	ADI_PMX_FUNCTION("ppi1_8b", ppi1_8bgrp, ppi1_8b_mux),
-	ADI_PMX_FUNCTION("ppi1_16b", ppi1_16bgrp, ppi1_16b_mux),
-	ADI_PMX_FUNCTION("ppi2_8b", ppi2_8bgrp, ppi2_8b_mux),
-	ADI_PMX_FUNCTION("atapi", atapigrp, atapi_mux),
-	ADI_PMX_FUNCTION("atapi_alter", atapialtergrp, atapi_alter_mux),
-	ADI_PMX_FUNCTION("nfc0", nfc0grp, nfc0_mux),
-	ADI_PMX_FUNCTION("keys_4x4", keys_4x4grp, keys_4x4_mux),
-	ADI_PMX_FUNCTION("keys_8x8", keys_8x8grp, keys_8x8_mux),
+	ADI_PMX_FUNCTION("uart0", uart0grp),
+	ADI_PMX_FUNCTION("uart1", uart1grp),
+	ADI_PMX_FUNCTION("uart1_ctsrts", uart1ctsrtsgrp),
+	ADI_PMX_FUNCTION("uart2", uart2grp),
+	ADI_PMX_FUNCTION("uart3", uart3grp),
+	ADI_PMX_FUNCTION("uart3_ctsrts", uart3ctsrtsgrp),
+	ADI_PMX_FUNCTION("rsi0", rsi0grp),
+	ADI_PMX_FUNCTION("spi0", spi0grp),
+	ADI_PMX_FUNCTION("spi1", spi1grp),
+	ADI_PMX_FUNCTION("twi0", twi0grp),
+	ADI_PMX_FUNCTION("twi1", twi1grp),
+	ADI_PMX_FUNCTION("rotary", rotarygrp),
+	ADI_PMX_FUNCTION("can0", can0grp),
+	ADI_PMX_FUNCTION("can1", can1grp),
+	ADI_PMX_FUNCTION("smc0", smc0grp),
+	ADI_PMX_FUNCTION("sport0", sport0grp),
+	ADI_PMX_FUNCTION("sport1", sport1grp),
+	ADI_PMX_FUNCTION("sport2", sport2grp),
+	ADI_PMX_FUNCTION("sport3", sport3grp),
+	ADI_PMX_FUNCTION("ppi0", ppi0grp),
+	ADI_PMX_FUNCTION("ppi1", ppi1grp),
+	ADI_PMX_FUNCTION("ppi2", ppi2grp),
+	ADI_PMX_FUNCTION("atapi", atapigrp),
+	ADI_PMX_FUNCTION("atapi_alter", atapialtergrp),
+	ADI_PMX_FUNCTION("nfc0", nfc0grp),
+	ADI_PMX_FUNCTION("keys", keysgrp),
 };
 
 static const struct adi_pinctrl_soc_data adi_bf54x_soc = {
diff --git a/drivers/pinctrl/pinctrl-adi2-bf60x.c b/drivers/pinctrl/pinctrl-adi2-bf60x.c
index bf57aea..4cb59fe 100644
--- a/drivers/pinctrl/pinctrl-adi2-bf60x.c
+++ b/drivers/pinctrl/pinctrl-adi2-bf60x.c
@@ -259,37 +259,6 @@ static const unsigned lp3_pins[] = {
 	GPIO_PF12, GPIO_PF13, GPIO_PF14, GPIO_PF15,
 };
 
-static const struct adi_pin_group adi_pin_groups[] = {
-	ADI_PIN_GROUP("uart0grp", uart0_pins),
-	ADI_PIN_GROUP("uart0ctsrtsgrp", uart0_ctsrts_pins),
-	ADI_PIN_GROUP("uart1grp", uart1_pins),
-	ADI_PIN_GROUP("uart1ctsrtsgrp", uart1_ctsrts_pins),
-	ADI_PIN_GROUP("rsi0grp", rsi0_pins),
-	ADI_PIN_GROUP("eth0grp", eth0_pins),
-	ADI_PIN_GROUP("eth1grp", eth1_pins),
-	ADI_PIN_GROUP("spi0grp", spi0_pins),
-	ADI_PIN_GROUP("spi1grp", spi1_pins),
-	ADI_PIN_GROUP("twi0grp", twi0_pins),
-	ADI_PIN_GROUP("twi1grp", twi1_pins),
-	ADI_PIN_GROUP("rotarygrp", rotary_pins),
-	ADI_PIN_GROUP("can0grp", can0_pins),
-	ADI_PIN_GROUP("smc0grp", smc0_pins),
-	ADI_PIN_GROUP("sport0grp", sport0_pins),
-	ADI_PIN_GROUP("sport1grp", sport1_pins),
-	ADI_PIN_GROUP("sport2grp", sport2_pins),
-	ADI_PIN_GROUP("ppi0_8bgrp", ppi0_8b_pins),
-	ADI_PIN_GROUP("ppi0_16bgrp", ppi0_16b_pins),
-	ADI_PIN_GROUP("ppi0_24bgrp", ppi0_24b_pins),
-	ADI_PIN_GROUP("ppi1_8bgrp", ppi1_8b_pins),
-	ADI_PIN_GROUP("ppi1_16bgrp", ppi1_16b_pins),
-	ADI_PIN_GROUP("ppi2_8bgrp", ppi2_8b_pins),
-	ADI_PIN_GROUP("ppi2_16bgrp", ppi2_16b_pins),
-	ADI_PIN_GROUP("lp0grp", lp0_pins),
-	ADI_PIN_GROUP("lp1grp", lp1_pins),
-	ADI_PIN_GROUP("lp2grp", lp2_pins),
-	ADI_PIN_GROUP("lp3grp", lp3_pins),
-};
-
 static const unsigned short uart0_mux[] = {
 	P_UART0_TX, P_UART0_RX,
 	0
@@ -446,6 +415,37 @@ static const unsigned short lp3_mux[] = {
         0
 };
 
+static const struct adi_pin_group adi_pin_groups[] = {
+	ADI_PIN_GROUP("uart0grp", uart0_pins, uart0_mux),
+	ADI_PIN_GROUP("uart0ctsrtsgrp", uart0_ctsrts_pins, uart0_ctsrts_mux),
+	ADI_PIN_GROUP("uart1grp", uart1_pins, uart1_mux),
+	ADI_PIN_GROUP("uart1ctsrtsgrp", uart1_ctsrts_pins, uart1_ctsrts_mux),
+	ADI_PIN_GROUP("rsi0grp", rsi0_pins, rsi0_mux),
+	ADI_PIN_GROUP("eth0grp", eth0_pins, eth0_mux),
+	ADI_PIN_GROUP("eth1grp", eth1_pins, eth1_mux),
+	ADI_PIN_GROUP("spi0grp", spi0_pins, spi0_mux),
+	ADI_PIN_GROUP("spi1grp", spi1_pins, spi1_mux),
+	ADI_PIN_GROUP("twi0grp", twi0_pins, twi0_mux),
+	ADI_PIN_GROUP("twi1grp", twi1_pins, twi1_mux),
+	ADI_PIN_GROUP("rotarygrp", rotary_pins, rotary_mux),
+	ADI_PIN_GROUP("can0grp", can0_pins, can0_mux),
+	ADI_PIN_GROUP("smc0grp", smc0_pins, smc0_mux),
+	ADI_PIN_GROUP("sport0grp", sport0_pins, sport0_mux),
+	ADI_PIN_GROUP("sport1grp", sport1_pins, sport1_mux),
+	ADI_PIN_GROUP("sport2grp", sport2_pins, sport2_mux),
+	ADI_PIN_GROUP("ppi0_8bgrp", ppi0_8b_pins, ppi0_8b_mux),
+	ADI_PIN_GROUP("ppi0_16bgrp", ppi0_16b_pins, ppi0_16b_mux),
+	ADI_PIN_GROUP("ppi0_24bgrp", ppi0_24b_pins, ppi0_24b_mux),
+	ADI_PIN_GROUP("ppi1_8bgrp", ppi1_8b_pins, ppi1_8b_mux),
+	ADI_PIN_GROUP("ppi1_16bgrp", ppi1_16b_pins, ppi1_16b_mux),
+	ADI_PIN_GROUP("ppi2_8bgrp", ppi2_8b_pins, ppi2_8b_mux),
+	ADI_PIN_GROUP("ppi2_16bgrp", ppi2_16b_pins, ppi2_16b_mux),
+	ADI_PIN_GROUP("lp0grp", lp0_pins, lp0_mux),
+	ADI_PIN_GROUP("lp1grp", lp1_pins, lp1_mux),
+	ADI_PIN_GROUP("lp2grp", lp2_pins, lp2_mux),
+	ADI_PIN_GROUP("lp3grp", lp3_pins, lp3_mux),
+};
+
 static const char * const uart0grp[] = { "uart0grp" };
 static const char * const uart0ctsrtsgrp[] = { "uart0ctsrtsgrp" };
 static const char * const uart1grp[] = { "uart1grp" };
@@ -463,47 +463,43 @@ static const char * const smc0grp[] = { "smc0grp" };
 static const char * const sport0grp[] = { "sport0grp" };
 static const char * const sport1grp[] = { "sport1grp" };
 static const char * const sport2grp[] = { "sport2grp" };
-static const char * const ppi0_8bgrp[] = { "ppi0_8bgrp" };
-static const char * const ppi0_16bgrp[] = { "ppi0_16bgrp" };
-static const char * const ppi0_24bgrp[] = { "ppi0_24bgrp" };
-static const char * const ppi1_8bgrp[] = { "ppi1_8bgrp" };
-static const char * const ppi1_16bgrp[] = { "ppi1_16bgrp" };
-static const char * const ppi2_8bgrp[] = { "ppi2_8bgrp" };
-static const char * const ppi2_16bgrp[] = { "ppi2_16bgrp" };
+static const char * const ppi0grp[] = { "ppi0_8bgrp",
+					"ppi0_16bgrp",
+					"ppi0_24bgrp" };
+static const char * const ppi1grp[] = { "ppi1_8bgrp",
+					"ppi1_16bgrp" };
+static const char * const ppi2grp[] = { "ppi2_8bgrp",
+					"ppi2_16bgrp" };
 static const char * const lp0grp[] = { "lp0grp" };
 static const char * const lp1grp[] = { "lp1grp" };
 static const char * const lp2grp[] = { "lp2grp" };
 static const char * const lp3grp[] = { "lp3grp" };
 
 static const struct adi_pmx_func adi_pmx_functions[] = {
-	ADI_PMX_FUNCTION("uart0", uart0grp, uart0_mux),
-	ADI_PMX_FUNCTION("uart0_ctsrts", uart0ctsrtsgrp, uart0_ctsrts_mux),
-	ADI_PMX_FUNCTION("uart1", uart1grp, uart1_mux),
-	ADI_PMX_FUNCTION("uart1_ctsrts", uart1ctsrtsgrp, uart1_ctsrts_mux),
-	ADI_PMX_FUNCTION("rsi0", rsi0grp, rsi0_mux),
-	ADI_PMX_FUNCTION("eth0", eth0grp, eth0_mux),
-	ADI_PMX_FUNCTION("eth1", eth1grp, eth1_mux),
-	ADI_PMX_FUNCTION("spi0", spi0grp, spi0_mux),
-	ADI_PMX_FUNCTION("spi1", spi1grp, spi1_mux),
-	ADI_PMX_FUNCTION("twi0", twi0grp, twi0_mux),
-	ADI_PMX_FUNCTION("twi1", twi1grp, twi1_mux),
-	ADI_PMX_FUNCTION("rotary", rotarygrp, rotary_mux),
-	ADI_PMX_FUNCTION("can0", can0grp, can0_mux),
-	ADI_PMX_FUNCTION("smc0", smc0grp, smc0_mux),
-	ADI_PMX_FUNCTION("sport0", sport0grp, sport0_mux),
-	ADI_PMX_FUNCTION("sport1", sport1grp, sport1_mux),
-	ADI_PMX_FUNCTION("sport2", sport2grp, sport2_mux),
-	ADI_PMX_FUNCTION("ppi0_8b", ppi0_8bgrp, ppi0_8b_mux),
-	ADI_PMX_FUNCTION("ppi0_16b", ppi0_16bgrp, ppi0_16b_mux),
-	ADI_PMX_FUNCTION("ppi0_24b", ppi0_24bgrp, ppi0_24b_mux),
-	ADI_PMX_FUNCTION("ppi1_8b", ppi1_8bgrp, ppi1_8b_mux),
-	ADI_PMX_FUNCTION("ppi1_16b", ppi1_16bgrp, ppi1_16b_mux),
-	ADI_PMX_FUNCTION("ppi2_8b", ppi2_8bgrp, ppi2_8b_mux),
-	ADI_PMX_FUNCTION("ppi2_16b", ppi2_16bgrp, ppi2_16b_mux),
-	ADI_PMX_FUNCTION("lp0", lp0grp, lp0_mux),
-	ADI_PMX_FUNCTION("lp1", lp1grp, lp1_mux),
-	ADI_PMX_FUNCTION("lp2", lp2grp, lp2_mux),
-	ADI_PMX_FUNCTION("lp3", lp3grp, lp3_mux),
+	ADI_PMX_FUNCTION("uart0", uart0grp),
+	ADI_PMX_FUNCTION("uart0_ctsrts", uart0ctsrtsgrp),
+	ADI_PMX_FUNCTION("uart1", uart1grp),
+	ADI_PMX_FUNCTION("uart1_ctsrts", uart1ctsrtsgrp),
+	ADI_PMX_FUNCTION("rsi0", rsi0grp),
+	ADI_PMX_FUNCTION("eth0", eth0grp),
+	ADI_PMX_FUNCTION("eth1", eth1grp),
+	ADI_PMX_FUNCTION("spi0", spi0grp),
+	ADI_PMX_FUNCTION("spi1", spi1grp),
+	ADI_PMX_FUNCTION("twi0", twi0grp),
+	ADI_PMX_FUNCTION("twi1", twi1grp),
+	ADI_PMX_FUNCTION("rotary", rotarygrp),
+	ADI_PMX_FUNCTION("can0", can0grp),
+	ADI_PMX_FUNCTION("smc0", smc0grp),
+	ADI_PMX_FUNCTION("sport0", sport0grp),
+	ADI_PMX_FUNCTION("sport1", sport1grp),
+	ADI_PMX_FUNCTION("sport2", sport2grp),
+	ADI_PMX_FUNCTION("ppi0", ppi0grp),
+	ADI_PMX_FUNCTION("ppi1", ppi1grp),
+	ADI_PMX_FUNCTION("ppi2", ppi2grp),
+	ADI_PMX_FUNCTION("lp0", lp0grp),
+	ADI_PMX_FUNCTION("lp1", lp1grp),
+	ADI_PMX_FUNCTION("lp2", lp2grp),
+	ADI_PMX_FUNCTION("lp3", lp3grp),
 };
 
 static const struct adi_pinctrl_soc_data adi_bf60x_soc = {
diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
index 72450a1..200ea1e 100644
--- a/drivers/pinctrl/pinctrl-adi2.c
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -618,8 +618,8 @@ static struct pinctrl_ops adi_pctrl_ops = {
 	.get_group_pins = adi_get_group_pins,
 };
 
-static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
-	unsigned group)
+static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned func_id,
+	unsigned group_id)
 {
 	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
 	struct gpio_port *port;
@@ -627,7 +627,7 @@ static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	unsigned long flags;
 	unsigned short *mux, pin;
 
-	mux = (unsigned short *)pinctrl->soc->functions[selector].mux;
+	mux = (unsigned short *)pinctrl->soc->groups[group_id].mux;
 
 	while (*mux) {
 		pin = P_IDENT(*mux);
@@ -651,8 +651,8 @@ static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
 	return 0;
 }
 
-static void adi_pinmux_disable(struct pinctrl_dev *pctldev, unsigned selector,
-	unsigned group)
+static void adi_pinmux_disable(struct pinctrl_dev *pctldev, unsigned func_id,
+	unsigned group_id)
 {
 	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
 	struct gpio_port *port;
@@ -660,7 +660,7 @@ static void adi_pinmux_disable(struct pinctrl_dev *pctldev, unsigned selector,
 	unsigned long flags;
 	unsigned short *mux, pin;
 
-	mux = (unsigned short *)pinctrl->soc->functions[selector].mux;
+	mux = (unsigned short *)pinctrl->soc->groups[group_id].mux;
 
 	while (*mux) {
 		pin = P_IDENT(*mux);
diff --git a/drivers/pinctrl/pinctrl-adi2.h b/drivers/pinctrl/pinctrl-adi2.h
index 1f06f8d..3ca2973 100644
--- a/drivers/pinctrl/pinctrl-adi2.h
+++ b/drivers/pinctrl/pinctrl-adi2.h
@@ -21,13 +21,15 @@ struct adi_pin_group {
 	const char *name;
 	const unsigned *pins;
 	const unsigned num;
+	const unsigned short *mux;
 };
 
-#define ADI_PIN_GROUP(n, p)  \
+#define ADI_PIN_GROUP(n, p, m)  \
 	{			\
 		.name = n,	\
 		.pins = p,	\
 		.num = ARRAY_SIZE(p),	\
+		.mux = m,			\
 	}
 
  /**
@@ -41,15 +43,13 @@ struct adi_pmx_func {
 	const char *name;
 	const char * const *groups;
 	const unsigned num_groups;
-	const unsigned short *mux;
 };
 
-#define ADI_PMX_FUNCTION(n, g, m)		\
+#define ADI_PMX_FUNCTION(n, g)		\
 	{					\
 		.name = n,			\
 		.groups = g,			\
 		.num_groups = ARRAY_SIZE(g),	\
-		.mux = m,			\
 	}
 
 /**
-- 
1.8.2.3


