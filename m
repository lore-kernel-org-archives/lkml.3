Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3CDVNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:13:31 -0500
Received: from mout.gmx.net ([212.227.15.18]:55211 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab3CDVNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:13:30 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX198cMEKif98gL1Ap/b/pnOuYNeQH3ax5y8bw4LmZJ
	dLBdvcmq2n6SZJ
From: Peter Huewe <peterhuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] tpm/tpm_i2c_infineon.c: Add OF attributes type and name to the of_device_id table entries
Date: Mon,  4 Mar 2013 22:08:54 +0100
Message-Id: <1362431334-21334-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.12.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the subject says.
It's probably a good idea to have these fields populated.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index bd9a295..d83bb8c 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -694,9 +694,24 @@ MODULE_DEVICE_TABLE(i2c, tpm_tis_i2c_table);
 
 #ifdef CONFIG_OF
 static const struct of_device_id tpm_tis_i2c_of_match[] = {
-	{ .compatible = "infineon,tpm_i2c_infineon", .data = (void *)0 },
-	{ .compatible = "infineon,slb9635tt", .data = (void *)0 },
-	{ .compatible = "infineon,slb9645tt", .data = (void *)1 },
+	{
+		.name = "tpm_i2c_infineon",
+		.type = "tpm",
+		.compatible = "infineon,tpm_i2c_infineon",
+		.data = (void *)0
+	},
+	{
+		.name = "slb9635tt",
+		.type = "tpm",
+		.compatible = "infineon,slb9635tt",
+		.data = (void *)0
+	},
+	{
+		.name = "slb9645tt",
+		.type = "tpm",
+		.compatible = "infineon,slb9645tt",
+		.data = (void *)1
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, tpm_tis_i2c_of_match);
-- 
1.7.12.4

