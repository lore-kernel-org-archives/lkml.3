Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaDNQpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:45:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46068 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbaDNQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:54 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/15] bus: omap_l3_noc: move L3 master data structure out
Date: Mon, 14 Apr 2014 11:25:15 -0500
Message-ID: <1397492726-17203-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the L3 master structure out of the static definition to enable
reuse for other SoCs.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/bus/omap_l3_noc.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index cc4b1b1..26ad279 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -33,6 +33,16 @@
 
 #define NUM_OF_L3_MASTERS	(sizeof(l3_masters)/sizeof(l3_masters[0]))
 
+/**
+ * struct l3_masters_data - L3 Master information
+ * @id:		ID of the L3 Master
+ * @name:	master name
+ */
+struct l3_masters_data {
+	u32 id;
+	char *name;
+};
+
 static u32 l3_flagmux[L3_MODULES] = {
 	0x500,
 	0x1000,
@@ -80,10 +90,7 @@ static u32 l3_targ_inst_clk3[] = {
 	0x0 /* HOST CLK3 */
 };
 
-static struct l3_masters_data {
-	u32 id;
-	char name[10];
-} l3_masters[] = {
+static struct l3_masters_data l3_masters[] = {
 	{ 0x0 , "MPU"},
 	{ 0x10, "CS_ADP"},
 	{ 0x14, "xxx"},
-- 
1.7.9.5

