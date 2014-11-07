Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaKGMSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:18:50 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50296 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaKGMSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:18:48 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: unisys: unneeded NULL check
Date: Fri,  7 Nov 2014 17:48:34 +0530
Message-Id: <1415362715-24224-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the NULL check for memregion is not required as it has already been
checked for NULL after kzalloc. so we can reach this part of the code
only if memregion is not NULL.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/unisys/visorutil/memregion_direct.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/unisys/visorutil/memregion_direct.c b/drivers/staging/unisys/visorutil/memregion_direct.c
index 65bc07b..aad19e4 100644
--- a/drivers/staging/unisys/visorutil/memregion_direct.c
+++ b/drivers/staging/unisys/visorutil/memregion_direct.c
@@ -57,10 +57,8 @@ visor_memregion_create(HOSTADDRESS physaddr, ulong nbytes)
 	rc = memregion;
 Away:
 	if (rc == NULL) {
-		if (memregion != NULL) {
-			visor_memregion_destroy(memregion);
-			memregion = NULL;
-		}
+		visor_memregion_destroy(memregion);
+		memregion = NULL;
 	}
 	return rc;
 }
-- 
1.8.1.2

