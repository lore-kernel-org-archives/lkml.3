Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaDPXh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:37:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23335 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964771AbaDPXhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:37:40 -0400
X-AuditID: cbfee68e-b7f566d000002344-5a-534f14428b62
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1397691337.7727.18.camel@kjgkr>
Subject: Re: f2fs: BUG_ON() is triggered when mount valid f2fs filesystem
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Thu, 17 Apr 2014 08:35:37 +0900
In-reply-to: <534E494C.7050909@ispras.ru>
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru>
 <1397559864.7727.5.camel@kjgkr> <534E494C.7050909@ispras.ru>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI10nEf9gg20XdCx2rNvJbnFpkbvF
	5V1z2CyWX45zYPGY8W8qo8fuBZ+ZPD5vkgtgjuKySUnNySxLLdK3S+DK2H9lNVvBd/2Kzv3H
	WRoYX6p1MXJwSAiYSMzpV+5i5AQyxSQu3FvP1sXIxSEksIxR4viNg6wQCROJcy1vGSESixgl
	dn3YxwaS4BUQlPgx+R4LiM0soC4xad4iZghbRGLdpRNMELa2xLKFr5khml8xSlz518QE0awj
	0dt2ixHEFhbwlNg49QoTyEVsQA2b9xuAhIUEFCXe7r8LdoSIgIbE6pk/mUDmMAu0M0qs3L8Y
	LMEioCoxvXER2BGcApoSfx/2M0M0NzFK3L+tCWLzC4hKHF64nRniGyWJ3e2d7CCDJAROsUu0
	nDnEBjFIQOLb5EMskGCRldh0AKpeUuLgihssExglZyH5eRaSn2ch+XkWkp8XMLKsYhRNLUgu
	KE5KLzLSK07MLS7NS9dLzs/dxAiJ0L4djDcPWB9iTAZaP5FZSjQ5HxjheSXxhsZmRhamJqbG
	RuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0Zf7XPWxe77TGcRy1nZm
	BBozlRfMzi2rSOdg2l36+10H+x4epoM+/A6spdum2MgpuRqcmqY88853f522ZompdYcK9Cz3
	6Soyf/COTr63QmSH719Jlk0lmyeGJ2kK3Q6c2yD+bm+1osGr1bWhm4Xn7xIMnKnaWzVv/wpR
	kYdrBV5+airZ9+mKEktxRqKhFnNRcSIA22gByOYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV0nEf9gg7/f1C12rNvJbnFpkbvF
	5V1z2CyWX45zYPGY8W8qo8fuBZ+ZPD5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443
	NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zck
	CK7HyAANJKxjzLgwfy9zwX79iiUb37E0MG5U62Lk5JAQMJE41/KWEcIWk7hwbz1bFyMXh5DA
	IkaJXR/2sYEkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWvGCWu/GtigqjXkeht
	uwU2VFjAU2Lj1CtMIL1sAtoSm/cbgISFBBQl3u6/ywpiiwhoSKye+ZMJZA6zQDujxMr9i8ES
	LAKqEtMbF7GA2JwCmhJ/H/YzQzQ3MUrcv60JYvMLiEocXridGeIBJYnd7Z3sExiFZiE5exbC
	2bOQnL2AkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnA0P5PewbiqweIQowAHoxIPL+dv
	v2Ah1sSy4srcQ4wSHMxKIryZZ4FCvCmJlVWpRfnxRaU5qcWHGJOBDp/ILCWanA9MNHkl8YbG
	JmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMhXkLToWen7A08fX/rx
	+NwNoS6G9R42rPda5r9dpmxWmtV5PjRnwvw62clnFizu2n+Fma1n46wrP4yOvOPQe5gZk1wa
	/kNwl3Zm0PZLoXnHnvc0rBN9aDA3dOvktzJl5V0ZJrauWgfu/PfM/Lsxnv/DuZY95cGCgorc
	Nt7/lmw44WuYc/n6V1YlluKMREMt5qLiRABzFHLLKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-16 (수), 13:11 +0400, Andrey Tsyvarev:
> Hi,
> 
> With this patch mounting of the image continues to fail (with similar 
> BUG_ON).
> But when image is formatted again (and steps mentioned in the previous 
> message are performed),
> mounting of it is now succeed.
> 
> Is this is a true purpose of the patch?

Indeed. The patch solves there-in root cause.
But, if you're trying to use the failed image again, simply you can skip
the errorneous part by:

# mount ... -o disable_roll_forward ...

Once sync or umount whatever checkpoint is done after that, the image
will be mounted without "disable_roll_forward".

Thanks,

