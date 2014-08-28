Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625AbaH1KPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:15:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14610 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934503AbaH1KPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:15:11 -0400
X-AuditID: cbfee691-f79546d0000011a1-0c-53ff011cf320
Date: Thu, 28 Aug 2014 19:13:32 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: reposition unlock_new_inode to prevent
 accessing invalid inode
Message-id: <20140828101332.GB6808@lcm>
References: <009101cfc119$8e7a5a00$ab6f0e00$@samsung.com>
 <20140828014736.GA6808@lcm> <003801cfc29d$a370dad0$ea529070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <003801cfc29d$a370dad0$ea529070$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+Zsa4M4/9gg0dXtCz+N31ks3iyfhaz
	xaVF7haXd81hc2Dx2LSqk81j94LPTB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVseByO0vB
	AfWK57/PMzUwnpDtYuTkkBAwkfjV954RwhaTuHBvPVsXIxeHkMAyRonLm1eywBStmHWGFcQW
	EljEKHGijxOi6CejxOOll9hBEiwCqhIvvh9nA7HZBLQk2k+vBWsWEVCS+DV/EVgzs0CexJcr
	W4BsDg5hgTSJJXP4QExeAXWJtl1qECNbGSX+flgB1sorICjxY/I9FohWLYn1O48zQdjSEo/+
	zgBbyylgJXHhag9YjaiAisSUk9vYIG5exS5xudUH4jQBiW+TD7GA7JIQkJXYdIAZokRS4uCK
	GywTGMVmIdk2C8m2WUi2LWBkXsUomlqQXFCclF5kqlecmFtcmpeul5yfu4kREkkTdzDeP2B9
	iFGAg1GJh3dGwr9gIdbEsuLK3EOMpkBXTGSWEk3OB8ZrXkm8obGZkYWpiamxkbmlmZI4r470
	z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJuMJebsPx1/pdxrySTusnf1H/J0Dqh5Bd/m
	Y0qd4BHC/H7m+eCpZjyPKvcu8zNaHLVo+ommtP9vOu96X38UtNevc5Nz1OoF6x6I/DuZolBZ
	t34j//pPM9oWChWGOMVXNdy96hgiKOSidt3Pib0kS9rEu9Dg9Yf5f8Od7CZbPuTZ3cyccJHX
	QomlOCPRUIu5qDgRAM8fRR+fAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAV0Zxv/BBrduqFn8b/rIZvFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPB5XaWggPqFc9/n2dqYDwh28XIySEhYCKxYtYZVghbTOLCvfVs
	ILaQwCJGiRN9nF2MXED2T0aJx0svsYMkWARUJV58Pw5WxCagJdF+ei0LiC0ioCTxa/4isEHM
	AnkSX65sAbI5OIQF0iSWzOEDMXkF1CXadqlBjGxllPj7YQVYK6+AoMSPyfdYIFq1JNbvPM4E
	YUtLPPo7A2wtp4CVxIWrPWA1ogIqElNObmObwCgwC0n7LCTts5C0L2BkXsUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHKnPpHcwrmqwOMQowMGoxMPrEPcvWIg1say4MvcQowQHs5II77Q/
	QCHelMTKqtSi/Pii0pzU4kOMpsDAmMgsJZqcD0wieSXxhsYmZkaWRmYWRibm5krivAdbrQOF
	BNITS1KzU1MLUotg+pg4OKUaGGPiLuRYNqswH7mWsCL6YtPyFwVpvKkTs2zs5qj1VOeuZmyP
	VmYyeMxQY3rrf+qnlZ9CkuveO0ht0/njue/YK+OHoZOULm49eir4ccj3jJkl6hM1pjzuf9n2
	XeazzJlLIReE9ztP2CYsbNK+9d6NmYV/E0VV/Vj9Z6g5TQm8cSnr4XGDvKK/cUosxRmJhlrM
	RcWJADLfYQrqAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 28, 2014 at 04:53:01PM +0800, Chao Yu wrote:
