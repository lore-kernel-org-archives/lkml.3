Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733AbaFQUyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:54:32 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:32875 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933275AbaFQUyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:54:31 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2014 16:54:30 EDT
Date: Tue, 17 Jun 2014 13:44:29 -0700 (PDT)
From: Arvind Kumar <arvindkumar@vmware.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, VMware PV-Drivers <pv-drivers@vmware.com>
Message-ID: <1745375990.42893830.1403037869286.JavaMail.root@vmware.com>
In-Reply-To: <1402784389-19065-1-git-send-email-fabf@skynet.be>
References: <1402784389-19065-1-git-send-email-fabf@skynet.be>
Subject: Re: [PATCH 1/1] drivers/scsi/vmw_pvscsi.c: use PAGE_ALIGNED instead
 of IS_ALIGNED(PAGE_SIZE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.68]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF28 (Linux)/8.0.3_GA_5664)
Thread-Topic: drivers/scsi/vmw_pvscsi.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Thread-Index: EEjkZ6kOE7A5lchR5I5FuUIqJGfQew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch Fabian!

It looks fine to me. I think you should also include the emails listed by running 'scripts/get_maintainer.pl <your-patch>'.

Acked-by: Arvind Kumar <arvindkumar@vmware.com>

Thanks!
Arvind

----- Original Message -----
From: "Fabian Frederick" <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: "Fabian Frederick" <fabf@skynet.be>, "Arvind Kumar" <arvindkumar@vmware.com>, "VMware PV-Drivers" <pv-drivers@vmware.com>
Sent: Saturday, June 14, 2014 3:19:49 PM
Subject: [PATCH 1/1] drivers/scsi/vmw_pvscsi.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE

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
