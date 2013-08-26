Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3HZLQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:16:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64107 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab3HZLQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:16:52 -0400
X-AuditID: cbfee68e-b7f756d000004512-68-521b39209b7c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/5] f2fs: introduce __find_xattr for readability
Date: Mon, 26 Aug 2013 20:16:39 +0900
Message-id: <1377515801-15243-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1377515801-15243-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1377515801-15243-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zY10FS+kgg/W75S2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjj/+QFLwTTpirOX
	bzE3MDaIdTFycEgImEhcvmndxcgJZIpJXLi3nq2LkYtDSGAZo8TDfcuZIRImEi8vnGGBSExn
	lLh48A8rhNPGJLHh/ClmkElsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgKOEjvn
	tLCC2CwCqhIPvxwDs3kF3CWWHl3ICrFNV2LRiYNgNqeAh0THqxvsILYQUM3FuZdZIGq+s0lc
	OWMIMUdA4tvkQywQ38hKbDoAdbSkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSkV5yYW1yal66X
	nJ+7iRESsH07GG8esD7EmAw0biKzlGhyPjDg80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmNtVc4/3Ge9VTsPVM+08bDa8MuR//eEAV1HP/HUx
	bgvv3jCqeluYPcfQ1GXywUeXo3wepsk/+rxhl/8E4VlvHZtXlrk4x0Vvmyi1wvfLi7aaVUdi
	v4TE3fb8JO/GdmKG2OyAoNM7bnd+l8s4sGbhYmG7Aqk2+3DbSyedri1idD7nfCWTZ3rddCWW
	4oxEQy3mouJEAIQqKjpuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV0FS+kgg3tHpC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8w4//kBS8E06Yqzl28xNzA2iHUxcnJICJhIvLxwhgXCFpO4cG89WxcjF4eQ
	wHRGiYsH/7BCOG1MEhvOn2LuYuTgYBPQlti83wCkQUSAWWLB1POMIDXMAhMYJf4veg82SVjA
	UWLnnBZWEJtFQFXi4ZdjYDavgLvE0qMLWSG26UosOnEQzOYU8JDoeHWDHcQWAqq5OPcyywRG
	3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPimfQOxlUNFocYBTgYlXh4A9ikg4RY
	E8uKK3MPMUpwMCuJ8JqLAoV4UxIrq1KL8uOLSnNSiw8xJgNdNZFZSjQ5HxiveSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqO+hEL7C/EGAwdd5bkkxu2/z
	/V1+NZyrerlGRONlufilt5+m+npIVZx/U1I84UWy//5lutO3ZkayWGnM3Pvt+E7WF8+qDt9e
	dnBniP2HkOStAouKFFZvmTA7TvY3s9wxx61bSpZJbFVqkPzhO0ej8LngF6PZ7lbncyTmFf31
	UT3C5flYXnT5YyWW4oxEQy3mouJEAJZZHxXNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __find_xattr is to search the wanted xattr entry starting from the
base_addr.

If not found, the returned entry is the last empty xattr entry that can be
allocated newly.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/xattr.c | 46 +++++++++++++++++++++-------------------------
 fs/f2fs/xattr.h |  3 +--
 2 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 3bc307c..45a8ef8 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -246,6 +246,22 @@ static inline const struct xattr_handler *f2fs_xattr_handler(int name_index)
 	return handler;
 }
 
+static struct f2fs_xattr_entry *__find_xattr(void *base_addr, int name_index,
+					size_t name_len, const char *name)
+{
+	struct f2fs_xattr_entry *entry;
+
+	list_for_each_xattr(entry, base_addr) {
+		if (entry->e_name_index != name_index)
+			continue;
+		if (entry->e_name_len != name_len)
+			continue;
+		if (!memcmp(entry->e_name, name, name_len))
+			break;
+	}
+	return entry;
+}
+
 int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 		void *buffer, size_t buffer_size)
 {
@@ -253,8 +269,7 @@ int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_xattr_entry *entry;
 	struct page *page;
-	void *base_addr;
-	int error = 0, found = 0;
+	int error = 0;
 	size_t value_len, name_len;
 
 	if (name == NULL)
@@ -267,19 +282,9 @@ int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 	page = get_node_page(sbi, fi->i_xattr_nid);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
-	base_addr = page_address(page);
 
-	list_for_each_xattr(entry, base_addr) {
-		if (entry->e_name_index != name_index)
-			continue;
-		if (entry->e_name_len != name_len)
-			continue;
-		if (!memcmp(entry->e_name, name, name_len)) {
-			found = 1;
-			break;
-		}
-	}
-	if (!found) {
+	entry = __find_xattr(page_address(page), name_index, name_len, name);
+	if (IS_XATTR_LAST_ENTRY(entry)) {
 		error = -ENODATA;
 		goto cleanup;
 	}
@@ -417,18 +422,9 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 	}
 
 	/* find entry with wanted name. */
-	found = 0;
-	list_for_each_xattr(here, base_addr) {
-		if (here->e_name_index != name_index)
-			continue;
-		if (here->e_name_len != name_len)
-			continue;
-		if (!memcmp(here->e_name, name, name_len)) {
-			found = 1;
-			break;
-		}
-	}
+	here = __find_xattr(base_addr, name_index, name_len, name);
 
+	found = IS_XATTR_LAST_ENTRY(here) ? 0 : 1;
 	last = here;
 
 	while (!IS_XATTR_LAST_ENTRY(last))
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index 3c0817b..c3ec042 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -51,7 +51,7 @@ struct f2fs_xattr_entry {
 
 #define XATTR_HDR(ptr)		((struct f2fs_xattr_header *)(ptr))
 #define XATTR_ENTRY(ptr)	((struct f2fs_xattr_entry *)(ptr))
-#define XATTR_FIRST_ENTRY(ptr)	(XATTR_ENTRY(XATTR_HDR(ptr)+1))
+#define XATTR_FIRST_ENTRY(ptr)	(XATTR_ENTRY(XATTR_HDR(ptr) + 1))
 #define XATTR_ROUND		(3)
 
 #define XATTR_ALIGN(size)	((size + XATTR_ROUND) & ~XATTR_ROUND)
@@ -69,7 +69,6 @@ struct f2fs_xattr_entry {
 				!IS_XATTR_LAST_ENTRY(entry);\
 				entry = XATTR_NEXT_ENTRY(entry))
 
-
 #define MIN_OFFSET	XATTR_ALIGN(PAGE_SIZE - \
 			sizeof(struct node_footer) - \
 			sizeof(__u32))
-- 
1.8.3.1.437.g0dbd812

