Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaLIWwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:52:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaLIWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:50:42 -0500
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/25] bury memcpy_toiovec()
Date: Tue,  9 Dec 2014 22:50:38 +0000
Message-Id: <1418165438-2205-25-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20141209224928.GL22149@ZenIV.linux.org.uk>
References: <20141209224928.GL22149@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

no users left

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/uio.h |  1 -
 lib/iovec.c         | 25 -------------------------
 2 files changed, 26 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index bd8569a..a41e252 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -131,7 +131,6 @@ size_t csum_and_copy_to_iter(void *addr, size_t bytes, __wsum *csum, struct iov_
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 
 int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
-int memcpy_toiovec(struct iovec *iov, unsigned char *kdata, int len);
 int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 			int offset, int len);
 int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
diff --git a/lib/iovec.c b/lib/iovec.c
index df3abd1..2d99cb4 100644
--- a/lib/iovec.c
+++ b/lib/iovec.c
@@ -29,31 +29,6 @@ EXPORT_SYMBOL(memcpy_fromiovec);
 
 /*
  *	Copy kernel to iovec. Returns -EFAULT on error.
- *
- *	Note: this modifies the original iovec.
- */
-
-int memcpy_toiovec(struct iovec *iov, unsigned char *kdata, int len)
-{
-	while (len > 0) {
-		if (iov->iov_len) {
-			int copy = min_t(unsigned int, iov->iov_len, len);
-			if (copy_to_user(iov->iov_base, kdata, copy))
-				return -EFAULT;
-			kdata += copy;
-			len -= copy;
-			iov->iov_len -= copy;
-			iov->iov_base += copy;
-		}
-		iov++;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(memcpy_toiovec);
-
-/*
- *	Copy kernel to iovec. Returns -EFAULT on error.
  */
 
 int memcpy_toiovecend(const struct iovec *iov, unsigned char *kdata,
-- 
2.1.3

