Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3FKFt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 01:49:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3FKFty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 01:49:54 -0400
X-AuditID: cbfee68e-b7f276d000002279-70-51b6ba7f188c
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1370929716.14857.8.camel@lcm>
Subject: Re: [f2fs-dev] [PATCH 1/4] f2fs: reorganize the f2fs_setattr()
 function.
From: Changman Lee <cm224.lee@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 11 Jun 2013 14:48:36 +0900
In-reply-to: <CAKYAXd-V9iF0o5nvFyFPgJX0waDLh4c_eNJ7V_o-tbbrtX1JLQ@mail.gmail.com>
References: <1370694303-2738-1-git-send-email-linkinjeon@gmail.com>
 <1370824712.22405.18.camel@lcm>
 <CAKYAXd-V9iF0o5nvFyFPgJX0waDLh4c_eNJ7V_o-tbbrtX1JLQ@mail.gmail.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zA936XdsCDf4csbG4vusvk8X1u7eY
	LS4tcrfYs/cki8XlXXPYLH5Mr7f4ses8swO7x85Zd9k9di/4zOTRt2UVo8fnTXIBLFFcNimp
	OZllqUX6dglcGe0LWpkLbplUnF1s2sB4WaOLkZNDQsBE4sHNL0wQtpjEhXvr2boYuTiEBJYx
	Slz/O4MFpuja6h5WEFtIYBGjxOHVBiA2r4CgxI/J98BqmAXUJSbNW8QMYYtIXN31mhXC1pZY
	tvA1M8TQ14wSHzZeZ4do1pJY8201kM3BISwQLNG6gBMkzAYUbj+9lgUkLCKgJjHhWSpIK7PA
	RUaJ1R/nMYLUsAioStx80gO2lxOoddObRYwQt61hlPizIAviZiWJ3e2d7CDNEgKn2CVWT13B
	BNEsIPFt8iGwBRICshKbDjBD1EtKHFxxg2UCo/gsJK/NQvLaLCSvzULy2gJGllWMoqkFyQXF
	SelFRnrFibnFpXnpesn5uZsYIVHZt4Px5gHrQ4zJQOsnMkuJJucDozqvJN7Q2MzIwtTE1NjI
	3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwBG/Y+XcdmvE9FeGMo66mY
	dRuPduo8dP95+3zL6sKb0pvSZ/1Rj1jd/11Ntyjt7uLZLzcd2KDpohevNS3x6DHm/k3XeVc0
	KOVab5ctK/rUK+23eYZKUIB455bqW7+/yp7mLLnPl5vrbezILckr/0hiEfeGPN2VClJLtBbe
	WbT7zW71u1o/7ogpsRRnJBpqMRcVJwIAXQE2F+ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd36XdsCDS4vNLe4vusvk8X1u7eY
	LS4tcrfYs/cki8XlXXPYLH5Mr7f4ses8swO7x85Zd9k9di/4zOTRt2UVo8fnTXIBLFENjDYZ
	qYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QAcoKZQl5pQC
	hQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNO7bvPVPDEuOLh3Q7GBsa76l2MnBwS
	AiYS11b3sELYYhIX7q1nA7GFBBYxShxebQBi8woISvyYfI+li5GDg1lAXuLIpWyQMLOAusSk
	eYuYuxi5gMpfM0p82HidHaJeS2LNt9XsIPXCAsESrQs4QcJsQOH202vBxogIqElMeJYK0sos
	cJFRYvXHeYwgNSwCqhI3n/SwgNicQK2b3ixihDhnDaPEnwVZEGcqSexu72SfwCgwC8l1sxCu
	m4XkugWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiP4mfQOxlUNFocYBTgYlXh4Exi3
	BQqxJpYVV+YeYpTgYFYS4TXdDhTiTUmsrEotyo8vKs1JLT7EmAx07ERmKdHkfGByySuJNzQ2
	MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRgfdf2f9c4LEvvdPKhY7
	H6b50tO755KX2r1bot0z7HbMWnoyKOa/4rX76w+u2+K6NFFeT+bimkmX0t4YuV/JkOD5e+jf
	lii/yz8f5U0vYAm9JbKMb8cOCSaGjMotMsbzb+72mdlVtq70iHR2WPv+Vz/bQsVWvLG+FZ8a
	p3Iy4MfGg1qXLm6tcVNiKc5INNRiLipOBABW4NLjJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 화, 2013-06-11 at 07:57 +0900, Namjae Jeon wrote:
