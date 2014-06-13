Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaFMQBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:01:14 -0400
Received: from honeydew.cs.uni-dortmund.de ([129.217.4.43]:47855 "EHLO
	honeydew.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbaFMQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:01:13 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2014 12:01:12 EDT
From: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, matlackdavid@gmail.com, liodot@gmail.com,
        charrer@alacritech.com, peter.p.waskiewicz.jr@intel.com,
        devel@driverdev.osuosl.org,
        Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Subject: [PATCH] staging: slicoss: Fix coding style issue 
Date: Fri, 13 Jun 2014 17:52:33 +0200
Message-Id: <1402674753-3466-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a coding style issue found by checkpatch.pl.
Use ether_addr_copy instead of memcpy.

Done to complete a eudyptula task.

Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>

---
 drivers/staging/slicoss/slicoss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 48841e7..02807a3 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1790,7 +1790,7 @@ static int slic_mcast_add_list(struct adapter *adapter, char *address)
 	if (mcaddr == NULL)
 		return 1;
 
-	memcpy(mcaddr->address, address, ETH_ALEN);
+	ether_addr_copy(mcaddr->address, address);
 
 	mcaddr->next = adapter->mcastaddrs;
 	adapter->mcastaddrs = mcaddr;
-- 
1.9.1

