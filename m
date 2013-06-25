Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3FYTMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:12:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3FYSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 15/95] parisc: remove the second argument of kmap_atomic()
Date: Tue, 25 Jun 2013 11:32:02 -0700
Message-Id: <20130625182155.370346465@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

commit 1ab4ce762370b82870834899e49c08129d7ae271 upstream.

kmap_atomic() requires only one argument now.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/cache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -606,7 +606,7 @@ void clear_user_highpage(struct page *pa
 	/* Clear using TMPALIAS region.  The page doesn't need to
 	   be flushed but the kernel mapping needs to be purged.  */
 
-	vto = kmap_atomic(page, KM_USER0);
+	vto = kmap_atomic(page);
 
 	/* The PA-RISC 2.0 Architecture book states on page F-6:
 	   "Before a write-capable translation is enabled, *all*
@@ -641,8 +641,8 @@ void copy_user_highpage(struct page *to,
 	   the `to' page must be flushed in copy_user_page_asm since
 	   it can be used to bring in executable code.  */
 
-	vfrom = kmap_atomic(from, KM_USER0);
-	vto = kmap_atomic(to, KM_USER1);
+	vfrom = kmap_atomic(from);
+	vto = kmap_atomic(to);
 
 	purge_kernel_dcache_page_asm((unsigned long)vto);
 	purge_tlb_start(flags);


