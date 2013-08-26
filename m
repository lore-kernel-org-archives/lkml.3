Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3HZLRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:17:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64107 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab3HZLQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:16:54 -0400
X-AuditID: cbfee68e-b7f756d000004512-6c-521b3920be9b
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 5/5] f2fs: support the inline xattrs
Date: Mon, 26 Aug 2013 20:16:41 +0900
Message-id: <1377515801-15243-5-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1377515801-15243-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1377515801-15243-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zY10FS+kgg2N7DCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyrhz9gdjwbKiioe3
	DzI1MG6M7mLk5JAQMJE4dPI9M4QtJnHh3no2EFtIYBmjxJ8nQjA1t/6cBopzAcWnM0r8eLmV
	BcJpY5LYcP4UUDcHB5uAtsTm/QYgDSICzBILpp5nBKlhFpjAKPF/0XsWkIQw0KQ577eD1bMI
	qEo86o0HCfMKuEt8+DKDDWKZrsSiEwdZQWxOAQ+Jjlc32CEOcpe4OPcy2F4Jge9sEk8enAGb
	ySIgIPFt8iEWkJkSArISmw5APSMpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnpFSfmFpfmpesl
	5+duYoQEbN8OxpsHrA8xJgONm8gsJZqcDwz4vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwdtSc+GxqkXQr/WuNwlf582wznGXfGj9++i6++Ms1
	BSEPxVVRzWVZV3tSnQ4ZN09eX5U/c+aG/ZFmtQVn8yZ9ON/0o3i3521FjxUKG3SX39RV+i7j
	/Mk27fR9vZfP9+0OrpBY9HBDwjxOjomXTz1N5y+YvsWF9xYfk5FztEdr3YweHstw4QxFJZbi
	jERDLeai4kQAmr9ULm4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV0FS+kgg/+ztSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8y4c/YHY8GyooqHtw8yNTBujO5i5OSQEDCRuPXnNBuELSZx4d56IJuLQ0hg
	OqPEj5dbWSCcNiaJDedPMXcxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCANN
	nfN+O1g9i4CqxKPeeJAwr4C7xIcvM6CW6UosOnGQFcTmFPCQ6Hh1gx3EFgKquTj3MssERt4F
	jAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj4pn0DsZVDRaHGAU4GJV4eAPYpIOEWBPL
	iitzDzFKcDArifCaiwKFeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0OR8YrXkl8YbGJmZGlkZm
	FkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwDhzpnfolYCerdr7OuR+rAs9xpx9
	SDSofPaklY4/5k7QuCxc8X2t6VM5m/N3nvpM8tq9d9Wv+sYXGlvjpvnJvnv+pUnzG3ej7V2Z
	aD4z57Wf1zhPP/T32YZ/BobtcSJHJufbtzveLvYMaHzxzf79uYICBYVvjBK79LLjIy5++x53
	YmKxTL6nxyUlluKMREMt5qLiRACbQX91zAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0. modified inode structure
--------------------------------------
metadata (e.g., i_mtime, i_ctime, etc)
--------------------------------------
direct pointers [0 ~ 873]

inline xattrs (200 bytes by default)

indirect pointers [0 ~ 4]
--------------------------------------
node footer
--------------------------------------

1. setxattr flow
 - read_all_xattrs copies all the xattrs from inline and xattr node block.
 - handle xattr entries
 - write_all_xattrs copies modified xattrs into inline and xattr node block.

2. getxattr flow
 - read_all_xattrs copies all the xattrs from inline and xattr node block.
 - check target entries

