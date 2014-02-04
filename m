Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaBDG7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:59:04 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44026 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaBDG6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:58:55 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org, lisa@xenapiadmin.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: bcm: fix pointer-integer size mismatch warnings
Date: Tue,  4 Feb 2014 15:59:23 +0900
Message-Id: <1391497163-6894-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the pointer-integer size mismatch warnings below:
	drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
	drivers/staging/bcm/CmHost.c:1387:39: warning: cast to pointer from
			integer of different size [-Wint-to-pointer-cast]
	  pstAddIndication->psfAuthorizedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
					       ^
	drivers/staging/bcm/CmHost.c:1426:37: warning: cast to pointer from
			integer of different size [-Wint-to-pointer-cast]
	  pstAddIndication->psfAdmittedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
					     ^
	drivers/staging/bcm/CmHost.c:1440:35: warning: cast to pointer from
			integer of different size [-Wint-to-pointer-cast]
	  pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfActiveSet);
					   ^

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/bcm/CmHost.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index cc91b5e..dd8f8f7 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1384,7 +1384,8 @@ ULONG StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter, PVOID pvBu
 	}
 
 	/* this can't possibly be right */
-	pstAddIndication->psfAuthorizedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
+	pstAddIndication->psfAuthorizedSet = (struct bcm_connect_mgr_params *)
+		(uintptr_t)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
 
 	if (pstAddIndicationAlt->u8Type == DSA_REQ) {
 		struct bcm_add_request AddRequest;
@@ -1423,7 +1424,8 @@ ULONG StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter, PVOID pvBu
 		return 0;
 	}
 
-	pstAddIndication->psfAdmittedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
+	pstAddIndication->psfAdmittedSet = (struct bcm_connect_mgr_params *)
+		(uintptr_t)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
 
 	/* ACTIVE SET */
 	pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)
@@ -1437,7 +1439,8 @@ ULONG StoreCmControlResponseMessage(struct bcm_mini_adapter *Adapter, PVOID pvBu
 		return 0;
 	}
 
-	pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfActiveSet);
+	pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)
+		(uintptr_t)ntohl((ULONG)pstAddIndication->psfActiveSet);
 
 	(*puBufferLength) = sizeof(struct bcm_add_indication);
 	*(struct bcm_add_indication *)pvBuffer = *pstAddIndication;
-- 
1.8.3.2

