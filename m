Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbbAVHbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:31:21 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:52315 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbbAVHbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:31:00 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M7UkHG001372, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [RESEND PATCH v2 3/9] mfd: rtsx: update PETXCFG address
Date: Thu, 22 Jan 2015 15:30:35 +0800
Message-ID: <a8bc53a220926bab51fb661136d5632f2ff5f965.1421911636.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421911636.git.micky_ching@realsil.com.cn>
References: <cover.1421911636.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

PETXCFG is defined at 0xFF03, the old 0xFE49 not used any more.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/rts5227.c        | 6 ++----
 drivers/mfd/rts5249.c        | 6 ++----
 include/linux/mfd/rtsx_pci.h | 2 +-
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index 3240740..1f387d4 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -118,11 +118,9 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
 	rts5227_fill_driving(pcr, OUTPUT_3V3);
 	/* Configure force_clock_req */
 	if (pcr->flags & PCR_REVERSE_SOCKET)
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-				AUTOLOAD_CFG_BASE + 3, 0xB8, 0xB8);
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB8, 0xB8);
 	else
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-				AUTOLOAD_CFG_BASE + 3, 0xB8, 0x88);
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB8, 0x88);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index cf425cc..225ad55 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -116,11 +116,9 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 	/* Configure driving */
 	rts5249_fill_driving(pcr, OUTPUT_3V3);
 	if (pcr->flags & PCR_REVERSE_SOCKET)
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-				AUTOLOAD_CFG_BASE + 3, 0xB0, 0xB0);
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0xB0);
 	else
-		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
-				AUTOLOAD_CFG_BASE + 3, 0xB0, 0x80);
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0x80);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index e81f2bb..87cff60 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -572,7 +572,6 @@
 #define MSGTXDATA2			0xFE46
 #define MSGTXDATA3			0xFE47
 #define MSGTXCTL			0xFE48
-#define PETXCFG				0xFE49
 #define LTR_CTL				0xFE4A
 #define OBFF_CFG			0xFE4C
 
@@ -606,6 +605,7 @@
 #define DUMMY_REG_RESET_0		0xFE90
 
 #define AUTOLOAD_CFG_BASE		0xFF00
+#define PETXCFG				0xFF03
 
 #define PM_CTRL1			0xFF44
 #define PM_CTRL2			0xFF45
-- 
1.9.1

