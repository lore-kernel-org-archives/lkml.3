Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968337Ab3HISpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:45:30 -0400
Received: from nbd.name ([46.4.11.11]:32869 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968272Ab3HISp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:45:26 -0400
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Thomas Langer <thomas.langer@lantiq.com>
Subject: [PATCH V2 1/2] pinctrl/lantiq: add missing pin definition to falcon pinctrl driver
Date: Fri,  9 Aug 2013 20:38:14 +0200
Message-Id: <1376073495-28730-1-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Langer <thomas.langer@lantiq.com>

The pps pin definition is missing in the current code.

Signed-off-by: Thomas Langer <thomas.langer@lantiq.com>
Acked-by: John Crispin <blogic@openwrt.org>
---
Sorry i just noticed that i sent the 2 wrong files yesterday

 drivers/pinctrl/pinctrl-falcon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index f9b2a1d..4e731f2 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -75,6 +75,7 @@ enum falcon_mux {
 	FALCON_MUX_GPIO = 0,
 	FALCON_MUX_RST,
 	FALCON_MUX_NTR,
+	FALCON_MUX_PPS,
 	FALCON_MUX_MDIO,
 	FALCON_MUX_LED,
 	FALCON_MUX_SPI,
@@ -114,7 +115,7 @@ static struct ltq_mfp_pin falcon_mfp[] = {
 	MFP_FALCON(GPIO2,	GPIO,	GPIO,   NONE,   NONE),
 	MFP_FALCON(GPIO3,	GPIO,	GPIO,   NONE,   NONE),
 	MFP_FALCON(GPIO4,	NTR,	GPIO,   NONE,   NONE),
-	MFP_FALCON(GPIO5,	NTR,	GPIO,   NONE,   NONE),
+	MFP_FALCON(GPIO5,	NTR,	GPIO,   PPS,    NONE),
 	MFP_FALCON(GPIO6,	RST,	GPIO,   NONE,   NONE),
 	MFP_FALCON(GPIO7,	MDIO,	GPIO,   NONE,   NONE),
 	MFP_FALCON(GPIO8,	MDIO,	GPIO,   NONE,   NONE),
@@ -168,6 +169,7 @@ static struct ltq_mfp_pin falcon_mfp[] = {
 static const unsigned pins_por[] = {GPIO0};
 static const unsigned pins_ntr[] = {GPIO4};
 static const unsigned pins_ntr8k[] = {GPIO5};
+static const unsigned pins_pps[] = {GPIO5};
 static const unsigned pins_hrst[] = {GPIO6};
 static const unsigned pins_mdio[] = {GPIO7, GPIO8};
 static const unsigned pins_bled[] = {GPIO9, GPIO10, GPIO11,
@@ -186,6 +188,7 @@ static struct ltq_pin_group falcon_grps[] = {
 	GRP_MUX("por", RST, pins_por),
 	GRP_MUX("ntr", NTR, pins_ntr),
 	GRP_MUX("ntr8k", NTR, pins_ntr8k),
+	GRP_MUX("pps", PPS, pins_pps),
 	GRP_MUX("hrst", RST, pins_hrst),
 	GRP_MUX("mdio", MDIO, pins_mdio),
 	GRP_MUX("bootled", LED, pins_bled),
@@ -201,7 +204,7 @@ static struct ltq_pin_group falcon_grps[] = {
 };
 
 static const char * const ltq_rst_grps[] = {"por", "hrst"};
-static const char * const ltq_ntr_grps[] = {"ntr", "ntr8k"};
+static const char * const ltq_ntr_grps[] = {"ntr", "ntr8k", "pps"};
 static const char * const ltq_mdio_grps[] = {"mdio"};
 static const char * const ltq_bled_grps[] = {"bootled"};
 static const char * const ltq_asc_grps[] = {"asc0", "asc1"};
-- 
1.7.10.4