> 2013/6/10, Changman Lee <cm224.lee@samsung.com>:
> > Hello, Namjae
> Hi. Changman.
> >
> > If using ACL, whenever i_mode is changed we should update acl_mode which
> > is written to xattr block, too. And vice versa.
> > Because update_inode() is called at any reason and anytime, so we should
> > sync both the moment xattr is written.
> > We don't hope that only i_mode is written to disk and xattr is not. So
> > f2fs_setattr is dirty.
> Yes, agreed this could be issue.
> >
> > And, below code has a bug. When error is occurred, inode->i_mode
> > shouldn't be changed. Please, check one more time, Namjae.
> And, below code has a bug. When error is occurred, inode->i_mode
> shouldn't be changed. Please, check one more time, Namjae.
> 
> This was part of the default code, when ‘acl’ is not set for file’
> Then, inode should be updated by these conditions (i.e., it covers the
> ‘chmod’ and ‘setacl’ scenario).
> When ACL is not present on the file and ‘chmod’ is done, then mode is
> changed from this part, as f2fs_get_acl() will fail and cause the
> below code to be executed:
> 
>     if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
>              inode->i_mode = fi->i_acl_mode;
>              clear_inode_flag(fi, FI_ACL_MODE);
>       }
> 
> Now, in order to make it consistent and work on all scenario we need
> to make further change like this in addition to the patch changes.
> setattr_copy(inode, attr);
>         if (attr->ia_valid & ATTR_MODE) {
> +             set_acl_inode(fi, inode->i_mode);
>               err = f2fs_acl_chmod(inode);
>               if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
> 
> Let me know your opinion.
> Thanks.
> 

setattr_copy changes inode->i_mode, this is not our expectation.
So I made redundant __setatt_copy that copy attr->mode to
fi->i_acl_mode.
When acl_mode is reflected in xattr, acl_mode is copied to
inode->i_mode.

Agree?

> >
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index deefd25..29cd449 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -352,10 +352,8 @@ int f2fs_setattr(struct dentry *dentry, struct
> > iattr *attr)
> >
> >         if (attr->ia_valid & ATTR_MODE) {
> >                 err = f2fs_acl_chmod(inode);
> > -               if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
> > -                       inode->i_mode = fi->i_acl_mode;
> > +               if (err || is_inode_flag_set(fi, FI_ACL_MODE))
> >                         clear_inode_flag(fi, FI_ACL_MODE);
> > -               }
> >         }
> >
> > Thanks.
> >
> >
> > On 토, 2013-06-08 at 21:25 +0900, Namjae Jeon wrote:
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> Remove the redundant code from this function and make it aligned with
> >> usages of latest generic vfs layer function e.g using the setattr_copy()
> >> instead of using the f2fs specific function.
> >>
> >> Also correct the condition for updating the size of file via
> >> truncate_setsize().
> >>
> >> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> >> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> >> ---
> >>  fs/f2fs/acl.c  |    5 +----
> >>  fs/f2fs/file.c |   47 +++++------------------------------------------
> >>  2 files changed, 6 insertions(+), 46 deletions(-)
> >>
> >> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> >> index 44abc2f..2d13f44 100644
> >> --- a/fs/f2fs/acl.c
> >> +++ b/fs/f2fs/acl.c
> >> @@ -17,9 +17,6 @@
> >>  #include "xattr.h"
> >>  #include "acl.h"
> >>
> >> -#define get_inode_mode(i)	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ?
> >> \
> >> -					(F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
> >> -
> >>  static inline size_t f2fs_acl_size(int count)
> >>  {
> >>  	if (count <= 4) {
> >> @@ -299,7 +296,7 @@ int f2fs_acl_chmod(struct inode *inode)
> >>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> >>  	struct posix_acl *acl;
> >>  	int error;
> >> -	umode_t mode = get_inode_mode(inode);
> >> +	umode_t mode = inode->i_mode;
> >>
> >>  	if (!test_opt(sbi, POSIX_ACL))
> >>  		return 0;
> >> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> >> index deefd25..8dfc1da 100644
> >> --- a/fs/f2fs/file.c
> >> +++ b/fs/f2fs/file.c
> >> @@ -300,63 +300,26 @@ static int f2fs_getattr(struct vfsmount *mnt,
> >>  	return 0;
> >>  }
> >>
> >> -#ifdef CONFIG_F2FS_FS_POSIX_ACL
> >> -static void __setattr_copy(struct inode *inode, const struct iattr
> >> *attr)
> >> -{
> >> -	struct f2fs_inode_info *fi = F2FS_I(inode);
> >> -	unsigned int ia_valid = attr->ia_valid;
> >> -
> >> -	if (ia_valid & ATTR_UID)
> >> -		inode->i_uid = attr->ia_uid;
> >> -	if (ia_valid & ATTR_GID)
> >> -		inode->i_gid = attr->ia_gid;
> >> -	if (ia_valid & ATTR_ATIME)
> >> -		inode->i_atime = timespec_trunc(attr->ia_atime,
> >> -						inode->i_sb->s_time_gran);
> >> -	if (ia_valid & ATTR_MTIME)
> >> -		inode->i_mtime = timespec_trunc(attr->ia_mtime,
> >> -						inode->i_sb->s_time_gran);
> >> -	if (ia_valid & ATTR_CTIME)
> >> -		inode->i_ctime = timespec_trunc(attr->ia_ctime,
> >> -						inode->i_sb->s_time_gran);
> >> -	if (ia_valid & ATTR_MODE) {
> >> -		umode_t mode = attr->ia_mode;
> >> -
> >> -		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> >> -			mode &= ~S_ISGID;
> >> -		set_acl_inode(fi, mode);
> >> -	}
> >> -}
> >> -#else
> >> -#define __setattr_copy setattr_copy
> >> -#endif
> >> -
> >>  int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
> >>  {
> >>  	struct inode *inode = dentry->d_inode;
> >> -	struct f2fs_inode_info *fi = F2FS_I(inode);
> >>  	int err;
> >>
> >>  	err = inode_change_ok(inode, attr);
> >>  	if (err)
> >>  		return err;
> >>
> >> -	if ((attr->ia_valid & ATTR_SIZE) &&
> >> -			attr->ia_size != i_size_read(inode)) {
> >> -		truncate_setsize(inode, attr->ia_size);
> >> +	if ((attr->ia_valid & ATTR_SIZE)) {
> >> +		if (attr->ia_size != i_size_read(inode))
> >> +			truncate_setsize(inode, attr->ia_size);
> >>  		f2fs_truncate(inode);
> >>  		f2fs_balance_fs(F2FS_SB(inode->i_sb));
> >>  	}
> >>
> >> -	__setattr_copy(inode, attr);
> >> +	setattr_copy(inode, attr);
> >>
> >> -	if (attr->ia_valid & ATTR_MODE) {
> >> +	if (attr->ia_valid & ATTR_MODE)
> >>  		err = f2fs_acl_chmod(inode);
> >> -		if (err || is_inode_flag_set(fi, FI_ACL_MODE)) {
> >> -			inode->i_mode = fi->i_acl_mode;
> >> -			clear_inode_flag(fi, FI_ACL_MODE);
> >> -		}
> >> -	}
> >>
> >>  	mark_inode_dirty(inode);
> >>  	return err;
> >
> >
> >


