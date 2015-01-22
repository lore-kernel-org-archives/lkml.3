Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbbAVHcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:32:47 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:52320 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbAVHbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:31:02 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M7Umx7001393, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [RESEND PATCH v2 4/9] mfd: rtsx: update driving settings
Date: Thu, 22 Jan 2015 15:30:36 +0800
Message-ID: <382f3e7b2285ffd06931b43d015cc8a6967a19eb.1421911636.git.micky_ching@realsil.com.cn>
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

update card drive settings, This setting can be used for rts5249
rts524A and rts525A.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/rts5249.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index 225ad55..2fe2854 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -36,16 +36,16 @@ static u8 rts5249_get_ic_version(struct rtsx_pcr *pcr)
 static void rts5249_fill_driving(struct rtsx_pcr *pcr, u8 voltage)
 {
 	u8 driving_3v3[4][3] = {
-		{0x11, 0x11, 0x11},
+		{0x11, 0x11, 0x18},
 		{0x55, 0x55, 0x5C},
-		{0x99, 0x99, 0x92},
-		{0x99, 0x99, 0x92},
+		{0xFF, 0xFF, 0xFF},
+		{0x96, 0x96, 0x96},
 	};
 	u8 driving_1v8[4][3] = {
+		{0xC4, 0xC4, 0xC4},
 		{0x3C, 0x3C, 0x3C},
-		{0xB3, 0xB3, 0xB3},
 		{0xFE, 0xFE, 0xFE},
-		{0xC4, 0xC4, 0xC4},
+		{0xB3, 0xB3, 0xB3},
 	};
 	u8 (*driving)[3], drive_sel;
 
@@ -341,7 +341,7 @@ void rts5249_init_params(struct rtsx_pcr *pcr)
 
 	pcr->flags = 0;
 	pcr->card_drive_sel = RTSX_CARD_DRIVE_DEFAULT;
-	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_C;
+	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
 	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
 	pcr->aspm_en = ASPM_L1_EN;
 	pcr->tx_initial_phase = SET_CLOCK_PHASE(1, 29, 16);
-- 
1.9.1

