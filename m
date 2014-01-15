Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaAOCw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:52:58 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:42253 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaAOCw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:52:56 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: pfuze100-regulator: Fix some checkpatch complaints
Date: Wed, 15 Jan 2014 00:52:45 -0200
Message-Id: <1389754365-31863-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following checkpatch error and warning:

ERROR: switch and case should be at the same indent
#311: FILE: drivers/regulator/pfuze100-regulator.c:311:
+	switch (value & 0x0f) {
[...]
+		case 0x8:
[...]
+		case 0x0:
[...]
+		default:

WARNING: line over 80 characters
#312: FILE: drivers/regulator/pfuze100-regulator.c:312:
+		/* Freescale misprogrammed 1-3% of parts prior to week 8 of 2013 as ID=8 */

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/pfuze100-regulator.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 0c511ae..ac01ad2 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -309,14 +309,17 @@ static int pfuze_identify(struct pfuze_chip *pfuze_chip)
 		return ret;
 
 	switch (value & 0x0f) {
-		/* Freescale misprogrammed 1-3% of parts prior to week 8 of 2013 as ID=8 */
-		case 0x8:
-			dev_info(pfuze_chip->dev, "Assuming misprogrammed ID=0x8");
-		case 0x0:
-			break;
-		default:
-			dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
-			return -ENODEV;
+	/*
+	 * Freescale misprogrammed 1-3% of parts prior to week 8 of 2013
+	 * as ID=8
+	 */
+	case 0x8:
+		dev_info(pfuze_chip->dev, "Assuming misprogrammed ID=0x8");
+	case 0x0:
+		break;
+	default:
+		dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
+		return -ENODEV;
 	}
 
 	ret = regmap_read(pfuze_chip->regmap, PFUZE100_REVID, &value);
-- 
1.8.1.2

