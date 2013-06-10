Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3FJAkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 20:40:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20360 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3FJAkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 20:40:02 -0400
X-AuditID: cbfee68e-b7f276d000002279-8c-51b5206092cc
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1370824712.22405.18.camel@lcm>
Subject: Re: [f2fs-dev] [PATCH 1/4] f2fs: reorganize the f2fs_setattr()
 function.
From: Changman Lee <cm224.lee@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 10 Jun 2013 09:38:32 +0900
In-reply-to: <1370694303-2738-1-git-send-email-linkinjeon@gmail.com>
References: <1370694303-2738-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA90Eha2BBid75Cyu7/rLZHH97i1m
	i0uL3C327D3JYnF51xw2ix/T6y1+7DrP7MDusXPWXXaP3Qs+M3n0bVnF6PF5k1wASxSXTUpq
	TmZZapG+XQJXxr4d85gLPqhUTD7cy9bA+F6mi5GTQ0LARGLJy0ssELaYxIV769m6GLk4hASW
	MUocWz+DGaZoWctidojEIkaJD3e7WEESvAKCEj8m3wPrZhZQl5g0bxEzhC0i0ff1EhuErS2x
	bOFrsLiQwGtGiY/dehC92hKfFs1m7GLk4BAWCJZoXcAJEmYT0JJoP72WBSQsIqAmMeFZKsha
	ZoGLjBKrP85jBKlhEVCVaHj+kh3E5hRwkXjT9IwdYryzxMbPd9ghblaS2N3eCXazhMApdom9
	0yczQzQLSHybfAhsgYSArMSmA1A/SkocXHGDZQKj+Cwkn81C8tksJJ/NQvLZAkaWVYyiqQXJ
	BcVJ6UVGesWJucWleel6yfm5mxghcdm3g/HmAetDjMlA6ycyS4km5wPjOq8k3tDYzMjC1MTU
	2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjCos9mcllWQMHELenecM
	f/PyyCNfLZ9Z2Yf+1iiuNY7S4fup1crwzEXQ9I3vvNNCb7J+xJzf/qK248mT6tyHXJMm7eUq
	ZwmV32V3ZZorF2/ct4KWr42qt57eWXyS5drHbx2cwQ81xaoYqh7lv5hpe8ZAyeXp+e7veVKV
	UVI39bybHO7tnJFtp8RSnJFoqMVcVJwIAK4xl7jhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd0Eha2BBr9eSVhc3/WXyeL63VvM
	FpcWuVvs2XuSxeLyrjlsFj+m11v82HWe2YHdY+esu+weuxd8ZvLo27KK0ePzJrkAlqgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoAOUFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBlPfp9lL9ijUnH80TmmBsbdMl2MnBwS
	AiYSy1oWs0PYYhIX7q1n62Lk4hASWMQo8eFuFytIgldAUOLH5HssXYwcHMwC8hJHLmWDhJkF
	1CUmzVvEDGILCbxmlPjYrQdRri3xadFsRpByYYFgidYFnCBhNgEtifbTa8GmiAioSUx4lgqy
	iVngIqPE6o/zGEFqWARUJRqevwQ7h1PAReJN0zN2iPHOEhs/34E6U0lid3sn+wRGgVlIjpuF
	cNwsJMctYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcwc+kdzCuarA4xCjAwajEw/vg
	15ZAIdbEsuLK3EOMEhzMSiK8BU1AId6UxMqq1KL8+KLSnNTiQ4zJQMdOZJYSTc4HJpe8knhD
	YxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBcpVpb5HDZRL3cf8HJ
	uVZb32hJR5R+XP5j59Ilek9XCgvHr27Q/yMpbSUh8iFb2b1w3/QvoRqJbBtedh2efSj5etrK
	VP7iKb8jTu5bp95f379yQ/LuF1PeNR9itTR9YvRu8yGm0vMpuXblJz72XJb9qhW9Nn12aUdC
	j+IBds6iK4WlnNP5zsopsRRnJBpqMRcVJwIAraWwOyQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Namjae

If using ACL, whenever i_mode is changed we should update acl_mode which
is written to xattr block, too. And vice versa.
Because update_inode() is called at any reason and anytime, so we should
sync both the moment xattr is written.
We don't hope that only i_mode is written to disk and xattr is not. So
f2fs_setattr is dirty.

