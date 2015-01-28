Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbbA1GIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:08:52 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:19754 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbbA1GIv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:08:51 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'david@fromorbit.com'" <david@fromorbit.com>,
        "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Jan 2015 14:08:47 +0800
Subject: [PATCH] xfs:change kmem_free to use generic kvfree()
Thread-Topic: [PATCH] xfs:change kmem_free to use generic kvfree()
Thread-Index: AdA6wOCuyMEVQ0rlRtit7UGh5ld9pg==
Message-ID: <35FD53F367049845BC99AC72306C23D1044A02027DFF@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kmem_free to use kvfree() generic function,
remove the duplicated code.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 fs/xfs/kmem.c | 10 ----------
 fs/xfs/kmem.h |  5 ++++-
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 53e95b2..a7a3a63 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -91,16 +91,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
 	return ptr;
 }
 
-void
-kmem_free(const void *ptr)
-{
-	if (!is_vmalloc_addr(ptr)) {
-		kfree(ptr);
-	} else {
-		vfree(ptr);
-	}
-}
-
 void *
 kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
 	     xfs_km_flags_t flags)
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 64db0e5..cc6b768 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -63,7 +63,10 @@ kmem_flags_convert(xfs_km_flags_t flags)
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
 extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
 extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
-extern void  kmem_free(const void *);
+static inline void  kmem_free(const void *ptr)
+{
+	kvfree(ptr);
+}
 
 
 extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
-- 
2.2.2
