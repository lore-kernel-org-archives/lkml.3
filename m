Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3LCJYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:24:52 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33377 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3LCJYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:24:44 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rB39OYsB010415, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wei_wang@realsil.com.cn>,
        <rogerable@realtek.com>, Micky Ching <micky_ching@realsil.com.cn>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 3/3] mfd: rtsx: prevent 'used uninitialised' warnings
Date: Tue, 3 Dec 2013 17:26:33 +0800
Message-ID: <932dcc03570ceb86316272d4eba7f4207d001def.1386051860.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1386051860.git.micky_ching@realsil.com.cn>
References: <cover.1386051860.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

drivers/mfd/rtl8411.c: In function 'rtl8411_fetch_vendor_settings':
drivers/mfd/rtl8411.c:58:7: warning: 'reg1' is used uninitialized in this function [-Wuninitialized]
drivers/mfd/rtl8411.c: In function 'rtl8411b_fetch_vendor_settings':
drivers/mfd/rtl8411.c:79:7: warning: 'reg' is used uninitialized in this function [-Wuninitialized]
drivers/mfd/rtl8411.c: In function 'rtl8411_fetch_vendor_settings':
drivers/mfd/rtl8411.c:69:26: warning: 'reg3' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Tested-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtl8411.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 4b377e3..d53ff96 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -49,8 +49,8 @@ static int rtl8411b_is_qfn48(struct rtsx_pcr *pcr)
 
 static void rtl8411_fetch_vendor_settings(struct rtsx_pcr *pcr)
 {
-	u32 reg1;
-	u8 reg3;
+	u32 reg1 = 0;
+	u8 reg3 = 0;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg1);
 	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg1);
@@ -71,7 +71,7 @@ static void rtl8411_fetch_vendor_settings(struct rtsx_pcr *pcr)
 
 static void rtl8411b_fetch_vendor_settings(struct rtsx_pcr *pcr)
 {
-	u32 reg;
+	u32 reg = 0;
 
 	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
 	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
-- 
1.7.9.5