3. Usage
 # mount -t f2fs -o inline_xattr $DEV $MNT

 Once mounted with the inline_xattr option, f2fs marks all the newly created
 files to reserve an amount of inline xattr space explicitly inside the inode
 block. Without the mount option, f2fs will not touch any existing files and
 newly created files as well.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h          |  16 ++++
 fs/f2fs/node.c          |   7 ++
 fs/f2fs/xattr.c         | 249 ++++++++++++++++++++++++++++++++----------------
 fs/f2fs/xattr.h         |  12 +--
 include/linux/f2fs_fs.h |   2 +-
 5 files changed, 196 insertions(+), 90 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 0fe9302..608f0df 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -940,6 +940,22 @@ static inline unsigned int addrs_per_inode(struct f2fs_inode_info *fi)
 	return DEF_ADDRS_PER_INODE;
 }
 
+static inline void *inline_xattr_addr(struct page *page)
+{
+	struct f2fs_inode *ri;
+	ri = (struct f2fs_inode *)page_address(page);
+	return (void *)&(ri->i_addr[DEF_ADDRS_PER_INODE -
+					F2FS_INLINE_XATTR_ADDRS]);
+}
+
+static inline int inline_xattr_size(struct inode *inode)
+{
+	if (is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR))
+		return F2FS_INLINE_XATTR_ADDRS << 2;
+	else
+		return 0;
+}
+
 static inline int f2fs_readonly(struct super_block *sb)
 {
 	return sb->s_flags & MS_RDONLY;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 2a464a7..c3c03c9 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -787,6 +787,10 @@ int truncate_xattr_node(struct inode *inode, struct page *page)
 		return PTR_ERR(npage);
 
 	F2FS_I(inode)->i_xattr_nid = 0;
+
+	/* need to do checkpoint during fsync */
+	F2FS_I(inode)->xattr_ver = cur_cp_version(F2FS_CKPT(sbi));
+
 	set_new_dnode(&dn, inode, page, npage, nid);
 
 	if (page)
@@ -1464,6 +1468,9 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i;
 
+	if (!nid)
+		return;
+
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
 	BUG_ON(!i || i->state != NID_ALLOC);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 45a8ef8..1ac8a5f 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -262,13 +262,141 @@ static struct f2fs_xattr_entry *__find_xattr(void *base_addr, int name_index,
 	return entry;
 }
 
+static void *read_all_xattrs(struct inode *inode, struct page *ipage)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_xattr_header *header;
+	size_t size = PAGE_SIZE, inline_size = 0;
+	void *txattr_addr;
+
+	inline_size = inline_xattr_size(inode);
+
+	txattr_addr = kzalloc(inline_size + size, GFP_KERNEL);
+	if (!txattr_addr)
+		return NULL;
+
+	/* read from inline xattr */
+	if (inline_size) {
+		struct page *page = NULL;
+		void *inline_addr;
+
+		if (ipage) {
+			inline_addr = inline_xattr_addr(ipage);
+		} else {
+			page = get_node_page(sbi, inode->i_ino);
+			if (IS_ERR(page))
+				goto fail;
+			inline_addr = inline_xattr_addr(page);
+		}
+		memcpy(txattr_addr, inline_addr, inline_size);
+		f2fs_put_page(page, 1);
+	}
+
+	/* read from xattr node block */
+	if (F2FS_I(inode)->i_xattr_nid) {
+		struct page *xpage;
+		void *xattr_addr;
+
+		/* The inode already has an extended attribute block. */
+		xpage = get_node_page(sbi, F2FS_I(inode)->i_xattr_nid);
+		if (IS_ERR(xpage))
+			goto fail;
+
+		xattr_addr = page_address(xpage);
+		memcpy(txattr_addr + inline_size, xattr_addr, PAGE_SIZE);
+		f2fs_put_page(xpage, 1);
+	}
+
+	header = XATTR_HDR(txattr_addr);
+
+	/* never been allocated xattrs */
+	if (le32_to_cpu(header->h_magic) != F2FS_XATTR_MAGIC) {
+		header->h_magic = cpu_to_le32(F2FS_XATTR_MAGIC);
+		header->h_refcount = cpu_to_le32(1);
+	}
+	return txattr_addr;
+fail:
+	kzfree(txattr_addr);
+	return NULL;
+}
+
+static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
+				void *txattr_addr, struct page *ipage)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	size_t inline_size = 0;
+	void *xattr_addr;
+	struct page *xpage;
+	nid_t new_nid = 0;
+	int err;
+
+	inline_size = inline_xattr_size(inode);
+
+	if (hsize > inline_size && !F2FS_I(inode)->i_xattr_nid)
+		if (!alloc_nid(sbi, &new_nid))
+			return -ENOSPC;
+
+	/* write to inline xattr */
+	if (inline_size) {
+		struct page *page = NULL;
+		void *inline_addr;
+
+		if (ipage) {
+			inline_addr = inline_xattr_addr(ipage);
+		} else {
+			page = get_node_page(sbi, inode->i_ino);
+			if (IS_ERR(page)) {
+				alloc_nid_failed(sbi, new_nid);
+				return PTR_ERR(page);
+			}
+			inline_addr = inline_xattr_addr(page);
+		}
+		memcpy(inline_addr, txattr_addr, inline_size);
+		f2fs_put_page(page, 1);
+
+		/* no need to use xattr node block */
+		if (hsize <= inline_size) {
+			err = truncate_xattr_node(inode, ipage);
+			alloc_nid_failed(sbi, new_nid);
+			return err;
+		}
+	}
+
+	/* write to xattr node block */
+	if (F2FS_I(inode)->i_xattr_nid) {
+		xpage = get_node_page(sbi, F2FS_I(inode)->i_xattr_nid);
+		if (IS_ERR(xpage)) {
+			alloc_nid_failed(sbi, new_nid);
+			return PTR_ERR(xpage);
+		}
+		BUG_ON(new_nid);
+	} else {
+		struct dnode_of_data dn;
+		set_new_dnode(&dn, inode, NULL, NULL, new_nid);
+		xpage = new_node_page(&dn, XATTR_NODE_OFFSET, ipage);
+		if (IS_ERR(xpage)) {
+			alloc_nid_failed(sbi, new_nid);
+			return PTR_ERR(xpage);
+		}
+		alloc_nid_done(sbi, new_nid);
+	}
+
+	xattr_addr = page_address(xpage);
+	memcpy(xattr_addr, txattr_addr + inline_size, PAGE_SIZE -
+						sizeof(struct node_footer));
+	set_page_dirty(xpage);
+	f2fs_put_page(xpage, 1);
+
+	/* need to checkpoint during fsync */
+	F2FS_I(inode)->xattr_ver = cur_cp_version(F2FS_CKPT(sbi));
+	return 0;
+}
+
 int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 		void *buffer, size_t buffer_size)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_xattr_entry *entry;
