Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaAQIrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:47:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43788 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaAQIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:47:13 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-07-52d8ee0f463b
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Date: Fri, 17 Jan 2014 09:46:56 +0100
Message-id: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t9jAV3+dzeCDHbPNLdouPaK1WLPmV/s
	Fs2L17NZXN41h81i7ZG77BYNH66zObB53Nt3mMXjyJHZLB6L97xk8tg/dw27R9+WVYwenzfJ
	BbBFcdmkpOZklqUW6dslcGU0f9jAWPCVveLh9pXMDYxL2boYOTkkBEwkdpzYwQ5hi0lcuLce
	KM7FISSwiFFi46o5TBBOK5PEz9u/mEGq2AQMJbredoF1iwjYSFw/8IIRpIhZYA2jxJbO22BF
	wkCJSZt+MYLYLAKqEhfa/7KC2LwCHhJHF34DsjmA1ilIzJlkM4GRewEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4DB5Jr2DcVWDxSFGAQ5GJR5eCfEbQUKsiWXFlbmHGCU4mJVEeLfe
	BArxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg9HJbeN8y
	6vp7V6XMJTOOLHD5siY8eMqNN8FrfCUit+3beyTL6vL8fzvvRzrmP5UIZm314f3hmvZwo/aL
	md9vLmRZ7el95tniqB1V5uah68snXp6+bspGZ5849V+x0/5MaHrYkWt16sSHO/yWJ+e2bn6z
	S+4U7z/uv+bC09sKO/7yF/xTrr028ZASS3FGoqEWc1FxIgCo2TEgDwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
atomic allocation, the code must test __GFP_WAIT flag presence.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../lustre/include/linux/libcfs/libcfs_private.h   |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
index d0d942c..dddccca1 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
@@ -120,7 +120,7 @@ do {						\
 do {									    \
 	LASSERT(!in_interrupt() ||					    \
 		((size) <= LIBCFS_VMALLOC_SIZE &&			    \
-		 ((mask) & GFP_ATOMIC)) != 0);			    \
+		 ((mask) & __GFP_WAIT) == 0));				    \
 } while (0)
 
 #define LIBCFS_ALLOC_POST(ptr, size)					    \
-- 
1.7.9.5

