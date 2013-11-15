Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3KOIdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:33:25 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:42136 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3KOIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:33:04 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAF8Ws73007087, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wei_wang@realsil.com.cn>,
        <rogerable@realtek.com>, Lee Jones <lee.jones@linaro.org>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 3/3] mfd: rtsx: Prevent 'used uninitialised' warnings
Date: Fri, 15 Nov 2013 16:34:13 +0800
Message-ID: <a94db6f718e42afbe363af2fc0f006c92f223e54.1384503048.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1384503048.git.micky_ching@realsil.com.cn>
References: <cover.1384503048.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

drivers/mfd/rtl8411.c: In function -F¡rtl8411_fetch_vendor_settings¢:-A
drivers/mfd/rtl8411.c:58:7: warning: -F¡reg1¢ is used uninitialized in this function [-Wuninitialized]-A
drivers/mfd/rtl8411.c: In function -F¡rtl8411b_fetch_vendor_settings¢:-A
drivers/mfd/rtl8411.c:79:7: warning: -F¡reg¢ is used uninitialized in this function [-Wuninitialized]-A
drivers/mfd/rtl8411.c: In function -F¡rtl8411_fetch_vendor_settings¢:-A
drivers/mfd/rtl8411.c:69:26: warning: -F¡reg3¢ may be used uninitialized in this function [-Wuninitialized]-A

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtl8411.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index 8e4b546..948b5c7 100644
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

