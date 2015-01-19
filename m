Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbbASNHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:07:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14081 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbbASNHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:07:04 -0500
X-AuditID: cbfee68f-f791c6d000004834-28-54bd0176c974
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>
Cc: "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Dmitry Monakhov'" <dmonakhov@openvz.org>,
        "=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?=" <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
 <20150118233334.GB16552@dastard>
In-reply-to: <20150118233334.GB16552@dastard>
Subject: RE: [RFC PATCH] fs: file freeze support
Date: Mon, 19 Jan 2015 22:07:01 +0900
Message-id: <005601d033e8$d0b338a0$7219a9e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIaHX/tiVElMfpe/JaCs3xh3Ky4MgJ33GV2nB/OnFA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsWyRsSkSLeMcW+Iwdl38hZLJ15itnj3ucpi
	y7F7jBYnZnpaLHuwmcViz96TLBaXd81hs2jt+clucf7vcVYHTo9TiyQ8ms4cZfaYdPgzk8f7
	fVfZPPq2rGL0+LxJzmPTk7dMAexRXDYpqTmZZalF+nYJXBn/L19hLDjrVNG/ZTp7A+Mkky5G
	Tg4JAROJH9tWskLYYhIX7q1n62Lk4hASWMoosevqK3aYomWbDzBDJKYzSmzb9IwdwvnLKDGj
	+zlQhoODTUBb4s8WUZAGEQENiWl7jzCD2MwCp5kkzm7iA7GFBGIkdv9cwAJicwroShz6vgus
	RljAQOJIz3mwZSwCqhLzPm8Ci/MKWEp8/foLyhaU+DH5HgvIKmYBHYmvkyIgxstLbF7zlhni
	TgWJHWdfM0KcYCWx7s4dqBNEJPa9eMcIcrKEQCOHxKqFz6B2CUh8m3wIbKaEgKzEpgNQcyQl
	Dq64wTKBUWIWks2zEDbPQrJ5FpINCxhZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIERvfp
	f8/6dzDePWB9iFGAg1GJh3eD754QIdbEsuLK3EOMpkAHTWSWEk3OB6aQvJJ4Q2MzIwtTE1Nj
	I3NLMyVx3oVSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MHLG39q4vUsm8Zhc+0MW4R2P
	o/MOWjQEBojwvzK+f/FS3MSWypzpM9jZbxvs8Gx63vO/luP57+i6iQ9z/p5ZG+SrWWw89/PH
	RsHZCoXiMUye87q2dSulvw9ZELZFdkGVlPqWL2d0lmd3Spo/6vfW/lUWz3HGKXm26qTPAfXO
	pYuTPp0+Pc2MU4mlOCPRUIu5qDgRAI4EhI/pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd0yxr0hBnuvi1osnXiJ2eLd5yqL
	LcfuMVqcmOlpsezBZhaLPXtPslhc3jWHzaK15ye7xfm/x1kdOD1OLZLwaDpzlNlj0uHPTB7v
	911l8+jbsorR4/MmOY9NT94yBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGHM+H/5CmPBWaeK/i3T2RsYJ5l0MXJySAiYSCzbfIAZwhaTuHBvPVsXIxeHkMB0Roltm56x
	Qzh/GSVmdD8HquLgYBPQlvizRRSkQURAQ2La3iNgzcwCp5kkzm7iA7GFBGIkdv9cwAJicwro
	Shz6vgusRljAQOJIz3l2EJtFQFVi3udNYHFeAUuJr19/QdmCEj8m32MBWcUsoCPxdVIExHh5
	ic1r3kLdqSCx4+xrRogTrCTW3bkDdYKIxL4X7xgnMArNQjJpFsKkWUgmzULSsYCRZRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGcOp4Jr2DcVWDxSFGAQ5GJR7eDb57QoRYE8uKK3MPMUpw
	MCuJ8AZ8AQrxpiRWVqUW5ccXleakFh9iNAX6cyKzlGhyPjCt5ZXEGxqbmBlZGpkbWhgZmyuJ
	8yrZt4UICaQnlqRmp6YWpBbB9DFxcEo1MK6waNklpfsvZ0Wuj+QJi7cz1i99P0180rW67KM6
	uzNnX2N0/633Ln5+QGHjlJpTu26sv1+hdPRex/nlHgwXP1atZ3mx/mkX5x+dGSHmoQo7nF2O
	rk+9N+3rxFeKB84FyJ2bcLf+kKyvg5KKiU2UdMmb52vbPhimTJ2S0TFz8j32lEO28yQXbnBQ
	YinOSDTUYi4qTgQAx467MDMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 15, 2015 at 08:36:55PM +0900, Namjae Jeon wrote:
