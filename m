Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3GQILX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:11:23 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57853 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3GQIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:10:12 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r6H8A3Q4029529, This message is accepted by code: ctloc85258
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v2 4/5] mfd:rtsx: Clear hardware PFM mode in rtl8411b
Date: Wed, 17 Jul 2013 16:09:54 +0800
Message-ID: <45e86ecf6da8dd593f56bc5d133be2a910d2138f.1373953200.git.wei_wang@realsil.com.cn>
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

Clear hw_pfm_en to disable hardware PFM mode, to fix a bug that in some
situation registers in 0xFDxx domain can't be accessed.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtl8411.c        |    2 ++
 include/linux/mfd/rtsx_pci.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 80c6fbc..2bff119 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -114,6 +114,8 @@ static int rtl8411b_extra_init_hw(struct rtsx_pcr *pcr)
 			0xFF, pcr->sd30_drive_sel_3v3);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CD_PAD_CTL,
 			CD_DISABLE_MASK | CD_AUTO_DISABLE, CD_ENABLE);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, FUNC_FORCE_CTL,
+			0x06, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 41d10e9..9763859 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -672,6 +672,7 @@
 #define PME_FORCE_CTL			0xFE56
 #define ASPM_FORCE_CTL			0xFE57
 #define PM_CLK_FORCE_CTL		0xFE58
+#define FUNC_FORCE_CTL			0xFE59
 #define PERST_GLITCH_WIDTH		0xFE5C
 #define CHANGE_LINK_STATE		0xFE5B
 #define RESET_LOAD_REG			0xFE5E
-- 
1.7.9.5

