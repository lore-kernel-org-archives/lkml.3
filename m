Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbbALSGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbALSGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 100/216] xtensa: fix kmap_prot definition
Date: Mon, 12 Jan 2015 18:03:37 +0000
Message-Id: <1421085933-32536-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit ff009ab6d4d4581b62fa055ab6233133aca25ab8 upstream.

Replace PAGE_KERNEL with PAGE_KERNEL_EXEC to allow copy_to_user_page
invalidate icache for pages mapped with kmap.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/xtensa/include/asm/highmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/include/asm/highmem.h b/arch/xtensa/include/asm/highmem.h
index 2653ef5d55f1..694113314a77 100644
--- a/arch/xtensa/include/asm/highmem.h
+++ b/arch/xtensa/include/asm/highmem.h
@@ -23,7 +23,7 @@
 #define PKMAP_NR(virt)		(((virt) - PKMAP_BASE) >> PAGE_SHIFT)
 #define PKMAP_ADDR(nr)		(PKMAP_BASE + ((nr) << PAGE_SHIFT))
 
-#define kmap_prot		PAGE_KERNEL
+#define kmap_prot		PAGE_KERNEL_EXEC
 
 extern pte_t *pkmap_page_table;
 
-- 
2.1.4

