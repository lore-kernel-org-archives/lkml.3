Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab3EGEga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:36:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab3EGEZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:50 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=k8qfW24jbB8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=AoBxNks2gKEA:10 a=QyXUC8HyAAAA:8 a=cjyQI28R4ZOHKGmj5dMA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035855.676415514@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Woodhouse <David.Woodhouse@intel.com>
Subject: [088/126] mtd: Disable mtdchar mmap on MMU systems
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0088-mtd-Disable-mtdchar-mmap-on-MMU-systems.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

[ Upstream commit f5cf8f07423b2677cebebcebc863af77223a4972 ]

This code was broken because it assumed that all MTD devices were map-based.
Disable it for now, until it can be fixed properly for the next merge window.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/mtd/mtdchar.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index a6e7451..76afcb4 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1162,7 +1162,11 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
 	resource_size_t start, off;
 	unsigned long len, vma_len;
 
-	if (mtd->type == MTD_RAM || mtd->type == MTD_ROM) {
+        /* This is broken because it assumes the MTD device is map-based
+	   and that mtd->priv is a valid struct map_info.  It should be
+	   replaced with something that uses the mtd_get_unmapped_area()
+	   operation properly. */
+	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
 		off = get_vm_offset(vma);
 		start = map->phys;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);
-- 
1.7.10.4