-	struct page *page;
+	void *base_addr;
 	int error = 0;
 	size_t value_len, name_len;
 
@@ -276,14 +404,11 @@ int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 		return -EINVAL;
 	name_len = strlen(name);
 
-	if (!fi->i_xattr_nid)
-		return -ENODATA;
-
-	page = get_node_page(sbi, fi->i_xattr_nid);
-	if (IS_ERR(page))
-		return PTR_ERR(page);
+	base_addr = read_all_xattrs(inode, NULL);
+	if (!base_addr)
+		return -ENOMEM;
 
-	entry = __find_xattr(page_address(page), name_index, name_len, name);
+	entry = __find_xattr(base_addr, name_index, name_len, name);
 	if (IS_XATTR_LAST_ENTRY(entry)) {
 		error = -ENODATA;
 		goto cleanup;
@@ -303,28 +428,21 @@ int f2fs_getxattr(struct inode *inode, int name_index, const char *name,
 	error = value_len;
 
 cleanup:
-	f2fs_put_page(page, 1);
+	kzfree(base_addr);
 	return error;
 }
 
 ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
 	struct inode *inode = dentry->d_inode;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_xattr_entry *entry;
-	struct page *page;
 	void *base_addr;
 	int error = 0;
 	size_t rest = buffer_size;
 
-	if (!fi->i_xattr_nid)
-		return 0;
-
-	page = get_node_page(sbi, fi->i_xattr_nid);
-	if (IS_ERR(page))
-		return PTR_ERR(page);
-	base_addr = page_address(page);
+	base_addr = read_all_xattrs(inode, NULL);
+	if (!base_addr)
+		return -ENOMEM;
 
 	list_for_each_xattr(entry, base_addr) {
 		const struct xattr_handler *handler =
@@ -347,7 +465,7 @@ ssize_t f2fs_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 	}
 	error = buffer_size - rest;
 cleanup:
-	f2fs_put_page(page, 1);
+	kzfree(base_addr);
 	return error;
 }
 
