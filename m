Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbaGYPdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:33:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33603 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbaGYPda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:33:30 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mfd: arizona: Map MICVDD from extcon device to the Arizona core
Date: Fri, 25 Jul 2014 16:24:44 +0100
Message-Id: <1406301884-7145-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1406301884-7145-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1406301884-7145-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extcon driver should be able to get its regulator against rather
than against the main arizona device, we must add a supply mapping
allowing the regulator to be located. This patch does so.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index e0d415e..cf3689f 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -578,17 +578,21 @@ static const struct mfd_cell early_devs[] = {
 };
 
 static const char *wm5102_supplies[] = {
+	"MICVDD",
 	"DBVDD2",
 	"DBVDD3",
 	"CPVDD",
 	"SPKVDDL",
 	"SPKVDDR",
-	"MICVDD",
 };
 
 static const struct mfd_cell wm5102_devs[] = {
 	{ .name = "arizona-micsupp" },
-	{ .name = "arizona-extcon" },
+	{
+		.name = "arizona-extcon",
+		.parent_supplies = wm5102_supplies,
+		.num_parent_supplies = 1, /* We only need MICVDD */
+	},
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
@@ -601,7 +605,11 @@ static const struct mfd_cell wm5102_devs[] = {
 
 static const struct mfd_cell wm5110_devs[] = {
 	{ .name = "arizona-micsupp" },
-	{ .name = "arizona-extcon" },
+	{
+		.name = "arizona-extcon",
+		.parent_supplies = wm5102_supplies,
+		.num_parent_supplies = 1, /* We only need MICVDD */
+	},
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
@@ -621,7 +629,11 @@ static const char *wm8997_supplies[] = {
 
 static const struct mfd_cell wm8997_devs[] = {
 	{ .name = "arizona-micsupp" },
-	{ .name = "arizona-extcon" },
+	{
+		.name = "arizona-extcon",
+		.parent_supplies = wm8997_supplies,
+		.num_parent_supplies = 1, /* We only need MICVDD */
+	},
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
 	{ .name = "arizona-pwm" },
-- 
1.7.2.5

