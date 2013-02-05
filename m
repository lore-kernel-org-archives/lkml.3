Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab3BEW1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:27:45 -0500
Received: from mout.gmx.net ([212.227.17.20]:63934 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab3BEW1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:27:43 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX186UDkqoCg6cCiq0+vW2ITl1dgMX7epyvUa5WdZAl
	KlyfZ4JzMA2rpf
From: Peter Huewe <peterhuewe@gmx.de>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kbuild@01.org
Subject: [PATCH] staging/vt6656: Fix sparse warning constant 0xffffffff00000000U is so big it is unsigned long
Date: Tue,  5 Feb 2013 23:31:37 +0100
Message-Id: <1360103497-4894-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 7c65fa2a4c176c9bfab1ef954c4cef005dd9fb8b
'staging: vt6656: Remove QWORD from source and replace with u64.'
a new sparse warning showed up:

'drivers/staging/vt6656/card.c:798:26: sparse: constant
 0xffffffff00000000U is so big it is unsigned long'

-> Append L to fix the warning.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/vt6656/card.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 7d725bb..f988f07 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -790,7 +790,7 @@ u64 CARDqGetNextTBTT(u64 qwTSF, WORD wBeaconInterval)
 	if ((~uLowNextTBTT) < uLowRemain)
 		qwTSF = ((qwTSF >> 32) + 1) << 32;
 
-	qwTSF = (qwTSF & 0xffffffff00000000U) |
+	qwTSF = (qwTSF & 0xffffffff00000000UL) |
 		(u64)(uLowNextTBTT + uLowRemain);
 
     return (qwTSF);
-- 
1.7.8.6