And, below code has a bug. When error is occurred, inode->i_mode
shouldn't be changed. Please, check one more time, Namjae.

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index deefd25..29cd449 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -352,10 +352,8 @@ int f2fs_setattr(struct dentry *dentry, struct
iattr *attr)
 
        if (attr->ia_valid & ATTR_MODE) {
                err = f2fs_acl_chmod(inode);
-               if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
-                       inode->i_mode = fi->i_acl_mode;
+               if (err || is_inode_flag_set(fi, FI_ACL_MODE))
                        clear_inode_flag(fi, FI_ACL_MODE);
-               }
        }

Thanks.


On 토, 2013-06-08 at 21:25 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Remove the redundant code from this function and make it aligned with
> usages of latest generic vfs layer function e.g using the setattr_copy()
> instead of using the f2fs specific function.
> 
> Also correct the condition for updating the size of file via
> truncate_setsize().
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> ---
>  fs/f2fs/acl.c  |    5 +----
>  fs/f2fs/file.c |   47 +++++------------------------------------------
>  2 files changed, 6 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> index 44abc2f..2d13f44 100644
> --- a/fs/f2fs/acl.c
> +++ b/fs/f2fs/acl.c
> @@ -17,9 +17,6 @@
>  #include "xattr.h"
>  #include "acl.h"
>  
> -#define get_inode_mode(i)	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ? \
> -					(F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
> -
>  static inline size_t f2fs_acl_size(int count)
>  {
>  	if (count <= 4) {
> @@ -299,7 +296,7 @@ int f2fs_acl_chmod(struct inode *inode)
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	struct posix_acl *acl;
>  	int error;
> -	umode_t mode = get_inode_mode(inode);
> +	umode_t mode = inode->i_mode;
>  
>  	if (!test_opt(sbi, POSIX_ACL))
>  		return 0;
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index deefd25..8dfc1da 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -300,63 +300,26 @@ static int f2fs_getattr(struct vfsmount *mnt,
>  	return 0;
>  }
>  
> -#ifdef CONFIG_F2FS_FS_POSIX_ACL
> -static void __setattr_copy(struct inode *inode, const struct iattr *attr)
> -{
> -	struct f2fs_inode_info *fi = F2FS_I(inode);
> -	unsigned int ia_valid = attr->ia_valid;
> -
> -	if (ia_valid & ATTR_UID)
> -		inode->i_uid = attr->ia_uid;
> -	if (ia_valid & ATTR_GID)
> -		inode->i_gid = attr->ia_gid;
> -	if (ia_valid & ATTR_ATIME)
> -		inode->i_atime = timespec_trunc(attr->ia_atime,
> -						inode->i_sb->s_time_gran);
> -	if (ia_valid & ATTR_MTIME)
> -		inode->i_mtime = timespec_trunc(attr->ia_mtime,
> -						inode->i_sb->s_time_gran);
> -	if (ia_valid & ATTR_CTIME)
> -		inode->i_ctime = timespec_trunc(attr->ia_ctime,
> -						inode->i_sb->s_time_gran);
> -	if (ia_valid & ATTR_MODE) {
> -		umode_t mode = attr->ia_mode;
> -
> -		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -			mode &= ~S_ISGID;
> -		set_acl_inode(fi, mode);
> -	}
> -}
> -#else
> -#define __setattr_copy setattr_copy
> -#endif
> -
>  int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
>  {
>  	struct inode *inode = dentry->d_inode;
> -	struct f2fs_inode_info *fi = F2FS_I(inode);
>  	int err;
>  
>  	err = inode_change_ok(inode, attr);
>  	if (err)
>  		return err;
>  
> -	if ((attr->ia_valid & ATTR_SIZE) &&
> -			attr->ia_size != i_size_read(inode)) {
> -		truncate_setsize(inode, attr->ia_size);
> +	if ((attr->ia_valid & ATTR_SIZE)) {
> +		if (attr->ia_size != i_size_read(inode))
> +			truncate_setsize(inode, attr->ia_size);
>  		f2fs_truncate(inode);
>  		f2fs_balance_fs(F2FS_SB(inode->i_sb));
>  	}
>  
> -	__setattr_copy(inode, attr);
> +	setattr_copy(inode, attr);
>  
> -	if (attr->ia_valid & ATTR_MODE) {
> +	if (attr->ia_valid & ATTR_MODE)
>  		err = f2fs_acl_chmod(inode);
> -		if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
> -			inode->i_mode = fi->i_acl_mode;
> -			clear_inode_flag(fi, FI_ACL_MODE);
> -		}
> -	}
>  
>  	mark_inode_dirty(inode);
>  	return err;


