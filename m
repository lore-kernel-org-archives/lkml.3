Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbaDBJzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:55:19 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45867 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbaDBJzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:55:18 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s329t6s1001627, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC: <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] staging: rts5208: fix static checker warnings
Date: Wed, 2 Apr 2014 17:58:52 +0800
Message-ID: <1396432732-26514-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

The patch fa590c222fba: "staging: rts5208: add support for rts5208
and rts5288" from Nov 12, 2013, leads to the following static checker
warning:
	drivers/staging/rts5208/rtsx_chip.c:107 rtsx_enable_bus_int()
	warn: add curly braces?
This warning is produced because incorrect code indent.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/staging/rts5208/rtsx_chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 6426807..7907e93 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -104,7 +104,7 @@ void rtsx_enable_bus_int(struct rtsx_chip *chip)
 	if (chip->ic_version >= IC_VER_C)
 		reg |= DELINK_INT_EN;
 #ifdef SUPPORT_OCP
-		reg |= OC_INT_EN;
+	reg |= OC_INT_EN;
 #endif
 	if (!chip->adma_mode)
 		reg |= DATA_DONE_INT_EN;
-- 
1.7.9.5

