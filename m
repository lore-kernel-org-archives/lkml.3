Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3FDOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:25:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46657 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3FDOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hema Prathaban <hemaklnce@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 10/70] staging: vt6656: use free_netdev instead of kfree
Date: Tue,  4 Jun 2013 15:06:26 +0100
Message-Id: <1370354846-14213-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hema Prathaban <hemaklnce@gmail.com>

commit 0a438d5b381e2bdfd5e02d653bf46fcc878356e3 upstream.

use free_netdev() instead of kfree(pDevice->apdev)

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6656/hostap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 51b5adf..df8ea25 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -153,7 +153,7 @@ static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
 		       pDevice->dev->name, pDevice->apdev->name);
 	}
-	kfree(pDevice->apdev);
+	free_netdev(pDevice->apdev);
 	pDevice->apdev = NULL;
     pDevice->bEnable8021x = FALSE;
     pDevice->bEnableHostWEP = FALSE;
-- 
1.8.1.2