> Hi Changman,
> 
> > -----Original Message-----
> > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > Sent: Thursday, August 28, 2014 9:48 AM
> > To: Chao Yu
> > Cc: Jaegeuk Kim; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH] f2fs: reposition unlock_new_inode to prevent accessing invalid
> > inode
> > 
> > Hi Chao,
> > 
> > I agree it's correct unlock_new_inode should be located after make_bad_inode.
> > 
> > About this scenario,
> > I think we should check some condition if this could be occured;
> 
> I think this condition is the almost impossible but which can happen theoretically.
> 
> > A inode allocated newly could be victim by gc thread.
> > Then, f2fs_iget called by Thread A have to fail because we handled it as
> > bad_inode in Thread B. However, f2fs_iget could still get inode.
> > How about check it using is_bad_inode() in f2fs_iget.
> 
> Yes, agreed. How about return -EIO when this inode we iget_locked is bad?

Hmm.. It might be better to check return value of f2fs_iget like other f/s.

- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -595,6 +595,8 @@ next_step:
                        inode = f2fs_iget(sb, dni.ino);
                        if (IS_ERR(inode))
                                continue;
+                       else if (is_bad_inode(inode))
+                               continue;


Thanks,
Changman

> 
> Thanks,
> Yu
> 
> > 
> > Thanks,
> > 
> > On Tue, Aug 26, 2014 at 06:35:29PM +0800, Chao Yu wrote:
> > > As the race condition on the inode cache, following scenario can appear:
> > > [Thread a]				[Thread b]
> > > 					->f2fs_mkdir
> > > 					  ->f2fs_add_link
> > > 					    ->__f2fs_add_link
> > > 					      ->init_inode_metadata failed here
> > > ->gc_thread_func
> > >   ->f2fs_gc
> > >     ->do_garbage_collect
> > >       ->gc_data_segment
> > >         ->f2fs_iget
> > >           ->iget_locked
> > >             ->wait_on_inode
> > > 					  ->unlock_new_inode
> > >         ->move_data_page
> > > 					  ->make_bad_inode
> > > 					  ->iput
> > >
> > > When we fail in create/symlink/mkdir/mknod/tmpfile, the new allocated inode
> > > should be set as bad to avoid being accessed by other thread. But in above
> > > scenario, it allows f2fs to access the invalid inode before this inode was set
> > > as bad.
> > > This patch fix the potential problem, and this issue was found by code review.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/namei.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> > > index 6b53ce9..845f1be 100644
> > > --- a/fs/f2fs/namei.c
> > > +++ b/fs/f2fs/namei.c
> > > @@ -134,8 +134,8 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t
> > mode,
> > >  	return 0;
> > >  out:
> > >  	clear_nlink(inode);
> > > -	unlock_new_inode(inode);
> > >  	make_bad_inode(inode);
> > > +	unlock_new_inode(inode);
> > >  	iput(inode);
> > >  	alloc_nid_failed(sbi, ino);
> > >  	return err;
> > > @@ -267,8 +267,8 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
> > >  	return err;
> > >  out:
> > >  	clear_nlink(inode);
> > > -	unlock_new_inode(inode);
> > >  	make_bad_inode(inode);
> > > +	unlock_new_inode(inode);
> > >  	iput(inode);
> > >  	alloc_nid_failed(sbi, inode->i_ino);
> > >  	return err;
> > > @@ -308,8 +308,8 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t
> > mode)
> > >  out_fail:
> > >  	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
> > >  	clear_nlink(inode);
> > > -	unlock_new_inode(inode);
> > >  	make_bad_inode(inode);
> > > +	unlock_new_inode(inode);
> > >  	iput(inode);
> > >  	alloc_nid_failed(sbi, inode->i_ino);
> > >  	return err;
> > > @@ -354,8 +354,8 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
> > >  	return 0;
> > >  out:
> > >  	clear_nlink(inode);
> > > -	unlock_new_inode(inode);
> > >  	make_bad_inode(inode);
> > > +	unlock_new_inode(inode);
> > >  	iput(inode);
> > >  	alloc_nid_failed(sbi, inode->i_ino);
> > >  	return err;
> > > @@ -688,8 +688,8 @@ release_out:
> > >  out:
> > >  	f2fs_unlock_op(sbi);
> > >  	clear_nlink(inode);
> > > -	unlock_new_inode(inode);
> > >  	make_bad_inode(inode);
> > > +	unlock_new_inode(inode);
> > >  	iput(inode);
> > >  	alloc_nid_failed(sbi, inode->i_ino);
> > >  	return err;
> > > --
> > > 2.0.0.421.g786a89d
> > >
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Slashdot TV.
> > > Video for Nerds.  Stuff that matters.
> > > http://tv.slashdot.org/
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