> 
> 15.04.2014 15:04, Jaegeuk Kim пишет:
> > Hi,
> >
> > Thank you for the report.
> > I retrieved the fault image and found out that previous garbage data
> > wreak such the wrong behaviors.
> > So, I wrote the following patch that fills one zero-block at the
> > checkpoint procedure.
> > If the underlying device supports discard, I expect that it mostly
> > doesn't incur any performance regression significantly.
> >
> > Could you test this patch?
> >
> > >From 60588ceb7277aae2a79e7f67f5217d1256720d78 Mon Sep 17 00:00:00 2001
> > From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Date: Tue, 15 Apr 2014 13:57:55 +0900
> > Subject: [PATCH] f2fs: avoid to conduct roll-forward due to the remained
> >   garbage blocks
> >
> > The f2fs always scans the next chain of direct node blocks.
> > But some garbage blocks are able to be remained due to no discard
> > support or
> > SSR triggers.
> > This occasionally wreaks recovering wrong inodes that were used or
> > BUG_ONs
> > due to reallocating node ids as follows.
> >
> > When mount this f2fs image:
> > http://linuxtesting.org/downloads/f2fs_fault_image.zip
> > BUG_ON is triggered in f2fs driver (messages below are generated on
> > kernel 3.13.2; for other kernels output is similar):
> >
> > kernel BUG at fs/f2fs/node.c:215!
> >   Call Trace:
> >   [<ffffffffa032ebad>] recover_inode_page+0x1fd/0x3e0 [f2fs]
> >   [<ffffffff811446e7>] ? __lock_page+0x67/0x70
> >   [<ffffffff81089990>] ? autoremove_wake_function+0x50/0x50
> >   [<ffffffffa0337788>] recover_fsync_data+0x1398/0x15d0 [f2fs]
> >   [<ffffffff812b9e5c>] ? selinux_d_instantiate+0x1c/0x20
> >   [<ffffffff811cb20b>] ? d_instantiate+0x5b/0x80
> >   [<ffffffffa0321044>] f2fs_fill_super+0xb04/0xbf0 [f2fs]
> >   [<ffffffff811b861e>] ? mount_bdev+0x7e/0x210
> >   [<ffffffff811b8769>] mount_bdev+0x1c9/0x210
> >   [<ffffffffa0320540>] ? validate_superblock+0x210/0x210 [f2fs]
> >   [<ffffffffa031cf8d>] f2fs_mount+0x1d/0x30 [f2fs]
> >   [<ffffffff811b9497>] mount_fs+0x47/0x1c0
> >   [<ffffffff81166e00>] ? __alloc_percpu+0x10/0x20
> >   [<ffffffff811d4032>] vfs_kern_mount+0x72/0x110
> >   [<ffffffff811d6763>] do_mount+0x493/0x910
> >   [<ffffffff811615cb>] ? strndup_user+0x5b/0x80
> >   [<ffffffff811d6c70>] SyS_mount+0x90/0xe0
> >   [<ffffffff8166f8d9>] system_call_fastpath+0x16/0x1b
> >
> > Found by Linux File System Verification project (linuxtesting.org).
> >
> > Reported-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >   fs/f2fs/checkpoint.c |  6 ++++++
> >   fs/f2fs/f2fs.h       |  1 +
> >   fs/f2fs/segment.c    | 17 +++++++++++++++--
> >   3 files changed, 22 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 4aa521a..890e23d 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -762,6 +762,12 @@ static void do_checkpoint(struct f2fs_sb_info *sbi,
> > bool is_umount)
> >   	void *kaddr;
> >   	int i;
> >   
> > +	/*
> > +	 * This avoids to conduct wrong roll-forward operations and uses
> > +	 * metapages, so should be called prior to sync_meta_pages below.
> > +	 */
> > +	discard_next_dnode(sbi);
> > +
> >   	/* Flush all the NAT/SIT pages */
> >   	while (get_pages(sbi, F2FS_DIRTY_META))
> >   		sync_meta_pages(sbi, META, LONG_MAX);
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 2ecac83..2c5a5da 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -1179,6 +1179,7 @@ int f2fs_issue_flush(struct f2fs_sb_info *);
> >   void invalidate_blocks(struct f2fs_sb_info *, block_t);
> >   void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
> >   void clear_prefree_segments(struct f2fs_sb_info *);
> > +void discard_next_dnode(struct f2fs_sb_info *);
> >   int npages_for_summary_flush(struct f2fs_sb_info *);
> >   void allocate_new_segments(struct f2fs_sb_info *);
> >   struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 1e264e7..9993f94 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -335,13 +335,26 @@ static void locate_dirty_segment(struct
> > f2fs_sb_info *sbi, unsigned int segno)
> >   	mutex_unlock(&dirty_i->seglist_lock);
> >   }
> >   
> > -static void f2fs_issue_discard(struct f2fs_sb_info *sbi,
> > +static int f2fs_issue_discard(struct f2fs_sb_info *sbi,
> >   				block_t blkstart, block_t blklen)
> >   {
> >   	sector_t start = SECTOR_FROM_BLOCK(sbi, blkstart);
> >   	sector_t len = SECTOR_FROM_BLOCK(sbi, blklen);
> > -	blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
> >   	trace_f2fs_issue_discard(sbi->sb, blkstart, blklen);
> > +	return blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
> > +}
> > +
> > +void discard_next_dnode(struct f2fs_sb_info *sbi)
> > +{
> > +	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
> > +	block_t blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
> > +
> > +	if (f2fs_issue_discard(sbi, blkaddr, 1)) {
> > +		struct page *page = grab_meta_page(sbi, blkaddr);
> > +		/* zero-filled page */
> > +		set_page_dirty(page);
> > +		f2fs_put_page(page, 1);
> > +	}
> >   }
> >   
> >   static void add_discard_addrs(struct f2fs_sb_info *sbi,
> 

-- 
Jaegeuk Kim
Samsung

