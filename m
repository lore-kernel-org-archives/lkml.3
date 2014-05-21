Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaEURQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:16:57 -0400
Received: from mout.gmx.net ([212.227.15.18]:49441 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbaEURQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:16:55 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, andreas.dilger@intel.com, manuel.schoelling@gmx.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] lustre: Use time_before()
Date: Wed, 21 May 2014 19:16:36 +0200
Message-Id: <1400692596-13875-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:1s6mGJKBrMn+GIRj5HynszAvBZQM0OH5zwEkdnPCo8+CqkgcjMX
 PSdtmAXfl0fMs0LeOgiIIosTP0Ra60sCqo0gHfnB9KQwoPkTaTio8PxA4PK7cnNbaPyNSiY
 qSOlwQTKagNtJ4Bzh1ZQZB00vSaePwIUknD8MjBAYFwnA6cYA8pz07AVQjO2aykyT8ej7s4
 tJJORUd3TcmDcQ6OsA8Tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/staging/lustre/lustre/include/linux/obd.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/linux/obd.h b/drivers/staging/lustre/lustre/include/linux/obd.h
index dc36f75e..518e48a 100644
--- a/drivers/staging/lustre/lustre/include/linux/obd.h
+++ b/drivers/staging/lustre/lustre/include/linux/obd.h
@@ -80,8 +80,8 @@ static inline void __client_obd_list_lock(client_obd_lock_t *lock,
 			break;
 		}
 
-		if ((jiffies - cur > 5 * HZ) &&
-		    (jiffies - lock->time > 5 * HZ)) {
+		if (time_before(cur + 5 * HZ, jiffies) &&
+		    time_before(lock->time + 5 * HZ, jiffies)) {
 			struct task_struct *task = lock->task;
 
 			if (task == NULL)
-- 
1.7.10.4

