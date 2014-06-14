Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaFNWTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:19:43 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:18213 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbaFNWTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:19:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswIADHJnFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZkkgQMXdYQxLyOBGjeIRgHPNxeFY4kTHYQtBJpDizCIKIF+gUQ7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Arvind Kumar <arvindkumar@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: [PATCH 1/1] drivers/scsi/vmw_pvscsi.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Date: Sun, 15 Jun 2014 00:19:49 +0200
Message-Id: <1402784389-19065-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Arvind Kumar <arvindkumar@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/vmw_pvscsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c88e146..07dc492 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -439,9 +439,9 @@ static int pvscsi_allocate_rings(struct pvscsi_adapter *adapter)
 	if (!adapter->cmp_ring)
 		return -ENOMEM;
 
-	BUG_ON(!IS_ALIGNED(adapter->ringStatePA, PAGE_SIZE));
-	BUG_ON(!IS_ALIGNED(adapter->reqRingPA, PAGE_SIZE));
-	BUG_ON(!IS_ALIGNED(adapter->cmpRingPA, PAGE_SIZE));
+	BUG_ON(!PAGE_ALIGNED(adapter->ringStatePA));
+	BUG_ON(!PAGE_ALIGNED(adapter->reqRingPA));
+	BUG_ON(!PAGE_ALIGNED(adapter->cmpRingPA));
 
 	if (!adapter->use_msg)
 		return 0;
@@ -453,7 +453,7 @@ static int pvscsi_allocate_rings(struct pvscsi_adapter *adapter)
 						 &adapter->msgRingPA);
 	if (!adapter->msg_ring)
 		return -ENOMEM;
-	BUG_ON(!IS_ALIGNED(adapter->msgRingPA, PAGE_SIZE));
+	BUG_ON(!PAGE_ALIGNED(adapter->msgRingPA));
 
 	return 0;
 }
@@ -1280,7 +1280,7 @@ static int pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
 		ctx->sgl = (void *)__get_free_pages(GFP_KERNEL,
 						    get_order(SGL_SIZE));
 		ctx->sglPA = 0;
-		BUG_ON(!IS_ALIGNED(((unsigned long)ctx->sgl), PAGE_SIZE));
+		BUG_ON(!PAGE_ALIGNED((ctx->sgl)));
 		if (!ctx->sgl) {
 			for (; i >= 0; --i, --ctx) {
 				free_pages((unsigned long)ctx->sgl,
-- 
1.8.4.5

