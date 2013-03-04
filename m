Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3CDTmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:42:09 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39518 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3CDTmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:42:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Huewe <peterhuewe@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging/vt6656: Fix too large integer constant warning on 32-bit
Date: Mon,  4 Mar 2013 20:42:00 +0100
Message-Id: <1362426120-18545-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/vt6656/card.c: In function ‘CARDqGetNextTBTT’:
drivers/staging/vt6656/card.c:793: warning: integer constant is too large for ‘unsigned long’ type

Commit c7b7cad0d8df823ea063c86a54316bbcbfa04a7c ("staging/vt6656: Fix
sparse warning constant 0xffffffff00000000U is so big it is unsigned long")
changed the constant to "0xffffffff00000000UL", but that only works on
64-bit.  Change it "0xffffffff00000000ULL" to fix it for 32-bit, too.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/vt6656/card.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 22918a1..d2479b7 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -790,7 +790,7 @@ u64 CARDqGetNextTBTT(u64 qwTSF, WORD wBeaconInterval)
 	if ((~uLowNextTBTT) < uLowRemain)
 		qwTSF = ((qwTSF >> 32) + 1) << 32;
 
-	qwTSF = (qwTSF & 0xffffffff00000000UL) |
+	qwTSF = (qwTSF & 0xffffffff00000000ULL) |
 		(u64)(uLowNextTBTT + uLowRemain);
 
     return (qwTSF);
-- 
1.7.0.4

