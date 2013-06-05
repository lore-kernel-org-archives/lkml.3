Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3FEVBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:01:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab3FEUxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hema Prathaban <hemaklnce@gmail.com>
Subject: [ 03/33] staging: vt6656: use free_netdev instead of kfree
Date: Wed,  5 Jun 2013 13:52:41 -0700
Message-Id: <20130605204703.190640774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hema Prathaban <hemaklnce@gmail.com>

commit 0a438d5b381e2bdfd5e02d653bf46fcc878356e3 upstream.

use free_netdev() instead of kfree(pDevice->apdev)

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/hostap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -153,7 +153,7 @@ static int hostap_disable_hostapd(PSDevi
             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
 		       pDevice->dev->name, pDevice->apdev->name);
 	}
-	kfree(pDevice->apdev);
+	free_netdev(pDevice->apdev);
 	pDevice->apdev = NULL;
     pDevice->bEnable8021x = FALSE;
     pDevice->bEnableHostWEP = FALSE;


