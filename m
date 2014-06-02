Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaFBJJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:09:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38697 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbaFBJJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:09:18 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: arizona: Destroy regulators after the other MFD cells
Date: Mon,  2 Jun 2014 10:01:44 +0100
Message-Id: <1401699704-17902-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401699704-17902-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of the cells depend on the regulators provided by the
arizona-micsupp and arizona-ldo1 cells. As such use the new remove_level
feature of the MFD core to ensure the regulators are destroyed after all
the other cells.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 51c0110..76248bc 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -570,7 +570,10 @@ static inline int arizona_of_get_core_pdata(struct arizona *arizona)
 #endif
 
 static const struct mfd_cell early_devs[] = {
-	{ .name = "arizona-ldo1" },
+	{
+		.name = "arizona-ldo1",
+		.remove_level = 1,
+	},
 };
 
 static const char *wm5102_supplies[] = {
@@ -583,7 +586,10 @@ static const char *wm5102_supplies[] = {
 };
 
 static const struct mfd_cell wm5102_devs[] = {
-	{ .name = "arizona-micsupp" },
+	{
+		.name = "arizona-micsupp",
+		.remove_level = 1,
+	},
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
@@ -596,7 +602,10 @@ static const struct mfd_cell wm5102_devs[] = {
 };
 
 static const struct mfd_cell wm5110_devs[] = {
-	{ .name = "arizona-micsupp" },
+	{
+		.name = "arizona-micsupp",
+		.remove_level = 1,
+	},
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
@@ -615,7 +624,10 @@ static const char *wm8997_supplies[] = {
 };
 
 static const struct mfd_cell wm8997_devs[] = {
-	{ .name = "arizona-micsupp" },
+	{
+		.name = "arizona-micsupp",
+		.remove_level = 1,
+	},
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
-- 
1.7.2.5

