Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab3KIGyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:54:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3KIGxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:53:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.11 57/94] Staging: bcm: info leak in ioctl
Date: Fri,  8 Nov 2013 22:52:03 -0800
Message-Id: <20131109065208.300954567@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8d1e72250c847fa96498ec029891de4dc638a5ba upstream.

The DevInfo.u32Reserved[] array isn't initialized so it leaks kernel
information to user space.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/bcm/Bcmchar.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1960,6 +1960,7 @@ cntrlEnd:
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Called IOCTL_BCM_GET_DEVICE_DRIVER_INFO\n");
 
+		memset(&DevInfo, 0, sizeof(DevInfo));
 		DevInfo.MaxRDMBufferSize = BUFFER_4K;
 		DevInfo.u32DSDStartOffset = EEPROM_CALPARAM_START;
 		DevInfo.u32RxAlignmentCorrection = 0;


