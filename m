Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3KYLCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:02:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57332 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3KYLCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:02:30 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f126d00000418c-13-52932e459fcf
Content-transfer-encoding: 8BIT
Message-id: <1385377295.26319.157.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH V2 4/6] f2fs: Key functions to handle inline data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Mon, 25 Nov 2013 20:01:35 +0900
In-reply-to: <CA+v9cxZTJrcYZVoqNcopU3sWwMn2zvde89YfMW=2pK=W1DJYtw@mail.gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
 <1384096401-25169-5-git-send-email-huajun.li.lee@gmail.com>
 <1384501749.14041.107.camel@kjgkr>
 <CA+v9cxZTJrcYZVoqNcopU3sWwMn2zvde89YfMW=2pK=W1DJYtw@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zA11XvclBBr3PWC1eHtK0OPOsg9Fi
	y5YYi6/9d9gsLi1yt9iz9ySLxeVdc9gsNp38xerA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mo4el6l4K56xaIpX9gaGBfIdjFyckgImEjcOb+BEcIW
	k7hwbz1bFyMXh5DAMkaJFf9msHQxcoAV9d6vg4hPZ5Q42bSeGaSBV0BQ4sfke2A1zALyEkcu
	ZYOEmQXUJSbNW8QMUf+KUWL91z2sEPV6Ep1nHzCB2MIC/hLfrr1nA+llE9CW2LzfACQsJKAo
	8Xb/XbByEaA5r1/MZYWY2ccksewAWCuLgKrEmZ8zweKcAsESM56fYYLY9ZFRomPXVxaQBL+A
	qMThhduZIR5Tktjd3skOUiQh8JVdonXbeqhJAhLfJh+CelJWYtMBqHpJiYMrbrBMYJSYheTN
	WQhvzkLy5gJG5lWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYIdE6YQfjvQPWhxiTgTZOZJYS
	Tc4HRnteSbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTDmX7+5TdzpxMm7bOY73TrLTjC7PZ6+LjO8W/iA2GWOm1p5qfksRmFyb/Z3T69wjeXduu/f
	jZDmM2a9v1a/u7dx+foN/L8/X/F0vvb8v9zzfnf9m2e2rsrV+NJjJ23Rnj/BR2epsXFc5JHi
	AJ58xwsL6q/Pe5XowCZY5Duv6tjtNWcMzgjI1igosRRnJBpqMRcVJwIAUw4JVOwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV1XvclBBktlLF4e0rQ486yD0WLL
	lhiLr/132CwuLXK32LP3JIvF5V1z2Cw2nfzF6sDhsXPWXXaPxXteMnnMOxnosXvBZyaPvi2r
	GD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx9LxKwV31ikVT
	vrA1MC6Q7WLk4JAQMJHovV/XxcgJZIpJXLi3nq2LkYtDSGA6o8TJpvXMIAleAUGJH5PvsYDU
	MwvISxy5lA0SZhZQl5g0bxEzRP0rRon1X/ewQtTrSXSefcAEYgsL+Et8u/aeDaSXTUBbYvN+
	A5CwkICixNv9d8HKRYDmvH4xlxViZh+TxLIDYK0sAqoSZ37OBItzCgRLzHh+hgli10dGiY5d
	X1lAEvwCohKHF25nhnhASWJ3eyf7BEahWUjOnoVw9iwkZy9gZF7FKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJEZwInknvYFzVYHGIUYCDUYmHd2L1pCAh1sSy4srcQ4wSHMxKIrz5KpODhHhT
	EiurUovy44tKc1KLDzEmA10+kVlKNDkfmKTySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoFRaGXbmpkz3vLJM2y33Vcxgemm48XfNlM2qsqW1v6vL5zEW/Ap
	72PBgx+SJrJSchYfat5vndg1cfI+91LWyMTsCY39JWtn9U99drvA5PX6ihiz58wdKo7FBs23
	r5o+efv44rnCd6Fz1siHrjumesTsSJDlvFVPuZY/U9l97ShjQqzMq6UucXoySizFGYmGWsxF
	xYkAy7LfUUgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huajun,

