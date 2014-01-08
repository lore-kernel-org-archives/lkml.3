Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbaAHS7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:59:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:23768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaAHS7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:59:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,625,1384329600"; 
   d="scan'208";a="463673799"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: nfc: mei_nfc_free has to be called under lock
Date: Wed,  8 Jan 2014 20:57:44 +0200
Message-Id: <1389207464-17279-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfc_nfc_free unlink clients from the device list
and has to be called under mei mutex

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/nfc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 0a89220..5496190 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -469,7 +469,9 @@ static void mei_nfc_init(struct work_struct *work)
 	return;
 
 err:
+	mutex_lock(&dev->device_lock);
 	mei_nfc_free(ndev);
+	mutex_unlock(&dev->device_lock);
 
 	return;
 }
-- 
1.8.4.2

