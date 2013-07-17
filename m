Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3GQIKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:10:17 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57847 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3GQIKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:10:11 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6H8A2ZR029514, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2 3/5] mfd:rtsx: Move some actions from rtsx_pci_init_hw to individual extra_init_hw
Date: Wed, 17 Jul 2013 16:09:53 +0800
Message-ID: <56d01caab8d47b6d6462b7d05870fc01bf1f2cf1.1373953200.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1373953200.git.wei_wang@realsil.com.cn>
References: <cover.1373953200.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

These actions are individual for each reader model, so should be put in
extra_init_hw instead of rtsx_pci_init_hw.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rts5209.c  |    4 ++++
 drivers/mfd/rts5227.c  |    2 ++
 drivers/mfd/rts5229.c  |    4 ++++
 drivers/mfd/rts5249.c  |    2 ++
 drivers/mfd/rtsx_pcr.c |    4 ----
 5 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
index 524a5c5..e2ee30e 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -69,6 +69,10 @@ static int rts5209_extra_init_hw(struct rtsx_pcr *pcr)
 
 	/* Turn off LED */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_GPIO, 0xFF, 0x03);
+	/* Reset ASPM state to default value */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
+	/* Force CLKREQ# PIN to drive 0 to request clock */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0x08, 0x08);
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_GPIO_DIR, 0xFF, 0x03);
 	/* Configure driving */
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index fd95ab4..c931018 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -100,6 +100,8 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
+	/* Reset ASPM state to default value */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
 	/* Switch LDO3318 source from DV33 to card_3v3 */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index b283511..a91462d 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -66,6 +66,10 @@ static int rts5229_extra_init_hw(struct rtsx_pcr *pcr)
 
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
+	/* Reset ASPM state to default value */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
+	/* Force CLKREQ# PIN to drive 0 to request clock */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0x08, 0x08);
 	/* Switch LDO3318 source from DV33 to card_3v3 */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 066d6ff..f18bb27 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -105,6 +105,8 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
+	/* Reset ASPM state to default value */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
 	/* Switch LDO3318 source from DV33 to card_3v3 */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index a178173..13e1c24 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -971,8 +971,6 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, HOST_SLEEP_STATE, 0x03, 0x00);
 	/* Disable card clock */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_CLK_EN, 0x1E, 0);
-	/* Reset ASPM state to default value */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
 	/* Reset delink mode */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CHANGE_LINK_STATE, 0x0A, 0);
 	/* Card driving select */
@@ -1002,8 +1000,6 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	 *	0: ELBI interrupt flag[31:22] & [7:0] only can be write clear
 	 */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, NFTS_TX_CTRL, 0x02, 0);
-	/* Force CLKREQ# PIN to drive 0 to request clock */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0x08, 0x08);
 
 	err = rtsx_pci_send_cmd(pcr, 100);
 	if (err < 0)
-- 
1.7.9.5

