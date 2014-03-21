Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbaCUCDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:03:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52341 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932AbaCUCDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:03:10 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-8e-532b9ddabcb1
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/3] f2fs: avoid RECLAIM_FS-ON-W warning
Date: Fri, 21 Mar 2014 11:01:15 +0900
Message-id: <1395367275-1674-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395367275-1674-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395367275-1674-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zY91bc7WDDS6e4rO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PDiWWMBbN5Kxb3
	vmVuYOzh7mLk5JAQMJGYequDDcIWk7hwbz2QzcUhJLCMUeJAfy8bTNH2E6eZIRLTGSXefrrH
	DuF0MkmcvPGJtYuRg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g9C0hCWMBCYsvq+ywg
	9SwCqhIHV1qAhHkF3CQ2POlghlimLbHt+URGkBJOAXeJ7q11IGEhoJLrszawgIyUEPjOJvH9
	/DVGkASLgIDEt8mHwEZKCMhKbDoANUZS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7N
	S9dLzs/dxAgJ2N4djLcPWB9iTAYaN5FZSjQ5HxjweSXxhsZmRhamJqbGRuaWZqQJK4nzJj1M
	ChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6OB6Na72j2r+tRSh5zP1YivWnTd+dO6CJM+D
	4pl5adYqHZMu50apWj4P6aoxvRPbr7bhoMwC0296hf80F5z80z9Jg1FU+9M8XVkbrUD9V2t+
	9tyXYf3xKWSi+iNNvTyVd3fdVx9g/2AZ26zrsc+/zH37X8sCBvlFRTwBhR+EdVk2Vh3MPTRF
	iaU4I9FQi7moOBEAiuaESG4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd1bc7WDDQ6u5La4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjw4lljAWzeSsW975lbmDs4e5i5OSQEDCR2H7iNDOELSZx4d56ti5GLg4h
	gemMEm8/3WOHcDqZJE7e+MTaxcjBwSagLbF5vwFIg4gAs8SCqecZQWqYBSYwSvxf9J4FJCEs
	YCGxZfV9FpB6FgFViYMrLUDCvAJuEhuedEAt05bY9nwiI0gJp4C7RPfWOpCwEFDJ9VkbWCYw
	8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwPz6R3MK5qsDjEKMDBqMTDW8GpHSzE
	mlhWXJl7iFGCg1lJhPd1N1CINyWxsiq1KD++qDQntfgQYzLQTROZpUST84GxmlcSb2hsYmZk
	aWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjEmMOYJZqdXqLyv490eZX1/j
	YzrvzH+HM4HqK+78dd18j+vLdeuHnD8Zbd8/jJLz+aabs1O4ecFdhbZuriUHQq487XjBkbk/
	/fIlCY9jExznbf2ldI11p5V920+7vaFRG3V8dpnGfeURF2DuEmw2uTMrbMVxyZWy2+79euNs
	v8mIweWPT7vWXyWW4oxEQy3mouJEAJes9VzLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should resolve the following possible bug.

RECLAIM_FS-ON-W at:
 mark_held_locks+0xb9/0x140
 lockdep_trace_alloc+0x85/0xf0
 __kmalloc+0x53/0x1d0
 read_all_xattrs+0x3d1/0x3f0 [f2fs]
 f2fs_getxattr+0x4f/0x100 [f2fs]
 f2fs_get_acl+0x4c/0x290 [f2fs]
 get_acl+0x4f/0x80
 posix_acl_create+0x72/0x180
 f2fs_init_acl+0x29/0xcc [f2fs]
 __f2fs_add_link+0x259/0x710 [f2fs]
 f2fs_create+0xad/0x1c0 [f2fs]
 vfs_create+0xed/0x150
 do_last+0xd36/0xed0
 path_openat+0xc5/0x680
 do_filp_open+0x43/0xa0
 do_sys_open+0x13c/0x230
 SyS_creat+0x1e/0x20
 system_call_fastpath+0x16/0x1b

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/acl.c   | 2 +-
 fs/f2fs/xattr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index fa8da4c..a285715 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -174,7 +174,7 @@ struct posix_acl *f2fs_get_acl(struct inode *inode, int type)
 
 	retval = f2fs_getxattr(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
-		value = kmalloc(retval, GFP_KERNEL);
+		value = kmalloc(retval, GFP_F2FS_ZERO);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		retval = f2fs_getxattr(inode, name_index, "", value, retval);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 8419130..0121e45 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -275,7 +275,7 @@ static void *read_all_xattrs(struct inode *inode, struct page *ipage)
 
 	inline_size = inline_xattr_size(inode);
 
-	txattr_addr = kzalloc(inline_size + size, GFP_KERNEL);
+	txattr_addr = kzalloc(inline_size + size, GFP_F2FS_ZERO);
 	if (!txattr_addr)
 		return NULL;
 
-- 
1.8.4.474.g128a96c

