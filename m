Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3KHCSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3KHCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 87/91] Staging: bcm: info leak in ioctl
Date: Thu,  7 Nov 2013 18:15:42 -0800
Message-Id: <1383876946-2396-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8d1e72250c847fa96498ec029891de4dc638a5ba upstream.

The DevInfo.u32Reserved[] array isn't initialized so it leaks kernel
information to user space.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/bcm/Bcmchar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index efad33e..7bb7689 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1960,6 +1960,7 @@ cntrlEnd:
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
 
+		memset(&DevInfo, 0, sizeof(DevInfo));
 		DevInfo.MaxRDMBufferSize = BUFFER_4K;
 		DevInfo.u32DSDStartOffset = EEPROM_CALPARAM_START;
 		DevInfo.u32RxAlignmentCorrection = 0;
-- 
1.8.1.2