> > We introduce per-file freeze feature for unifying defrag ext4 and xfs
> > as first ingredient. We get the idea courtesy of Dave Chinner
> > (https://lkml.org/lkml/2014/7/14/759)
Hi Dave,
> 
> /me pages the context back in
> 
> > per-file freeze will be used to avoid that file is not modified while
> > userspace is doing the defrag.
> >
> > This patch tries to implement file write freeze functionality.
> > Introduce new inode state, I_WRITE_FREEZED.
> 
> I_WRITE_FROZEN.
Okay.
> 
> > When this state is set, any process which tries to modify the file's address
> > space, either by pagefault mmap writes or using write(2), will block until
> > the this state is cleared. I_WRITE_FREEZED is set by calling FS_IOC_FWFREEZE
> > ioctl and clear by FS_IOC_FWTHAW ioctl.
> >
> > File write freeze functionality, when used in conjunction with
> > inode's immutable flag can be used for creating truly stable file snapshots
> > wherein write freeze will prevent any modification to the file from already
> > open file descriptors and immutable flag will prevent any new modification
> > to the file. One of the intended uses for stable file snapshots would be in
> > the defragmentation applications which defrags single file.
> 
> I don't quite understand why the full filesystem freeze is
> necessary? The thaw occurs immediately after I_WRITE_FREEZED is set,
We started by looking at fs freeze for file freeze implementation,
So got biased for using fs freeze or similar approach.
Thanks for suggesting a better way.

> which means there's nothing that prevent the file from being
> truncated or otherwise modified by fallocate, etc while it is
> frozen....
Right, So, After that, we had also thought of setting immutable
flag of inode. Immutable flag + I_WRITE_FROZEN => truly frozen file.

> 
> AFAICT, fsync will bring the file down to a consistent state and
> we've already got freeze hooks for all inode modification
> operations. We also have IO barriers for truncate operations so that
> we can wait for all outstanding IO to complete, so I would have
> thought this covers all bases for an inode freeze. i.e.:
Right.

> 
> i_mutex -> I_FROZEN -> fsync -> inode_dio_wait
> 
> Should give us a clean inode where there are not ongoing operations
> by the time that inode_dio_wait() completes. All new modification
> operations need to check I_FROZEN in addition to the superblock
> freeze checks...
I checked the routines where checks for I_FROZEN would be required.
Most of them are Ok but do_unlinkat() confuses me a little.
vfs_unlink is called under parent inode's i_mutex, so we cannot sleep
keeping parent's i_mutex held.
i.e while freezing file, all file in directory are blocked by parent
i_mutex. Is it ok to release parnets->mutex before checking for I_FROZEN
or there is some idea?

> 
> > For implementation purpose, initially we tried to keep percpu usage counters
> > inside struct inode just like there is struct sb_writers in super_block.
> > But considering that it will significantly bloat up struct inode when actually
> > the usage of file write freeze will be infrequent, we dropped this idea.
> > Instead we have tried to use already present filesystem freezing infrastructure.
> > Current approach makes it possible for implementing file write freeze without
> > bloating any of struct super_block/inode.
> > In FS_IOC_FWFREEZE, we wait for complete fs to be frozen, set I_WRITE_FREEZED to
> > inode's state and unfreeze the fs.
> >
> > TODO : prevent inode eviction when I_WRITE_FREEZED state is set.
> 
> The app needs to retain a reference to the inode (i.e. open
> file descriptor) for the length of time that the inode is to be
> frozen. That will prevent reclaim of the inode.
> 
> If the app fails to thaw the inode before it drops all references
> to it, then all bets are off - we do not want to give userspace a
> mechanism to pin arbitrarily large amounts of memory....
Okay.

> 
> > TODO : xfstests testcase for file freeze.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/btrfs/inode.c        |  1 +
> >  fs/buffer.c             |  1 +
> >  fs/ext4/inode.c         |  1 +
> >  fs/f2fs/file.c          |  1 +
> >  fs/gfs2/file.c          |  1 +
> >  fs/inode.c              | 19 ++++++++++++++++++
> >  fs/ioctl.c              | 30 +++++++++++++++++++++++++++++
> >  fs/nilfs2/file.c        |  1 +
> >  fs/ocfs2/mmap.c         |  1 +
> >  fs/super.c              | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fs.h      | 13 +++++++++++++
> >  include/uapi/linux/fs.h |  2 ++
> >  mm/filemap.c            |  1 +
> >  13 files changed, 123 insertions(+)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index e687bb0..357c749 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -8262,6 +8262,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	u64 page_start;
> >  	u64 page_end;
> >
> > +	inode_start_write(inode);
> >  	sb_start_pagefault(inode->i_sb);
> 
> Wouldn't it be better to have:
> 
> 	inode_start_pagefault(inode);
> 
> and then have it call sb_start_pagefault() internally?
Right.

> 
> > +void inode_start_write(struct inode *inode)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +
> > +retry:
> > +	spin_lock(&inode->i_lock);
> > +	if (inode->i_state & I_WRITE_FREEZED) {
> > +		DEFINE_WAIT(wait);
> > +
> > +		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
> > +				TASK_UNINTERRUPTIBLE);
> > +		spin_unlock(&inode->i_lock);
> > +		schedule();
> > +		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
> > +		goto retry;
> > +	}
> > +	spin_unlock(&inode->i_lock);
> 
> Please use a while() loop, not goto.
Okay.

