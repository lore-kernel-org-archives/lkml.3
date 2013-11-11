Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3KKL2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:28:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:62462 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3KKL1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:27:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="406751047"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/3] mei: drop redundant list_del_init
Date: Mon, 11 Nov 2013 13:26:07 +0200
Message-Id: <1384169168-30281-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
References: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

list_del_init appears twice in row in mei_cl_unlink, drop one.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 87c96e4..6184e85 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -344,8 +344,6 @@ int mei_cl_unlink(struct mei_cl *cl)
 
 	cl->state = MEI_FILE_INITIALIZING;
 
-	list_del_init(&cl->link);
-
 	return 0;
 }
 
-- 
1.8.3.1

