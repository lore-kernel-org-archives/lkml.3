Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab3CRFxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:53:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63240 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3CRFw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:52:57 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-bd-5146abb81da5
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 13/19] f2fs: fix return value of releasepage for node and data
Date: Mon, 18 Mar 2013 14:52:11 +0900
Message-id: <1363585931-8441-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t8zI90dq90CDbYfk7TYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr42NLDVnCav2LzsS72BsYjPF2MHBwSAiYSexdUdjFy
	ApliEhfurWfrYuTiEBJYxijx+eJxVoiEicTPpRuhEosYJb69vssI4bQxSSx6sYEFZBKbgLbE
	5v0GIA0iAswSC6aeB6thFpjAKPF/0XsWkISwgJ/EwV1H2UBsFgFViVMftjKC9PIKuEncP14F
	sUxXYvX/5+wgvRICB9gkFnfuYISoF5D4NvkQC8TVshKbDjBD1EtKHFxxg2UCo+ACRoZVjKKp
	BckFxUnpRaZ6xYm5xaV56XrJ+bmbGCGhNXEH4/0D1ocYk4HGTWSWEk3OB4ZmXkm8obGZkYWp
	iamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYNx4oa8pTXqy7xjWj
	XL94q/GSh4Wp75UePjq1TIhBZ4f4E2Fha8sGoS82wpyKRzQebfydk/w3w3Th4Ye363x7bC9U
	vt5QknC/Ps1D8GnX7OJ832Ntc81m9zQEKW2aMlErsvzNvekKbOvmWLgr21x93Ha664oaz7KW
	2xflzxy8JSVzidWiz0lIiaU4I9FQi7moOBEAtdINsUMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgO6O1W6BBnv3iVjs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmfGzpYSs4zV+x
	+VgXewPjEZ4uRk4OCQETiZ9LN7JB2GISF+6tB7K5OIQEFjFKfHt9lxHCaWOSWPRiA0sXIwcH
	m4C2xOb9BiANIgLMEgumngerYRaYwCjxf9F7FpCEsICfxMFdR8GmsgioSpz6sJURpJdXwE3i
	/vEqiGW6Eqv/P2efwMi9gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw6D6T3sG4qsHi
	EKMAB6MSD68Bj2ugEGtiWXFl7iFGCQ5mJRHehhC3QCHelMTKqtSi/Pii0pzU4kOMyUDLJzJL
	iSbnA+MqryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYVyr4
	+Wuf1b8jmn3xQWNbqHjRXM8Fe9763pz/wVR3Zn/oKYUWg51T2u+ePb275U6VgJ0OU9fzCR8l
	CzielG3tOiVpO/ujrMXH2w/NFbNmn7T13uXCY3nv8aqL/5s/7t00Z2rH9CWHeO83rw+8rSBT
	4nZvndzT3BviK/Pco5/HnXWSFVfcafy/UYmlOCPRUIu5qDgRAPLHerOhAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the return value of releasepage is equal to zero, the page cannot be reclaimed.
Instead, we should return 1 in order to reclaim clean pages.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c |  4 +++-
 fs/f2fs/node.c | 13 +++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6616137..cd6b2cc 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -680,8 +680,10 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned long offset)
 
 static int f2fs_release_data_page(struct page *page, gfp_t wait)
 {
+	if (PageWriteback(page))
+		return 0;
 	ClearPagePrivate(page);
-	return 0;
+	return 1;
 }
 
 static int f2fs_set_data_page_dirty(struct page *page)
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 94951d9..c60919f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -933,7 +933,6 @@ struct page *get_node_page_ra(struct page *parent, int start)
 	if (!nid)
 		return ERR_PTR(-ENOENT);
 
-repeat:
 	page = grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
@@ -961,12 +960,6 @@ page_hit:
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
-
-	/* Has the page been truncated? */
-	if (page->mapping != mapping) {
-		f2fs_put_page(page, 1);
-		goto repeat;
-	}
 	mark_page_accessed(page);
 	return page;
 }
@@ -1188,8 +1181,10 @@ static void f2fs_invalidate_node_page(struct page *page, unsigned long offset)
 
 static int f2fs_release_node_page(struct page *page, gfp_t wait)
 {
+	if (PageWriteback(page))
+		return 0;
 	ClearPagePrivate(page);
-	return 0;
+	return 1;
 }
 
 /*
@@ -1630,8 +1625,6 @@ flush_now:
 			write_lock(&nm_i->nat_tree_lock);
 			__del_from_nat_cache(nm_i, ne);
 			write_unlock(&nm_i->nat_tree_lock);
-
-			/* We can reuse this freed nid at this point */
 			add_free_nid(NM_I(sbi), nid);
 		} else {
 			write_lock(&nm_i->nat_tree_lock);
-- 
1.8.1.3.566.gaa39828