> 
> 	spin_lock(&inode->i_lock);
> 	while(inode->i_state & I_WRITE_FROZEN) {
> 		DEFINE_WAIT(wait);
> 
> 		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
> 				TASK_UNINTERRUPTIBLE);
> 		spin_unlock(&inode->i_lock);
> 		schedule();
> 		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
> 		spin_lock(&inode->i_lock);
> 	}
> 	spin_unlock(&inode->i_lock);
> 
> > +
> > +int file_write_freeze(struct inode *inode)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +	int ret = 0;
> > +
> > +	if (!S_ISREG(inode->i_mode))
> > +		return -EINVAL;
> > +
> > +	spin_lock(&inode->i_lock);
> > +
> > +	if (inode->i_state & I_WRITE_FREEZED)
> > +		ret = -EBUSY;
> > +	spin_unlock(&inode->i_lock);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = freeze_super(sb);
> > +	if (ret)
> > +		return ret;
> > +
> > +	spin_lock(&inode->i_lock);
> > +	inode->i_state |= I_WRITE_FREEZED;
> > +	smp_wmb();
> > +	spin_unlock(&inode->i_lock);
> > +
> > +	return thaw_super(sb);
> > +}
> > +EXPORT_SYMBOL(file_write_freeze);
> > +
> > +int file_write_unfreeze(struct inode *inode)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +
> > +	if (!S_ISREG(inode->i_mode))
> > +		return -EINVAL;
> > +
> > +	spin_lock(&inode->i_lock);
> > +
> > +	if (!(inode->i_state & I_WRITE_FREEZED)) {
> > +		spin_unlock(&inode->i_lock);
> > +		return -EINVAL;
> > +	}
> > +
> > +	inode->i_state &= ~I_WRITE_FREEZED;
> > +	smp_wmb();
> > +	wake_up(&sb->s_writers.wait_unfrozen);
> > +	spin_unlock(&inode->i_lock);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(file_write_unfreeze);
> 
> These look terrible racy. Freeze can race with other filesystem
> freeze and thaw operations, so if thaw_super() fails you could have
> frozen the inode but you still get -EINVAL for the ioctl. Or you
> could have multiple applications doing file freeze/thaw, and so an
> unfreeze occurs while a freeze if waiting on a thaw, and so the app
> waiting on a freeze might return with an unfrozen inode, even though
> there were no errors....
True.

> 
> 
> > @@ -2328,6 +2340,7 @@ static inline bool file_start_write_trylock(struct file *file)
> >  {
> >  	if (!S_ISREG(file_inode(file)->i_mode))
> >  		return true;
> > +	inode_start_write(file_inode(file));
> >  	return __sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, false);
> >  }
> 
> This needs "trylock" semantics, not blocking semantics.
Okay.

Thanks for your review!!
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

