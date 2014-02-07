Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaBGMwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:52:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaBGLuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 103/233] staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT
Date: Fri,  7 Feb 2014 11:45:22 +0000
Message-Id: <1391773652-25214-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 9acec059c0cef0bf086c738f4c0b1f4447782a48 upstream.

value uLowNextTBTT yields wrong value.

ULL is needed with qwTSF

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6656/card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 24291ae..0beb246 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -761,7 +761,7 @@ u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBeaconInterval)
 
     uBeaconInterval = wBeaconInterval * 1024;
     // Next TBTT = ((local_current_TSF / beacon_interval) + 1 ) * beacon_interval
-	uLowNextTBTT = ((qwTSF & 0xffffffffU) >> 10) << 10;
+	uLowNextTBTT = ((qwTSF & 0xffffffffULL) >> 10) << 10;
 	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
 	uHighRemain = ((0x80000000 % uBeaconInterval) * 2 * (u32)(qwTSF >> 32))
 		% uBeaconInterval;
-- 
1.8.3.2

