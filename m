Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205AbaK1Gf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:35:29 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49359 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaK1Gf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:35:27 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAS6YdCs023208, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 1/2] mfd: rtsx: add func to split u32 into register
Date: Fri, 28 Nov 2014 14:31:55 +0800
Message-ID: <6a6de978f479758fb9e767d8a6e013e8a006a39a.1417141102.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1417141102.git.micky_ching@realsil.com.cn>
References: <cover.1417141102.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add helper function to write u32 to registers, if we want to put u32
value to 4 continuous register, this can help us reduce tedious work.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 include/linux/mfd/rtsx_pci.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 74346d5..9234449 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -558,6 +558,7 @@
 #define SD_SAMPLE_POINT_CTL		0xFDA7
 #define SD_PUSH_POINT_CTL		0xFDA8
 #define SD_CMD0				0xFDA9
+#define   SD_CMD_START			0x40
 #define SD_CMD1				0xFDAA
 #define SD_CMD2				0xFDAB
 #define SD_CMD3				0xFDAC
@@ -967,4 +968,12 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
 	return (u8 *)(pcr->host_cmds_ptr);
 }
 
+static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
+{
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val >> 24);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 16);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 8);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);
+}
+
 #endif
-- 
1.9.1

