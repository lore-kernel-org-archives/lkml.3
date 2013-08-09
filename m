Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968323Ab3HISpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:45:30 -0400
Received: from nbd.name ([46.4.11.11]:32871 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968284Ab3HISp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:45:26 -0400
From: John Crispin <blogic@openwrt.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH V2 2/2] pinctrl/lantiq: add missing gphy led setup
Date: Fri,  9 Aug 2013 20:38:15 +0200
Message-Id: <1376073495-28730-2-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376073495-28730-1-git-send-email-blogic@openwrt.org>
References: <1376073495-28730-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found out how to set the gphy led pinmuxing.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/pinctrl/pinctrl-xway.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index e92132c..86c8cf8 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -102,6 +102,7 @@ enum xway_mux {
 	XWAY_MUX_EPHY,
 	XWAY_MUX_DFE,
 	XWAY_MUX_SDIO,
+	XWAY_MUX_GPHY,
 	XWAY_MUX_NONE = 0xffff,
 };
 
@@ -109,12 +110,12 @@ static const struct ltq_mfp_pin xway_mfp[] = {
 	/*       pin    f0	f1	f2	f3   */
 	MFP_XWAY(GPIO0, GPIO,	EXIN,	NONE,	TDM),
 	MFP_XWAY(GPIO1, GPIO,	EXIN,	NONE,	NONE),
-	MFP_XWAY(GPIO2, GPIO,	CGU,	EXIN,	NONE),
+	MFP_XWAY(GPIO2, GPIO,	CGU,	EXIN,	GPHY),
 	MFP_XWAY(GPIO3, GPIO,	CGU,	NONE,	PCI),
 	MFP_XWAY(GPIO4, GPIO,	STP,	NONE,	ASC),
-	MFP_XWAY(GPIO5, GPIO,	STP,	NONE,	NONE),
+	MFP_XWAY(GPIO5, GPIO,	STP,	NONE,	GPHY),
 	MFP_XWAY(GPIO6, GPIO,	STP,	GPT,	ASC),
-	MFP_XWAY(GPIO7, GPIO,	CGU,	PCI,	NONE),
+	MFP_XWAY(GPIO7, GPIO,	CGU,	PCI,	GPHY),
 	MFP_XWAY(GPIO8, GPIO,	CGU,	NMI,	NONE),
 	MFP_XWAY(GPIO9, GPIO,	ASC,	SPI,	EXIN),
 	MFP_XWAY(GPIO10, GPIO,	ASC,	SPI,	NONE),
@@ -151,10 +152,10 @@ static const struct ltq_mfp_pin xway_mfp[] = {
 	MFP_XWAY(GPIO41, GPIO,	NONE,	NONE,	NONE),
 	MFP_XWAY(GPIO42, GPIO,	MDIO,	NONE,	NONE),
 	MFP_XWAY(GPIO43, GPIO,	MDIO,	NONE,	NONE),
-	MFP_XWAY(GPIO44, GPIO,	NONE,	NONE,	SIN),
-	MFP_XWAY(GPIO45, GPIO,	NONE,	NONE,	SIN),
+	MFP_XWAY(GPIO44, GPIO,	NONE,	GPHY,	SIN),
+	MFP_XWAY(GPIO45, GPIO,	NONE,	GPHY,	SIN),
 	MFP_XWAY(GPIO46, GPIO,	NONE,	NONE,	EXIN),
-	MFP_XWAY(GPIO47, GPIO,	NONE,	NONE,	SIN),
+	MFP_XWAY(GPIO47, GPIO,	NONE,	GPHY,	SIN),
 	MFP_XWAY(GPIO48, GPIO,	EBU,	NONE,	NONE),
 	MFP_XWAY(GPIO49, GPIO,	EBU,	NONE,	NONE),
 	MFP_XWAY(GPIO50, GPIO,	NONE,	NONE,	NONE),
@@ -208,6 +209,13 @@ static const unsigned pins_stp[] = {GPIO4, GPIO5, GPIO6};
 static const unsigned pins_nmi[] = {GPIO8};
 static const unsigned pins_mdio[] = {GPIO42, GPIO43};
 
+static const unsigned pins_gphy0_led0[] = {GPIO5};
+static const unsigned pins_gphy0_led1[] = {GPIO7};
+static const unsigned pins_gphy0_led2[] = {GPIO2};
+static const unsigned pins_gphy1_led0[] = {GPIO44};
+static const unsigned pins_gphy1_led1[] = {GPIO45};
+static const unsigned pins_gphy1_led2[] = {GPIO47};
+
 static const unsigned pins_ebu_a24[] = {GPIO13};
 static const unsigned pins_ebu_clk[] = {GPIO21};
 static const unsigned pins_ebu_cs1[] = {GPIO23};
@@ -322,6 +330,12 @@ static const struct ltq_pin_group xway_grps[] = {
 	GRP_MUX("gnt4", PCI, pins_pci_gnt4),
 	GRP_MUX("req4", PCI, pins_pci_gnt4),
 	GRP_MUX("mdio", MDIO, pins_mdio),
+	GRP_MUX("gphy0 led0", GPHY, pins_gphy0_led0),
+	GRP_MUX("gphy0 led1", GPHY, pins_gphy0_led1),
+	GRP_MUX("gphy0 lde2", GPHY, pins_gphy0_led2),
+	GRP_MUX("gphy1 led0", GPHY, pins_gphy1_led0),
+	GRP_MUX("gphy1 led1", GPHY, pins_gphy1_led1),
+	GRP_MUX("gphy1 lde2", GPHY, pins_gphy1_led2),
 };
 
 static const struct ltq_pin_group ase_grps[] = {
@@ -365,6 +379,9 @@ static const char * const xway_nmi_grps[] = {"nmi"};
 
 /* ar9/vr9/gr9 */
 static const char * const xrx_mdio_grps[] = {"mdio"};
+static const char * const xrx_gphy_grps[] = {"gphy0 led0", "gphy0 led1",
+						"gphy0 led2", "gphy1 led0",
+						"gphy1 led1", "gphy1 led2"};
 static const char * const xrx_ebu_grps[] = {"ebu a23", "ebu a24",
 						"ebu a25", "ebu cs1",
 						"ebu wait", "ebu clk",
@@ -414,6 +431,7 @@ static const struct ltq_pmx_func xrx_funcs[] = {
 	{"pci",		ARRAY_AND_SIZE(xrx_pci_grps)},
 	{"ebu",		ARRAY_AND_SIZE(xrx_ebu_grps)},
 	{"mdio",	ARRAY_AND_SIZE(xrx_mdio_grps)},
+	{"gphy",	ARRAY_AND_SIZE(xrx_gphy_grps)},
 };
 
 static const struct ltq_pmx_func ase_funcs[] = {
-- 
1.7.10.4

