Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaB0LKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:10:12 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56960 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaB0LKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:10:07 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, veeableful@gmail.com, josh@joshtriplett.org,
        rashika.kheria@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: bcm: Remove unneeded set a variable
Date: Thu, 27 Feb 2014 20:10:02 +0900
Message-ID: <1408252.HaVz9lN1R9@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bClassificationSucceed is initialized with "false",
do not need to set "false" again.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/bcm/Qos.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 0727599..ead57b4 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -222,10 +222,7 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Adapter,
 
 		//Checking classifier validity
 		if (!pstClassifierRule->bUsed || pstClassifierRule->ucDirection == DOWNLINK_DIR)
-		{
-			bClassificationSucceed = false;
 			break;
-		}
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "is IPv6 check!");
 		if (pstClassifierRule->bIpv6Protocol)
-- 
1.7.9.5

---
