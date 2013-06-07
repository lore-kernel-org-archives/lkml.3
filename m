Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3FGQL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:11:58 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:39718 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3FGQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:11:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/10] mfd: ab8500-core: Add AB8500 external regulators as MFD devices
Date: Fri,  7 Jun 2013 17:11:23 +0100
Message-Id: <1370621488-18130-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 external regulator driver is now a device in its own right,
so it requires registering and probing in the normal way. This patch
will ensure the driver is probed once registered for all devices which
support them.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 258b367..710f117 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1051,6 +1051,10 @@ static struct mfd_cell ab8500_devs[] = {
 		.of_compatible = "stericsson,ab8500-sysctrl",
 	},
 	{
+		.name = "ab8500-ext-regulator",
+		.of_compatible = "stericsson,ab8500-ext-regulator",
+	},
+	{
 		.name = "ab8500-regulator",
 		.of_compatible = "stericsson,ab8500-regulator",
 	},
@@ -1139,6 +1143,9 @@ static struct mfd_cell ab9540_devs[] = {
 		.name = "ab8500-sysctrl",
 	},
 	{
+		.name = "ab8500-ext-regulator",
+	},
+	{
 		.name = "ab8500-regulator",
 	},
 	{
@@ -1274,6 +1281,9 @@ static struct mfd_cell ab8540_devs[] = {
 		.name = "ab8500-sysctrl",
 	},
 	{
+		.name = "ab8500-ext-regulator",
+	},
+	{
 		.name = "ab8500-regulator",
 	},
 	{
-- 
1.7.10.4

