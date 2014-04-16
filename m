Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaDPX3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:29:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21421 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaDPX3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:29:51 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-a3-534f126d08d2
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix to unlock f2fs_lock at the omitted error case
Date: Thu, 17 Apr 2014 08:27:46 +0900
Message-id: <1397690866-25379-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA91cIf9gg66b2hbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZWx+sJmt4C5nxYer
	Lg2Mb9i7GDk5JARMJG5f3swEYYtJXLi3nq2LkYtDSGAZo8S6fSfgitq+HGCFSCxilGju64Ry
	OpkkftyczdjFyMHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0ngUkISzgIfH83VZmEJtF
	QFXi3Ow5YHFeAXeJOW9amSG2aUtsez4RrFlC4D6bxKvzm9khGgQkvk0+xAKyTEJAVmLTAah6
	SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJAQn7mC8f8D6EGMy0LiJ
	zFKiyfnAEM4riTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBkZVvxlOAvqrdQ/sYJoQOitwre4BqWdxTxqKAubXiQfpXrdyWv1F6e+XhJ/HVcUyHlw8
	fu2pH/fdW0kejc9OCB/foFshzDql7qhqyFel0jcV/IV/DronbJ4bXH5H4PiR7TGJLHOeeu/j
	Y50x2UvyYd/KD582SU/P//vg2IWY2nUsq53MK1XqpMKUWIozEg21mIuKEwG7Q5YaVwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd1cIf9gg7Nf1C2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zY/GAzW8FdzooPV10aGN+wdzFyckgImEi0fTnACmGLSVy4t56ti5GLQ0hg
	EaNEc18nK4TTySTx4+Zsxi5GDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3LCAJYQEP
	iefvtjKD2CwCqhLnZs8Bi/MKuEvMedPKDLFNW2Lb84mMExi5FzAyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIDvBn0jsYVzVYHGIU4GBU4uHl/O0XLMSaWFZcmXuIUYKDWUmEN/MsUIg3
	JbGyKrUoP76oNCe1+BBjMtD2icxSosn5wOjLK4k3NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBA
	emJJanZqakFqEcwWJg5OqQZG3e+sM/PExDh6KtKeLKxYNPuQIHdb9MrDE68sO7Do7PvedW55
	VxaE39Se6FEsqP2MNfbtmo93prDNMMnbdiln26XX79zPrw8SXr9LnKNW+WRO3Kt2hzfbnf5u
	/SNXXfYgwD1RoIL93IwjoQbyL0rf75HwPHP3kLL1BL0eLmuNJLN90/k5Vt35rcRSnJFoqMVc
	VJwIAO5C6TO0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it occurs an error, we should call f2fs_unlock_op.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/inline.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 383db1f..3258c7c 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -81,8 +81,10 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 
 	f2fs_lock_op(sbi);
 	ipage = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(ipage))
-		return PTR_ERR(ipage);
+	if (IS_ERR(ipage)) {
+		err = PTR_ERR(ipage);
+		goto out;
+	}
 
 	/*
 	 * i_addr[0] is not used for inline data,
@@ -90,10 +92,8 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	 */
 	set_new_dnode(&dn, inode, ipage, NULL, 0);
 	err = f2fs_reserve_block(&dn, 0);
-	if (err) {
-		f2fs_unlock_op(sbi);
-		return err;
-	}
+	if (err)
+		goto out;
 
 	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
@@ -118,6 +118,7 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 
 	sync_inode_page(&dn);
 	f2fs_put_dnode(&dn);
+out:
 	f2fs_unlock_op(sbi);
 	return err;
 }
-- 
1.8.4.474.g128a96c

