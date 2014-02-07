Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913AbaBGFNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:13:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32182 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBGFNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:13:42 -0500
X-AuditID: cbfee68f-b7f156d00000276c-0a-52f46b850989
Message-id: <1391749933.25542.83.camel@kjgkr>
Subject: Re: [f2fs-dev] f2fs: f2fs unmount hangs if f2fs_init_acl() fails
 during mkdir syscall
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Date: Fri, 07 Feb 2014 14:12:13 +0900
In-reply-to: <1391734185.25542.80.camel@kjgkr>
References: <52F320FC.50803@ispras.ru> <1391666564.25542.78.camel@kjgkr>
 <52F37D67.208@ispras.ru> <1391734185.25542.80.camel@kjgkr>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zY93W7C9BBreviFlcWuRucXnXHDaL
	5ZfjHJg9Zvybyuixe8FnJo/Pm+QCmKO4bFJSczLLUov07RK4Mq41ORTsEapoWq/RwNjE38XI
	ySEhYCLx6+UFJghbTOLCvfVsXYxcHEICyxglbqz4zgRT9L5vGStEYhGjxNzDG1ggnJeMEo9f
	v2ABqeIV0JU4+eEqG4gtLJAgMfXmbaA4BwebgLbE5v0GIGEhAUWJt/vvsoLYIgIaEqtn/gRb
	wCwQKXHv5FtGEJtFQFXi3IwLYCM5BfQkHn6fwQixq5VR4sHJuWAN/AKiEocXbmeGaFaXmDRv
	ETPEpUoSu9s72SHi8hKb17xlhrhNUOLH5HtgR0sI7GKXaF59iAVim4DEt8mHwA6VEJCV2HQA
	ao6kxMEVN1gmMErMQrJiFpKxs5CMXcDIvIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJMr6
	dzDePWB9iDEZaOVEZinR5HxglOaVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBka5+6t23Jnzp0O9JWBt9zW+VTrP+fYXzK6fPVv/ztHVJ+zehK9d
	fOrEsRmPTnVNVjVt5T89MXjL9CMmD/ti/E7Or5LWUI0/7SL/ztE21edX28JPs4skG9m0Zxlf
	vulxcfdspZTUkDO68gu+H2nwPHdxZll/Dbd/QgZLkofIJ9nNL7QubexSuDRFiaU4I9FQi7mo
	OBEAFRARKMgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd3W7C9BBo+nCllcWuRucXnXHDaL
	5ZfjHJg9Zvybyuixe8FnJo/Pm+QCmKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
	LS3MlRTyEnNTbZVcfAJ03TJzgPYoKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJA
	AwnrGDOuNTkU7BGqaFqv0cDYxN/FyMkhIWAi8b5vGSuELSZx4d56ti5GLg4hgUWMEnMPb2CB
	cF4ySjx+/YIFpIpXQFfi5IerbCC2sECCxNSbt4HiHBxsAtoSm/cbgISFBBQl3u6/CzZUREBD
	YvXMn0wgNrNApMS9k28ZQWwWAVWJczMugI3kFNCTePh9BiPErlZGiQcn54I18AuIShxeuJ0Z
	olldYtK8RcwQlypJ7G7vZIeIy0tsXvOWGeI2QYkfk++xTGAUmoWkZRaSsllIyhYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECI7hZ1I7GFc2WBxiFOBgVOLhPbH0c5AQa2JZcWXuIUYJ
	DmYlEV7uhC9BQrwpiZVVqUX58UWlOanFhxiTgd6byCwlmpwPTC95JfGGxiZmRpZGZhZGJubm
	pAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cCYeXmNlOfeh1omMZ969Z4GTU4L+ZNXwVp3
	dkXGqanuy57ZvfliNCPeaaF4k1R0ZJeHadns1bH2H5lbkj+tuyQ4Re3igakND8U3b1q44Oju
	ItVkbnFhxaTsH0csGVWNQjt2TzM7/WcfM2tE19JGjp2egs5/tmnPtngYUxQsvMjr1zfxN2ua
	yyqUWIozEg21mIuKEwEbp/nRJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It turns out that make_bad_inode prior to iput sets i_mode to a regular
file, so that f2fs_evict_inode -> truncate_inode_pages ->
f2fs_invalidate_data_page doesn't decrement dirty_dents.
This patch should resolve the bug.
Thank you :)

----
When a new directory is allocated, if an error is occurred, we should
truncate
preallocated dentry pages too.

This bug was reported by Andrey Tsyvarev after a while as follows.

mkdir()->
 f2fs_add_link()->
  init_inode_metadata()->
    f2fs_init_acl()->
      f2fs_get_acl()->
        f2fs_getxattr()->
          read_all_xattrs() fails.

Also there was a BUG_ON triggered after the fault in
mkdir()->
 f2fs_add_link()->
   init_inode_metadata()->
    remove_inode_page() ->
      f2fs_bug_on(inode->i_blocks != 0 && inode->i_blocks != 1);

But, previous patch wasn't perfect to resolve that bug, so the following
bug
report was also submitted.

kernel BUG at fs/f2fs/inode.c:274!
Call Trace:
 [<ffffffff811fde03>] evict+0xa3/0x1a0
 [<ffffffff811fe615>] iput+0xf5/0x180
 [<ffffffffa01c7f63>] f2fs_mkdir+0xf3/0x150 [f2fs]
 [<ffffffff811f2a77>] vfs_mkdir+0xb7/0x160
 [<ffffffff811f36bf>] SyS_mkdir+0x5f/0xc0
 [<ffffffff81680769>] system_call_fastpath+0x16/0x1b

Finally, this patch resolves all the issues like below.

If an error is occurred after make_empty_dir(),
 1. truncate_inode_pages()
   The make_bad_inode() prior to iput() will change i_mode to S_IFREG,
which
   means that f2fs will not decrement fi->dirty_dents during
f2fs_evict_inode.
   But, by calling it here, we can do that.

 2. truncate_blocks()
   Preallocated dentry pages are trucated here to sync i_blocks.

Reported-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index bfcb4ae..92ce1db 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -372,6 +372,9 @@ static struct page *init_inode_metadata(struct inode
*inode,
 
 put_error:
 	f2fs_put_page(page, 1);
+	/* once the failed inode becomes a bad inode, i_mode is S_IFREG */
+	truncate_inode_pages(&inode->i_data, 0);
+	truncate_blocks(inode, 0);
 error:
 	remove_inode_page(inode);
 	return ERR_PTR(err);
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