@@ -356,14 +474,13 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct f2fs_xattr_header *header = NULL;
 	struct f2fs_xattr_entry *here, *last;
-	struct page *page;
 	void *base_addr;
-	int error, found, free, newsize;
+	int found, newsize;
 	size_t name_len;
-	char *pval;
 	int ilock;
+	__u32 new_hsize;
+	int error = -ENOMEM;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -373,53 +490,16 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 
 	name_len = strlen(name);
 
-	if (name_len > F2FS_NAME_LEN || value_len > MAX_VALUE_LEN)
+	if (name_len > F2FS_NAME_LEN || value_len > MAX_VALUE_LEN(inode))
 		return -ERANGE;
 
 	f2fs_balance_fs(sbi);
 
 	ilock = mutex_lock_op(sbi);
 
-	if (!fi->i_xattr_nid) {
-		/* Allocate new attribute block */
-		struct dnode_of_data dn;
-		nid_t new_nid;
-
-		if (!alloc_nid(sbi, &new_nid)) {
-			error = -ENOSPC;
-			goto exit;
-		}
-		set_new_dnode(&dn, inode, NULL, NULL, new_nid);
-		mark_inode_dirty(inode);
-
-		page = new_node_page(&dn, XATTR_NODE_OFFSET, ipage);
-		if (IS_ERR(page)) {
-			alloc_nid_failed(sbi, new_nid);
-			error = PTR_ERR(page);
-			goto exit;
-		}
-
-		alloc_nid_done(sbi, new_nid);
-		base_addr = page_address(page);
-		header = XATTR_HDR(base_addr);
-		header->h_magic = cpu_to_le32(F2FS_XATTR_MAGIC);
-		header->h_refcount = cpu_to_le32(1);
-	} else {
-		/* The inode already has an extended attribute block. */
-		page = get_node_page(sbi, fi->i_xattr_nid);
-		if (IS_ERR(page)) {
-			error = PTR_ERR(page);
-			goto exit;
-		}
-
-		base_addr = page_address(page);
-		header = XATTR_HDR(base_addr);
-	}
-
-	if (le32_to_cpu(header->h_magic) != F2FS_XATTR_MAGIC) {
-		error = -EIO;
-		goto cleanup;
-	}
+	base_addr = read_all_xattrs(inode, ipage);
+	if (!base_addr)
+		goto exit;
 
 	/* find entry with wanted name. */
 	here = __find_xattr(base_addr, name_index, name_len, name);
@@ -435,22 +515,25 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 
 	/* 1. Check space */
 	if (value) {
-		/* If value is NULL, it is remove operation.
+		int free;
+		/*
+		 * If value is NULL, it is remove operation.
 		 * In case of update operation, we caculate free.
 		 */
-		free = MIN_OFFSET - ((char *)last - (char *)header);
+		free = MIN_OFFSET(inode) - ((char *)last - (char *)base_addr);
 		if (found)
 			free = free - ENTRY_SIZE(here);
 
 		if (free < newsize) {
 			error = -ENOSPC;
-			goto cleanup;
+			goto exit;
 		}
 	}
 
 	/* 2. Remove old entry */
 	if (found) {
-		/* If entry is found, remove old entry.
+		/*
+		 * If entry is found, remove old entry.
 		 * If not found, remove operation is not needed.
 		 */
 		struct f2fs_xattr_entry *next = XATTR_NEXT_ENTRY(here);
@@ -461,10 +544,15 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 		memset(last, 0, oldsize);
 	}
 
