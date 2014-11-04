Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaKDNLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:11:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37303 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbaKDNLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:11:53 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: wm5110: Add missing registers for AIF2 channels 3-6
Date: Tue,  4 Nov 2014 13:04:07 +0000
Message-Id: <1415106247-12864-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the extra 4 channels were added to AIF2 the necessary frame control
registers were not given defaults and marked readable. This patch fixes
this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c           |   16 ++++++++++++++++
 include/linux/mfd/arizona/registers.h |    8 ++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 4642b5b..64eab95 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -895,8 +895,16 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00000548, 0x1818 },    /* R1352  - AIF2 Frame Ctrl 2 */
 	{ 0x00000549, 0x0000 },    /* R1353  - AIF2 Frame Ctrl 3 */
 	{ 0x0000054A, 0x0001 },    /* R1354  - AIF2 Frame Ctrl 4 */
+	{ 0x0000054B, 0x0002 },    /* R1355  - AIF2 Frame Ctrl 5 */
+	{ 0x0000054C, 0x0003 },    /* R1356  - AIF2 Frame Ctrl 6 */
+	{ 0x0000054D, 0x0004 },    /* R1357  - AIF2 Frame Ctrl 7 */
+	{ 0x0000054E, 0x0005 },    /* R1358  - AIF2 Frame Ctrl 8 */
 	{ 0x00000551, 0x0000 },    /* R1361  - AIF2 Frame Ctrl 11 */
 	{ 0x00000552, 0x0001 },    /* R1362  - AIF2 Frame Ctrl 12 */
+	{ 0x00000553, 0x0002 },    /* R1363  - AIF2 Frame Ctrl 13 */
+	{ 0x00000554, 0x0003 },    /* R1364  - AIF2 Frame Ctrl 14 */
+	{ 0x00000555, 0x0004 },    /* R1365  - AIF2 Frame Ctrl 15 */
+	{ 0x00000556, 0x0005 },    /* R1366  - AIF2 Frame Ctrl 16 */
 	{ 0x00000559, 0x0000 },    /* R1369  - AIF2 Tx Enables */
 	{ 0x0000055A, 0x0000 },    /* R1370  - AIF2 Rx Enables */
 	{ 0x00000580, 0x000C },    /* R1408  - AIF3 BCLK Ctrl */
@@ -1934,8 +1942,16 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_AIF2_FRAME_CTRL_2:
 	case ARIZONA_AIF2_FRAME_CTRL_3:
 	case ARIZONA_AIF2_FRAME_CTRL_4:
+	case ARIZONA_AIF2_FRAME_CTRL_5:
+	case ARIZONA_AIF2_FRAME_CTRL_6:
+	case ARIZONA_AIF2_FRAME_CTRL_7:
+	case ARIZONA_AIF2_FRAME_CTRL_8:
 	case ARIZONA_AIF2_FRAME_CTRL_11:
 	case ARIZONA_AIF2_FRAME_CTRL_12:
+	case ARIZONA_AIF2_FRAME_CTRL_13:
+	case ARIZONA_AIF2_FRAME_CTRL_14:
+	case ARIZONA_AIF2_FRAME_CTRL_15:
+	case ARIZONA_AIF2_FRAME_CTRL_16:
 	case ARIZONA_AIF2_TX_ENABLES:
 	case ARIZONA_AIF2_RX_ENABLES:
 	case ARIZONA_AIF3_BCLK_CTRL:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index c0b075f..fbf6489 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -279,8 +279,16 @@
 #define ARIZONA_AIF2_FRAME_CTRL_2                0x548
 #define ARIZONA_AIF2_FRAME_CTRL_3                0x549
 #define ARIZONA_AIF2_FRAME_CTRL_4                0x54A
+#define ARIZONA_AIF2_FRAME_CTRL_5                0x54B
+#define ARIZONA_AIF2_FRAME_CTRL_6                0x54C
+#define ARIZONA_AIF2_FRAME_CTRL_7                0x54D
+#define ARIZONA_AIF2_FRAME_CTRL_8                0x54E
 #define ARIZONA_AIF2_FRAME_CTRL_11               0x551
 #define ARIZONA_AIF2_FRAME_CTRL_12               0x552
+#define ARIZONA_AIF2_FRAME_CTRL_13               0x553
+#define ARIZONA_AIF2_FRAME_CTRL_14               0x554
+#define ARIZONA_AIF2_FRAME_CTRL_15               0x555
+#define ARIZONA_AIF2_FRAME_CTRL_16               0x556
 #define ARIZONA_AIF2_TX_ENABLES                  0x559
 #define ARIZONA_AIF2_RX_ENABLES                  0x55A
 #define ARIZONA_AIF2_FORCE_WRITE                 0x55B
-- 
1.7.2.5

