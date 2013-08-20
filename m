Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab3HTGWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:22:34 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:44287 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3HTGWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:22:32 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r7K6J034020195, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v3 3/6] mfd:rtsx: Move some actions from rtsx_pci_init_hw to individual extra_init_hw
Date: Tue, 20 Aug 2013 14:18:53 +0800
Message-ID: <bc64ce0f3e3593bc947c1717bb1c2f8865c77d43.1376978825.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376978825.git.wei_wang@realsil.com.cn>
References: <cover.1376978825.git.wei_wang@realsil.com.cn>
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
index c67935e..03a15f7 100644
--- a/drivers/mfd/rts5209.c
+++ b/drivers/mfd/rts5209.c
@@ -70,6 +70,10 @@ static int rts5209_extra_init_hw(struct rtsx_pcr *pcr)
 
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
index 42ebf5c..724ce4c5 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -101,6 +101,8 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
+	/* Reset ASPM state to default value */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
 	/* Switch LDO3318 source from DV33 to card_3v3 */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
diff --git a/drivers/mfd/rts5229.c b/drivers/mfd/rts5229.c
index a0b695a..e8261d7 100644
--- a/drivers/mfd/rts5229.c
+++ b/drivers/mfd/rts5229.c
@@ -67,6 +67,10 @@ static int rts5229_extra_init_hw(struct rtsx_pcr *pcr)
 
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
index 79ff212..c5e54d7 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -104,6 +104,8 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 
 	/* Configure GPIO as output */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, GPIO_CTL, 0x02, 0x02);
+	/* Reset ASPM state to default value */
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
 	/* Switch LDO3318 source from DV33 to card_3v3 */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x00);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, LDO_PWR_SEL, 0x03, 0x01);
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 97526f1..ffd393c 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -972,8 +972,6 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, HOST_SLEEP_STATE, 0x03, 0x00);
 	/* Disable card clock */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_CLK_EN, 0x1E, 0);
-	/* Reset ASPM state to default value */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, ASPM_FORCE_CTL, 0x3F, 0);
 	/* Reset delink mode */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CHANGE_LINK_STATE, 0x0A, 0);
 	/* Card driving select */
@@ -1003,8 +1001,6 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	 *	0: ELBI interrupt flag[31:22] & [7:0] only can be write clear
 	 */
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, NFTS_TX_CTRL, 0x02, 0);
-	/* Force CLKREQ# PIN to drive 0 to request clock */
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0x08, 0x08);
 
 	err = rtsx_pci_send_cmd(pcr, 100);
 	if (err < 0)
-- 
1.7.9.5

