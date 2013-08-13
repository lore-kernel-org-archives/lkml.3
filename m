Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3HMP6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2508 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab3HMP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:41 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=mYTTPL8bAvwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uzuF32fNYaQA:10 a=pGLkceISAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MSl-tDqOz04A:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=RJDHCchAG58bybso:21 a=BomYhGtMPyj28RIo:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155829.905513259@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Simon Baatz <gmbnomis@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [40/88] ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0040-ARM-7772-1-Fix-missing-flush_kernel_dcache_page-for-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Simon Baatz <gmbnomis@gmail.com>

[ Upstream commit 63384fd0b1509acf522a8a8fcede09087eedb7df ]

Commit 1bc3974 (ARM: 7755/1: handle user space mapped pages in
flush_kernel_dcache_page) moved the implementation of
flush_kernel_dcache_page() into mm/flush.c but did not implement it
on noMMU ARM.

Signed-off-by: Simon Baatz <gmbnomis@gmail.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Cc: <stable@vger.kernel.org> # 3.2+: 1bc3974: ARM: 7755/1
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mm/nommu.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index d51225f..eb5293a 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -57,6 +57,12 @@ void flush_dcache_page(struct page *page)
 }
 EXPORT_SYMBOL(flush_dcache_page);
 
+void flush_kernel_dcache_page(struct page *page)
+{
+	__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
+}
+EXPORT_SYMBOL(flush_kernel_dcache_page);
+
 void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 		       unsigned long uaddr, void *dst, const void *src,
 		       unsigned long len)
-- 
1.7.10.4


