Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3BEV3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:29:07 -0500
Received: from mout.gmx.net ([212.227.17.21]:51280 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab3BEV3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:29:04 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/VszRblSzVL9l40LuAw7w6/T6KV/77w1fmfJlBKV
	kgZh2Wl1oRSbAY
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging/xgifb: Remove unneeded conditional assignment
Date: Tue,  5 Feb 2013 22:32:33 +0100
Message-Id: <1360099954-8612-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
References: <1360099954-8612-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pVBInfo->ram_type is assigned the return value of
XGINew_GetXG20DRAMType which can only be 0, 1 or 2

-> The conditional assignment is not needed here as it always evaluates
to true.
-> remove

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 7b8f41d..e19a714 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -440,7 +440,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 	xgifb_reg_set(P3d4, 0x6A, pVBInfo->CR40[7][pVBInfo->ram_type]);
 
 	/* CR6B DQS fine tune delay */
-	temp = (pVBInfo->ram_type <= 2) ? 0xaa : 0x00;
+	temp = 0xaa;
 	XGI_SetDRAM_Helper(P3d4, temp, 0, 0x6B, 2, 0xF0, 0x10);
 
 	/* CR6E DQM fine tune delay */
-- 
1.7.8.6

