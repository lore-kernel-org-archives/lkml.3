Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaG3L7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:59:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22170 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaG3L7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:59:04 -0400
X-AuditID: cbfee61b-f79f86d00000144c-a8-53d8de063fe1
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-6-git-send-email-jaegeuk@kernel.org>
 <008201cfab21$e5c57ff0$b1507fd0$@samsung.com>
 <20140729124317.GE84378@jaegeuk-mac02>
In-reply-to: <20140729124317.GE84378@jaegeuk-mac02>
Subject: RE: [f2fs-dev] [PATCH 06/11] f2fs: skip unnecessary data writes during
 fsync
Date: Wed, 30 Jul 2014 19:58:11 +0800
Message-id: <00e501cfabed$a5a5a950$f0f0fbf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgIEH1bJAfGcbVgC+vvtxZs2VudA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQV22ezeCDeZM4LR4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2PizJdMBS0yFSsn
	X2JrYOwX62Lk5JAQMJG4tfk+C4QtJnHh3nq2LkYuDiGB6YwSW0++ZIZwfjBK/Gw9ywpSxSag
	IrG84z8TiC0ioCbRu28KmM0skCkxof8FO4gtJHCFUaKh1aqLkYODU8BYorvLHyQsLBAusXDH
	dzYQm0VAVWLR7l1gi3kFLCUebbzLDGELSvyYfI8FYqSWxPqdx6HGy0tsXvOWGeJQBYkdZ18z
	QsTFJTYeucUCcY6bxMVFz5kmMArNQjJqFpJRs5CMmoWkfQEjyypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4MB/Jr2DcVWDxSFGAQ5GJR7eGf+vBwuxJpYVV+YeYpTgYFYS4e1beyNYiDcl
	sbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2PV2YORb7dXmu/+
	slnrhNjkX1OnqAecMk/h9mLrtBFMMDRX8v3COuHdfD/XfLkJ2hvNPP6J6Jd+47rwV+3xon+H
	5zp05LApma3iCPua8481aLfD4v6TtlWvFRTMH59MD/ozpWa6o09N5rnfrvtMv++dvqjw0K6W
	pVsOvW0XXPC/60L0WbfNd1WVWIozEg21mIuKEwHFWtpXeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, July 29, 2014 8:43 PM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 06/11] f2fs: skip unnecessary data writes during fsync
> 
> On Tue, Jul 29, 2014 at 07:39:45PM +0800, Chao Yu wrote:
> > Hi,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > Sent: Saturday, July 26, 2014 6:47 AM
> > > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > > linux-f2fs-devel@lists.sourceforge.net
> > > Cc: Jaegeuk Kim
> > > Subject: [f2fs-dev] [PATCH 06/11] f2fs: skip unnecessary data writes during fsync
> > >
> > > This patch intends to improve the fsync performance by skipping remaining the
> > > recovery information, only when there is no data that we should recover.
> > >
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> > > ---
> > >  fs/f2fs/file.c | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > >
> > > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > > index 7c652b3..121689a 100644
> > > --- a/fs/f2fs/file.c
> > > +++ b/fs/f2fs/file.c
> > > @@ -133,6 +133,17 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int
> > > datasync)
> > >  		return ret;
> > >  	}
> > >
> > > +	/*
> > > +	 * if there is no written data, don't waste time to write recovery info.
> > > +	 */
> > > +	if (!is_inode_flag_set(fi, FI_APPEND_WRITE) &&
> > > +		!exist_written_data(sbi, inode->i_ino, APPEND_INO)) {
> > > +		if (is_inode_flag_set(fi, FI_UPDATE_WRITE) &&
> > > +			exist_written_data(sbi, inode->i_ino, UPDATE_INO))
> >
> > Should we shift this to is_inode_flag_set(fi, FI_UPDATE_WRITE) ||
> > exist_written_data(sbi, inode->i_ino, UPDATE_INO) ?
> 
> Hehe, I found that and was going to submit new patch. :)
> Small changes are not a big deal, so I'll test and then push them into the tree.
> The for-next tree can be rebased all the time, so if you have any suggestion,
> let me know.

It's OK, I will. :)

Thanks

> 
> Thanks,
> 
> >
> > > +			goto flush_out;
> > > +		goto out;
> > > +	}
> > > +
> > >  	/* guarantee free sections for fsync */
> > >  	f2fs_balance_fs(sbi);
> > >
> > > @@ -188,6 +199,11 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int
> > > datasync)
> > >  		ret = wait_on_node_pages_writeback(sbi, inode->i_ino);
> > >  		if (ret)
> > >  			goto out;
> > > +
> > > +		/* once recovery info is written, don't need to tack this */
> > > +		remove_dirty_inode(sbi, inode->i_ino, APPEND_INO);
> > > +flush_out:
> > > +		remove_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
> > >  		ret = f2fs_issue_flush(F2FS_SB(inode->i_sb));
> > >  	}
> > >  out:
> > > --
> > > 1.8.5.2 (Apple Git-48)
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Want fast and easy access to all the code in your enterprise? Index and
> > > search up to 200,000 lines of code with a free copy of Black Duck
> > > Code Sight - the same software that powers the world's largest code
> > > search on Ohloh, the Black Duck Open Hub! Try it now.
> > > http://p.sf.net/sfu/bds
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