2013-11-20 (수), 20:51 +0800, Huajun Li:
> On Fri, Nov 15, 2013 at 3:49 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> > Hi Huajun,
> >
> > [snip]
> >
> >> +static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
> >> +{
> >> +     int err;
> >> +     struct page *ipage;
> >> +     struct dnode_of_data dn;
> >> +     void *src_addr, *dst_addr;
> >> +     block_t old_blk_addr, new_blk_addr;
> >> +     struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> >> +
> >> +     f2fs_lock_op(sbi);
> >> +     ipage = get_node_page(sbi, inode->i_ino);
> >> +     if (IS_ERR(ipage))
> >> +             return PTR_ERR(ipage);
> >> +
> >> +     /*
> >> +      * i_addr[0] is not used for inline data,
> >> +      * so reserving new block will not destroy inline data
> >> +      */
> >> +     set_new_dnode(&dn, inode, ipage, ipage, 0);
> >> +     err = f2fs_reserve_block(&dn, 0);
> >> +     if (err) {
> >> +             f2fs_put_page(ipage, 1);
> >> +             f2fs_unlock_op(sbi);
> >> +             return err;
> >> +     }
> >> +
> >> +     src_addr = inline_data_addr(ipage);
> >> +     dst_addr = page_address(page);
> >> +     zero_user_segment(page, 0, PAGE_CACHE_SIZE);
> >> +
> >> +     /* Copy the whole inline data block */
> >> +     memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
> >> +
> >> +     /* write data page to try to make data consistent */
> >> +     old_blk_addr = dn.data_blkaddr;
> >> +     set_page_writeback(page);
> >> +     write_data_page(inode, page, &dn,
> >> +                     old_blk_addr, &new_blk_addr);
> >> +     update_extent_cache(new_blk_addr, &dn);
> >> +     f2fs_wait_on_page_writeback(page, DATA, true);
> >> +
> >> +     /* clear inline data and flag after data writeback */
> >> +     zero_user_segment(ipage, INLINE_DATA_OFFSET,
> >> +                              INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> >> +     clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
> >> +
> >> +     sync_inode_page(&dn);
> >> +     f2fs_put_page(ipage, 1);
> >
> > Again, it seems that you missed what I mentioned.
> > If we write the inlined data block only, we cannot recover the data
> > block after SPO.
> > In order to avoid that, we should write its dnode block too by
> > triggering sync_node_pages(ino) at this point as similar as fsync
> > routine.
> >
> > Thanks,
> >
> > --
> > Jaegeuk Kim
> > Samsung
> >
> 
> Hi Jaegeuk,
> Previously, I refactored f2fs_sync_file() and tried to call it while
> converting inline data, but find it is easily dead lock, so just write
> data block here.
> Then, how about following enhancement to this patch ?  it only copies
> some codes to the end of  __f2fs_convert_inline_data(),  and keeps
> others same as before.

Sorry for the late response.
It takes some time for me to verify the consistency problem in more
detail.

What I've concerned was the following issues:
 - inlined data was synced before or not,
 - inlined data was fsynced before or not,
 - its parent directory inode was synced before or not,
 - recovery can be safe?
 - ...

Most of these issues are based on the question that "can we recover the
inlined data after sudden-power-off safely?".

And initially what I concerned was from the following scenario.
 1. user writes 3KB data
 2. sync or fsync
 3. user writes 4KB data
   : remove direct pointers in the inode page,
       and cache a converted data page.
 4. do checkpoint
   : write the inode page only

 ** After power-cut, user expect at least the file should have 3KB data,
but there is no data due to the converted inline data.

Lastly, I found that, it'd be ok if we can cover the following lock
coverages.
  - f2fs_lock_op
  |    - lock_page(inode_page)
  |   |   -- convert_inline_data()
  |   |      1. write_data_page()
  |   |      2. update its inode page()
  |    - unlock_page(inode_page)
  - f2fs_unlock_op

This means that, the step #4 can guarantee that the inode has the direct
pointer of 4KB data.
And when considering other cases, I couldn't find any issues.

So, yes, I concluded that your first approach which writes data pages
only was correct.

However I found that it needs to modify some recovery routine integrated
to your patch, [5/6].

In do_recover_data(inode_page),
 1. get the first file offset of the inode_page,
 2. get its previous written inode page,
 3. diff direct pointers between previous inode page and current inode
page
 4. check previous and current direct pointers

Let's suppose that the previous inode page has inline data and current
inode page is a coverted node page or vice versa.

[direct pointers]    [previous inode page]     [current inode page]
       [0]             abcd (inline data)         xxx (block addr)
or,
       [0]             xxx (block addr)           abcd (inline data)

In this case, f2fs will recover errorneous block addresses, so it needs
to avoid mishandling the direct pointers too.

Thanks,

-- 
Jaegeuk Kim
Samsung

