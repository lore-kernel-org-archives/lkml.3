Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3KYOGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:06:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58970 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab3KYNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nico Golde" <nico@ngolde.de>,
        "Fabian Yamaguchi" <fabs@goesec.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.386370769@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 86/87] Staging: bcm: info leak in ioctl
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8d1e72250c847fa96498ec029891de4dc638a5ba upstream.

The DevInfo.u32Reserved[] array isn't initialized so it leaks kernel
information to user space.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/bcm/Bcmchar.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1932,6 +1932,7 @@ cntrlEnd:
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
 
+		memset(&DevInfo, 0, sizeof(DevInfo));
 		DevInfo.MaxRDMBufferSize = BUFFER_4K;
 		DevInfo.u32DSDStartOffset = EEPROM_CALPARAM_START;
 		DevInfo.u32RxAlignmentCorrection = 0;

