Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3GBLIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3GBLIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Baatz <gmbnomis@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 40/50] ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU
Date: Tue,  2 Jul 2013 12:07:28 +0100
Message-Id: <1372763258-20664-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Baatz <gmbnomis@gmail.com>

commit 63384fd0b1509acf522a8a8fcede09087eedb7df upstream.

Commit 1bc3974 (ARM: 7755/1: handle user space mapped pages in
flush_kernel_dcache_page) moved the implementation of
flush_kernel_dcache_page() into mm/flush.c but did not implement it
on noMMU ARM.

Signed-off-by: Simon Baatz <gmbnomis@gmail.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mm/nommu.c | 6 ++++++
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
1.8.1.2

