Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3J2BHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:07:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46390 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756985Ab3J2BHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:07:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f836d000001b39-a9-526f0a390277
Content-transfer-encoding: 8BIT
Message-id: <1383008787.14041.8.camel@kjgkr>
Subject: Re: [f2fs-dev 4/5] f2fs: Key functions to handle inline data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Tue, 29 Oct 2013 10:06:27 +0900
In-reply-to: <CA+v9cxZfy37vzC+s8rDtpM34JLh38BBMocoU74TYRc1gvFSZPw@mail.gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
 <1382716919-23345-5-git-send-email-huajun.li.lee@gmail.com>
 <1382964198.992.121.camel@kjgkr>
 <CA+v9cxZfy37vzC+s8rDtpM34JLh38BBMocoU74TYRc1gvFSZPw@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zfV1Lrvwgg4WP2C1eHtK0OPOsg9Fi
	y5YYi6/9d9gsLi1yt9iz9ySLxeVdc9gsNp38xerA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CL4rJJSc3JLEst0rdL4MpYdnQVU8Fks4q/j/gbGLvUuxg5OSQETCR2nr7LCGGL
	SVy4t56ti5GLQ0hgGaPEvR0vGGGKZpz/ywKRWMQocWzFbyaQBK+AoMSPyfeAEhwczALyEkcu
	ZYOEmQXUJSbNW8QMUf+KUWLJr6dsEPU6Eg+XN4HZwgKuEp3Hj4P1sgloS2zebwASFhJQlHi7
	/y4riC0CNOf1i7msEDP7mCSWHQBbyyKgKvGuYTsLiM0pECxx6nQ31K73jBLrvm5kBknwC4hK
	HF64nRniASWJ3e2d7CBFEgIf2SUOPjvMBjFJQOLb5ENgR0gIyEpsOgBVLylxcMUNlgmMErOQ
	vDkL4c1ZSN5cwMi8ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMkXvt3MN49YH2IMRlo40Rm
	KdHkfGC855XEGxqbGVmYmpgaG5lbmpEmrCTOe/9hUpCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGxg2Mu9O/XTPUs0r5nZHKxbSmyVHHxeKXGd9NL7XW1SvPFujZd18p38RxLpij4u7Zia/N
	rv7h8pn15+qp5Jn7r19Xyb7Dq7Tyz0LrFUxTNypOilwsceHs8ZpLxnwtxaKTJ0lGOIcl7fgu
	W/c5cHa7MdvbDU4sBr4bRF5fKdxlqO9yoSTd1t7cU4mlOCPRUIu5qDgRALC1rqXtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAV1Lrvwgg7bvjBYvD2lanHnWwWix
	ZUuMxdf+O2wWlxa5W+zZe5LF4vKuOWwWm07+YnXg8Ng56y67x+I9L5k85p0M9Ni94DOTR9+W
	VYwenzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gBdo6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWHZ0FVPBZLOK
	v4/4Gxi71LsYOTkkBEwkZpz/ywJhi0lcuLeerYuRi0NIYBGjxLEVv5lAErwCghI/Jt8DKuLg
	YBaQlzhyKRskzCygLjFp3iJmiPpXjBJLfj1lg6jXkXi4vAnMFhZwleg8fhysl01AW2LzfgOQ
	sJCAosTb/XdZQWwRoDmvX8xlhZjZxySx7ADYWhYBVYl3DdvBbuMUCJY4dbobatd7Rol1Xzcy
	gyT4BUQlDi/czgzxgJLE7vZO9gmMQrOQnD0L4exZSM5ewMi8ilE0tSC5oDgpPddQrzgxt7g0
	L10vOT93EyM4GTyT2sG4ssHiEKMAB6MSD+8D5vwgIdbEsuLK3EOMEhzMSiK8+zfnBQnxpiRW
	VqUW5ccXleakFh9iTAa6fCKzlGhyPjBR5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2x
	JDU7NbUgtQhmCxMHp1QDY/OlR8pG9Zej+R75xqguvc51xlY2T/vxIpfv9u5rjKXM1/7r1Q4L
	n9AWeYlzkcDqP7a3a+s4FvzNv3xvtvXxOZ6MwWc6NWPXidpkNpx0OrZMQidsrUXxdOaO/ZcK
	7Nf3Tl2f7rkpW9J/xzE3902GlcGrPzHtcHT7qd65lOOkOp/71vsBRTEnlFiKMxINtZiLihMB
	/Wbm4koDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-29 (화), 01:20 +0800, Huajun Li:
