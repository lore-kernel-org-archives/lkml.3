Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3CDBLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:11:31 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44947 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3CDBL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:11:28 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] iommu: add a dma remap fault reason.
Date: Mon,  4 Mar 2013 09:10:49 +0800
Message-Id: <1362359449-29653-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of dma fault reasons in intel's document are from 1 to 0xD, but in dmar.c I cannot find fault reason 0xD.

In this document:
Intel Virtualization Technology for Directed I/O Architecture Specification
http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf

Chapter 4. Support For Device-IOTLBs

Table 6. Unsuccessful Translated Requests

There is fault reason for 0xD not listed in kernel:
    Present context-entry used to process translation request
    specifies blocking of Translation Requests (Translation Type (T)
    field value not equal to 01b).

So I think 0xD should be added.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/dmar.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index dc7e478..e5cdaf8 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1083,6 +1083,7 @@ static const char *dma_remap_fault_reasons[] =
 	"non-zero reserved fields in RTP",
 	"non-zero reserved fields in CTP",
 	"non-zero reserved fields in PTE",
+	"PCE for translation request specifies blocking",
 };
 
 static const char *irq_remap_fault_reasons[] =
-- 
1.7.10.4

