Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3JWLbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:31:19 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.163]:54363 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab3JWLbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:31:17 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-14.tower-38.messagelabs.com!1382527873!7765403!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 23 Oct 2013 13:31:14 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Andreas Werner <andreas.werner@men.de>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH] mfd: lpc_sch: Ignore resource conflicts when adding mfd cells
Date: Wed, 23 Oct 2013 13:31:00 +0200
Message-ID: <1382527860-8959-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 23 Oct 2013 11:31:12.0558 (UTC) FILETIME=[609A64E0:01CECFE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently probe of lpc_sch fails on Intel Poulsbo because of ACPI resource
conflicts. A solution is to  set the ignore_resource_conflicts flag in the mfd cells.

Tested-by: Andreas Werner <andreas.werner@men.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/mfd/lpc_sch.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index 8cc6aac..fbfbf0b 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -59,18 +59,21 @@ static struct mfd_cell isch_smbus_cell = {
 	.name = "isch_smbus",
 	.num_resources = 1,
 	.resources = &smbus_sch_resource,
+	.ignore_resource_conflicts = true,
 };
 
 static struct mfd_cell sch_gpio_cell = {
 	.name = "sch_gpio",
 	.num_resources = 1,
 	.resources = &gpio_sch_resource,
+	.ignore_resource_conflicts = true,
 };
 
 static struct mfd_cell wdt_sch_cell = {
 	.name = "ie6xx_wdt",
 	.num_resources = 1,
 	.resources = &wdt_sch_resource,
+	.ignore_resource_conflicts = true,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lpc_sch_ids) = {
-- 
1.7.9.5