> On Mon, Oct 28, 2013 at 8:43 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> > Hi,
> >
> > 2013-10-26 (토), 00:01 +0800, Huajun Li:
> >> From: Huajun Li <huajun.li@intel.com>
> >>
> >> Functions to implement inline data read/write, and move inline data to
> >> normal data block when file size exceeds inline data limitation.
> >>
> >> Signed-off-by: Huajun Li <huajun.li@intel.com>
> >> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> >> Signed-off-by: Weihong Xu <weihong.xu@intel.com>
> >> ---
> >>  fs/f2fs/Makefile |    2 +-
> >>  fs/f2fs/f2fs.h   |    7 +++
> >>  fs/f2fs/inline.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 152 insertions(+), 1 deletion(-)
> >>  create mode 100644 fs/f2fs/inline.c
> >>
> >
> > [snip]
> >
> >> +static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
> >> +{
> >> +     int err;
> >> +     struct page *ipage;
> >> +     struct dnode_of_data dn;
> >> +     void *src_addr, *dst_addr;
> >> +     struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> >> +
> >
> > Here..  f2fs_lock_op(sbi);
> >
> >> +     ipage = get_node_page(sbi, inode->i_ino);
> >> +     if (IS_ERR(ipage))
> >> +             return PTR_ERR(ipage);
> >> +
> >
> > Need to move f2fs_lock_op prior to get_node_page.
> >
> >> +     /* i_addr[0] is not used for inline data,
> >
> > Coding style.
> >          /*
> >           * ...
> >           */
> >
> >> +      * so reserving new block will not destroy inline data */
> >> +     err = f2fs_reserve_block(inode, &dn, 0);
> >> +     if (err) {
> >> +             f2fs_put_page(ipage, 1);
> >> +             f2fs_unlock_op(sbi);
> >> +             return err;
> >> +     }
> >
> > Need to move this too.
> >
> >> +
> >> +     src_addr = inline_data_addr(ipage);
> >> +     dst_addr = page_address(page);
> >> +     zero_user_segment(page, 0, PAGE_CACHE_SIZE);
> >
> > + space for readability.
> >
> >> +     /* Copy the whole inline data block */
> >> +     memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
> >> +     zero_user_segment(ipage, INLINE_DATA_OFFSET,
> >> +                              INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> >> +     clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
> >> +     set_raw_inline(F2FS_I(inode),
> >> +                     (struct f2fs_inode *)page_address(ipage));
> 
> Thanks for your comments, I will update them according to above comments.
> 
> >
> >    --> sync_inode_page()?
> >
> IMO, we just handle file data, so do we still need call sync_inode_page() ?

I think sync_inode_page() is more suitable, since we need to sync
between i_size, i_blocks and its i_flag, inline_data, at this moment.

> 
> >> +
> >> +     set_page_dirty(ipage);

Need to consider skipping set_page_dirty(ipage).

> >> +     f2fs_put_page(ipage, 1);
> >> +     set_page_dirty(page);
> >
> > Here... f2fs_unlock_op(sbi);
> >
> > Here, we need to consider data consistency.
> > Let's think about the below scenario.
> > 1. inline_data was written.
> > 2. sync_fs is done.
> > 3. additional data were written.
> >   : this triggers f2fs_convert_inline_data(), produces a page, and then
> > unsets the inline flag.
> > 4. checkpoint was done with updated inode page. Note that, checkpoint
> > doesn't guarantee any user data.
> > 5. sudden power-off is occurred.
> >   -> Once power-off-recovery is done, we loose the inline_data which was
> > written successfully at step #2.
> >
> > So, I think we need to do f2fs_sync_file() procedure at this moment.
> > Any idea?
> >
> 
> Yes, need consider this case carefully, thanks for your reminder.
> 
> Considering sudden power-off may happen before f2fs_sync_file() is
> called, so how about following solutions:
>      ...
>      /* Copy the whole inline data block */
>      memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
> 
>     do f2fs_sync_file() procedure ( Or  do write_data_page() procedure ? )

Ya, but it may still have some conditions to do this or not.
One of them is checking whether previous inline data should be recovered
or not, for example.

> 
>      zero_user_segment(ipage, INLINE_DATA_OFFSET, INLINE_DATA_OFFSET +
> MAX_INLINE_DATA);
>      clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
>      set_raw_inline(F2FS_I(inode), (struct f2fs_inode *)page_address(ipage));
>      ...
> 
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +int f2fs_convert_inline_data(struct inode *inode,
> >> +                          struct page *p, unsigned flags)
> >> +{
> >> +     int err;
> >> +     struct page *page;
> >> +
> >> +     if (p && !p->index) {
> >> +             page = p;
> >> +     } else {
> >> +             page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
> >> +             if (IS_ERR(page))
> >> +                     return PTR_ERR(page);
> >> +     }
> >> +
> >> +     err = __f2fs_convert_inline_data(inode, page);
> >> +
> >> +     if (p && !p->index)
> >> +             f2fs_put_page(page, 1);
> >> +
> >> +     return err;
> >> +}
> >> +
> >> +int f2fs_write_inline_data(struct inode *inode,
> >> +                        struct page *page, unsigned size)
> >> +{
> >> +     void *src_addr, *dst_addr;
> >> +     struct page *ipage;
> >> +     struct dnode_of_data dn;
> >> +     int err;
> >> +
> >> +     set_new_dnode(&dn, inode, NULL, NULL, 0);
> >> +     err = get_dnode_of_data(&dn, 0, LOOKUP_NODE);
> >> +     if (err)
> >> +             return err;
> >> +     ipage = dn.inode_page;
> >> +
> >> +     src_addr = page_address(page);
> >> +     dst_addr = inline_data_addr(ipage);
> >> +
> >> +     zero_user_segment(ipage, INLINE_DATA_OFFSET,
> >> +                              INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> >> +     memcpy(dst_addr, src_addr, size);
> >> +     if (!f2fs_has_inline_data(inode))
> >> +             set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
> >> +     set_raw_inline(F2FS_I(inode),
> >> +                     (struct f2fs_inode *)page_address(ipage));
> >> +     set_page_dirty(ipage);
> >> +
> >> +     if ((F2FS_I(inode)->i_xattr_nid && inode->i_blocks == 2) ||
> >> +             (!F2FS_I(inode)->i_xattr_nid && inode->i_blocks == 1)) {
> >> +             f2fs_put_dnode(&dn);
> >> +             return 0;
> >> +     }
> >> +
> >> +     /* Release the first data block if it is allocated */
> >> +     truncate_data_blocks_range(&dn, 1);
> >> +     f2fs_put_dnode(&dn);
> >> +
> >> +     return 0;
> >> +}
> >
> > --
> > Jaegeuk Kim
> > Samsung
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