+	new_hsize = (char *)last - (char *)base_addr;
+
 	/* 3. Write new entry */
 	if (value) {
-		/* Before we come here, old entry is removed.
-		 * We just write new entry. */
+		char *pval;
+		/*
+		 * Before we come here, old entry is removed.
+		 * We just write new entry.
+		 */
 		memset(last, 0, newsize);
 		last->e_name_index = name_index;
 		last->e_name_len = name_len;
@@ -472,10 +560,12 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 		pval = last->e_name + name_len;
 		memcpy(pval, value, value_len);
 		last->e_value_size = cpu_to_le16(value_len);
+		new_hsize += newsize;
 	}
 
-	set_page_dirty(page);
-	f2fs_put_page(page, 1);
+	error = write_all_xattrs(inode, new_hsize, base_addr, ipage);
+	if (error)
+		goto exit;
 
 	if (is_inode_flag_set(fi, FI_ACL_MODE)) {
 		inode->i_mode = fi->i_acl_mode;
@@ -483,19 +573,12 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 		clear_inode_flag(fi, FI_ACL_MODE);
 	}
 
-	/* store checkpoint version for conducting checkpoint during fsync */
-	fi->xattr_ver = cur_cp_version(F2FS_CKPT(sbi));
-
 	if (ipage)
 		update_inode(inode, ipage);
 	else
 		update_inode_page(inode);
-	mutex_unlock_op(sbi, ilock);
-
-	return 0;
-cleanup:
-	f2fs_put_page(page, 1);
 exit:
 	mutex_unlock_op(sbi, ilock);
+	kzfree(base_addr);
 	return error;
 }
diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
index c3ec042..02a08fb 100644
--- a/fs/f2fs/xattr.h
+++ b/fs/f2fs/xattr.h
@@ -69,16 +69,16 @@ struct f2fs_xattr_entry {
 				!IS_XATTR_LAST_ENTRY(entry);\
 				entry = XATTR_NEXT_ENTRY(entry))
 
-#define MIN_OFFSET	XATTR_ALIGN(PAGE_SIZE - \
-			sizeof(struct node_footer) - \
-			sizeof(__u32))
+#define MIN_OFFSET(i)	XATTR_ALIGN(inline_xattr_size(i) + PAGE_SIZE -	\
+				sizeof(struct node_footer) - sizeof(__u32))
 
-#define MAX_VALUE_LEN	(MIN_OFFSET - sizeof(struct f2fs_xattr_header) - \
-			sizeof(struct f2fs_xattr_entry))
+#define MAX_VALUE_LEN(i)	(MIN_OFFSET(i) -			\
+				sizeof(struct f2fs_xattr_header) -	\
+				sizeof(struct f2fs_xattr_entry))
 
 /*
  * On-disk structure of f2fs_xattr
- * We use only 1 block for xattr.
+ * We use inline xattrs space + 1 block for xattr.
  *
  * +--------------------+
  * | f2fs_xattr_header  |
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 93e7020..bb942f6 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -140,7 +140,7 @@ struct f2fs_extent {
 } __packed;
 
 #define F2FS_NAME_LEN		255
-#define F2FS_INLINE_XATTR_ADDRS	0	/* 0 bytes for inline xattrs */
+#define F2FS_INLINE_XATTR_ADDRS	50	/* 200 bytes for inline xattrs */
 #define DEF_ADDRS_PER_INODE	923	/* Address Pointers in an Inode */
 #define ADDRS_PER_INODE(fi)	addrs_per_inode(fi)
 #define ADDRS_PER_BLOCK		1018	/* Address Pointers in a Direct Block */
-- 
1.8.3.1.437.g0dbd812

