Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaDPFM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:12:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50957 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaDPFMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:12:54 -0400
X-AuditID: cbfee68f-b7f156d00000276c-3d-534e11557941
Message-id: <1397625052.7727.8.camel@kjgkr>
Subject: Re: [PATCH 2/3 v2] f2fs: fix to decrease the number of dirty dentry
 page
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 16 Apr 2014 14:10:52 +0900
In-reply-to: <1397559423-27411-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1397559423-27411-1-git-send-email-jaegeuk.kim@samsung.com>
 <1397559423-27411-2-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY91QQb9gg7bTohaXFrlb7Nl7ksXi
	8q45bA7MHrsXfGby+LxJLoApissmJTUnsyy1SN8ugSvjz4q9jAXNohVbZ39ha2CcI9jFyMEh
	IWAisXcLdxcjJ5ApJnHh3nq2LkYuDiGBZYwSdx9PY4JImEhcOH+MESKxiFFiXdcLFgjnFaPE
	0i0/2EGqeAW0JbpmH2MGsYUFgiWmv9rIDLKBDSi+eb8BSFhIQFHi7f67rCBhESD78nsnEJNZ
	wENi17FSkAoWAVWJrqvdbCA2J1D4xr+TUPe0Mkqc+T6XESTBLyAqcXjhdrBNzALqEpPmLWKG
	uFNJYnd7JztEXF5i85q3zBCXCUr8mHwP7GQJgU3sEqcW7GeD2CYg8W3yIRZIQMhKbDoANUdS
	4uCKGywTGCVmIVkxC8nYWUjGLmBkXsUomlqQXFCclF5krFecmFtcmpeul5yfu4kRElv9Oxjv
	HrA+xJgMtHIis5Rocj4wNvNK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUo
	vqg0J7X4ECMTB6dUA+PxMlkTMbmlz4403MpYI3/MkW3Z8oMn+XcvKQySdk/2fPehbXpQ6L3T
	Z5+tXcPi8S14w9pNHy/22Ewwv/ZHI7LpokdLihqf6DVXhpkT1XK3TKg/dudehmvQtA6epZO3
	1HEUH1k/n+lgzpFllw6ECrMWbstkL70d8LV75s0Niko7Wr/35zApbl6nxFKckWioxVxUnAgA
	eQ2UsMMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgG6ooF+wweejghaXFrlb7Nl7ksXi
	8q45bA7MHrsXfGby+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJ
	IS8xN9VWycUnQNctMwdoh5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x
	48+KvYwFzaIVW2d/YWtgnCPYxcjJISFgInHh/DFGCFtM4sK99WxdjFwcQgKLGCXWdb1ggXBe
	MUos3fKDHaSKV0Bbomv2MWYQW1ggWGL6q41ANgcHG1B8834DkLCQgKLE2/13WUHCIkD25fdO
	ICazgIfErmOlIBUsAqoSXVe72UBsTqDwjX8noda2Mkqc+T4X7B5+AVGJwwu3g21iFlCXmDRv
	ETPEnUoSu9s72SHi8hKb17xlhrhMUOLH5HssExiFZiFpmYWkbBaSsgWMzKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxgmP3mfQOxlUNFocYBTgYlXh4Z+b4BguxJpYVV+YeYpTgYFYS4f3y
	BSjEm5JYWZValB9fVJqTWnyIMRnovYnMUqLJ+cC0klcSb2hsYmZkaWRmYWRibk6asJI478FW
	60AhgfTEktTs1NSC1CKYLUwcnFINjI7rVUKD5Zwmvzhw6vHbDTZidwOW2fW8t+D9eSku6uqv
	iMyVVgXhbPEX75zaZbn13kdrt3kveIw2vtNsPsDZV19pXrx45V2m40uEVrz4HjB3digj2/Xi
	S2WvovfbpK89Z1lm4rx/luNcPm3VWNelpXJbpux6+cRl28wZK9UuXPU/+IF/4qq5+rxKLMUZ
	iYZazEXFiQBL+iziIQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o change the patch, which includes this bug fix

>From 0f3b8427b40b9ace829ba0b16336d5cd67589022 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Tue, 15 Apr 2014 16:04:15 +0900
Subject: [PATCH] f2fs: call redirty_page_for_writepage

This patch replace some general codes with redirty_page_for_writepage,
which
can be enabled after consideration on additional procedure like counting
dirty
pages appropriately.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  5 +----
 fs/f2fs/data.c       | 10 +++-------
 fs/f2fs/node.c       |  5 +----
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 890e23d..2902f7d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -174,10 +174,7 @@ no_write:
 	return 0;
 
 redirty_out:
-	dec_page_count(sbi, F2FS_DIRTY_META);
-	wbc->pages_skipped++;
-	account_page_redirty(page);
-	set_page_dirty(page);
+	redirty_page_for_writepage(wbc, page);
 	return AOP_WRITEPAGE_ACTIVATE;
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 45abd60..b5cd6d1 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -798,10 +798,8 @@ static int f2fs_write_data_page(struct page *page,
 	 * this page does not have to be written to disk.
 	 */
 	offset = i_size & (PAGE_CACHE_SIZE - 1);
-	if ((page->index >= end_index + 1) || !offset) {
-		inode_dec_dirty_dents(inode);
+	if ((page->index >= end_index + 1) || !offset)
 		goto out;
-	}
 
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 write:
@@ -810,7 +808,6 @@ write:
 
 	/* Dentry blocks are controlled by checkpoint */
 	if (S_ISDIR(inode->i_mode)) {
-		inode_dec_dirty_dents(inode);
 		err = do_write_data_page(page, &fio);
 		goto done;
 	}
@@ -832,15 +829,14 @@ done:
 
 	clear_cold_data(page);
 out:
+	inode_dec_dirty_dents(inode);
 	unlock_page(page);
 	if (need_balance_fs)
 		f2fs_balance_fs(sbi);
 	return 0;
 
 redirty_out:
-	wbc->pages_skipped++;
-	account_page_redirty(page);
-	set_page_dirty(page);
+	redirty_page_for_writepage(wbc, page);
 	return AOP_WRITEPAGE_ACTIVATE;
 }
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a161e95..f760793 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1227,10 +1227,7 @@ static int f2fs_write_node_page(struct page
*page,
 	return 0;
 
 redirty_out:
-	dec_page_count(sbi, F2FS_DIRTY_NODES);
-	wbc->pages_skipped++;
-	account_page_redirty(page);
-	set_page_dirty(page);
+	redirty_page_for_writepage(wbc, page);
 	return AOP_WRITEPAGE_ACTIVATE;
 }
 
-- 
1.8.4.474.g128a96c


-- 
Jaegeuk Kim
Samsung

