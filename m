Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519Ab3GaKHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:07:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33777 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3GaKG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:06:57 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-65-51f8e1bfc767
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1375265195.26443.78.camel@kjgkr>
Subject: Re: [PATCH] f2fs: add a wait step when submit bio with
 {READ,WRITE}_SYNC
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 31 Jul 2013 19:06:35 +0900
In-reply-to: <51F86F67.1070605@cn.fujitsu.com>
References: <51F7901E.3010204@cn.fujitsu.com> <1375187398.26443.69.camel@kjgkr>
 <51F86F67.1070605@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zY939D38EGtx7yWLxvP0As8WlRe4W
	e/aeZLG4vGsOmwOLx/+Dk5g9di/4zOTxeZNcAHMUl01Kak5mWWqRvl0CV8bFs+eZC2boVmxf
	bdTAeFSpi5GTQ0LAROLx62YmCFtM4sK99WxdjFwcQgLLGCX2XdvIDFP0Zeo+RojEIkaJ5xeP
	gXXwCghK/Jh8jwXEZhZQl5g0bxEzhC0iMamtByquLbFs4WuwuJDAa0aJ1gfOXYwcQL26Ep0f
	xEDCwgLBElcn/WQHCbMBlW/ebwBRrSjxdv9dVhBbREBN4tm7S0wgJzALdDNKnF3/ih0kwSKg
	KnHrYxfYKk4BPYmOBV+gVhVL/H53D8zmFxCVOLxwO9QvShK72zvZQQZJCJxil/g84SPUIAGJ
	b5MPsYAcISEgK7HpAFS9pMTBFTdYJjBKzkLy8SwkH89C8vEsJB8vYGRZxSiaWpBcUJyUXmSo
	V5yYW1yal66XnJ+7iRESn707GG8fsD7EmAy0fiKzlGhyPjC+80riDY3NjCxMTUyNjcwtzUgT
	VhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGHN1wuXvjTeP7dmxs6xL88SKLdNl
	MmJCt/CxrFQ/87HAxO6Rv3TR2Qv3Qm3NQrbcYD25vDqvNtb+9K+dLBHn3q4VVjea1JHSeC3a
	/IrB5CfXg72FZoZNC5LeJ/OXQS39wtP3R56tm7m0YPM2Nv/JIV1KPxpakovvf1wXr1+W0xne
	0Gk1a+uRXUosxRmJhlrMRcWJAMANxt3lAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAd39D38EGjzjsXjefoDZ4tIid4s9
	e0+yWFzeNYfNgcXj/8FJzB67F3xm8vi8SS6AOaqB0SYjNTEltUghNS85PyUzL91WyTs43jne
	1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaJmSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+Q
	ILgeIwM0kLCOMWPpSo6CRzoVEycvYmtg7FfqYuTkkBAwkfgydR8jhC0mceHeerYuRi4OIYFF
	jBLPLx5jAknwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5hBbCGB14wSrQ+cQUp4BXQl
	Oj+IgYSFBYIlrk76yQ4SZhPQlti83wCiWlHi7f67rCC2iICaxLN3l5hAtjILdDNKnF3/ih0k
	wSKgKnHrYxcLiM0poCfRseAL1Kpiid/v7oHZ/AKiEocXbmeGOF9JYnd7J/sERqFZSI6ehXD0
	LCRHL2BkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMfPpHYwrmywOMQowMGoxMPrcOF7
	oBBrYllxZe4hRgkOZiURXvmgH4FCvCmJlVWpRfnxRaU5qcWHGJOBDp/ILCWanA9MMXkl8YbG
	JmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwJi+7//t7d0lb3a7Xixc
	xLz++O3arsSLPgfuL/gev8z8esd34Zv26/5m7agsMpuhsnDZZv7fwiVsCySfmzuY5B1z75SI
	Wi0TPu1Pa6hSmtsNpv1pE74+WLnWuKua/YyMR4C9c+uPwy1LPacfSO9iP/7mVvj7ZzXHKlSd
	n9Vs2dn2+EiLiurakg1KLMUZiYZazEXFiQDtmNYHJwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-07-31 (수), 09:59 +0800, Gu Zheng:
> Hi Kim,
> 
> On 07/30/2013 08:29 PM, Jaegeuk Kim wrote:
> 
> > Hi Gu,
> > 
> > The original read flow was to avoid redandunt lock/unlock_page() calls.
> 
> Right, this can gain better read performance. But is the wait step after 
> submitting bio with READ_SYNC needless too?

Correct, the READ_SYNC is also used for IO priority.
The basic read policy here is that the caller should lock the page only
when it wants to manipulate there-in data.
Otherwise, we don't need to unnecessary lock and unlocks.
Thanks,

> 
> > And we should not wait for WRITE_SYNC, since it is just for write
> > priority, not for synchronization of the file system.
> 
> Got it, thanks for your explanation.:) 
> 
> Best regards,
> Gu
> 
> > Thanks,
> > 
> > 2013-07-30 (화), 18:06 +0800, Gu Zheng:
> >> When we submit bio with READ_SYNC or WRITE_SYNC, we need to wait a
> >> moment for the io completion, current codes only find_data_page() follows the
> >> rule, other places missing this step, so add it.
> >>
> >> Further more, moving the PageUptodate check into f2fs_readpage() to clean up
> >> the codes.
> >>
> >> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >> ---
> >>  fs/f2fs/checkpoint.c |    1 -
> >>  fs/f2fs/data.c       |   39 +++++++++++++++++----------------------
> >>  fs/f2fs/node.c       |    1 -
> >>  fs/f2fs/recovery.c   |    2 --
> >>  fs/f2fs/segment.c    |    2 +-
> >>  5 files changed, 18 insertions(+), 27 deletions(-)
> >>
> >> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> >> index fe91773..e376a42 100644
> >> --- a/fs/f2fs/checkpoint.c
> >> +++ b/fs/f2fs/checkpoint.c
> >> @@ -64,7 +64,6 @@ repeat:
> >>  	if (f2fs_readpage(sbi, page, index, READ_SYNC))
> >>  		goto repeat;
> >>  
> >> -	lock_page(page);
> >>  	if (page->mapping != mapping) {
> >>  		f2fs_put_page(page, 1);
> >>  		goto repeat;
> >> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> >> index 19cd7c6..b048936 100644
> >> --- a/fs/f2fs/data.c
> >> +++ b/fs/f2fs/data.c
> >> @@ -216,13 +216,11 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
> >>  
> >>  	err = f2fs_readpage(sbi, page, dn.data_blkaddr,
> >>  					sync ? READ_SYNC : READA);
> >> -	if (sync) {
> >> -		wait_on_page_locked(page);
> >> -		if (!PageUptodate(page)) {
> >> -			f2fs_put_page(page, 0);
> >> -			return ERR_PTR(-EIO);
> >> -		}
> >> -	}
> >> +	if (err)
> >> +		return ERR_PTR(err);
> >> +
> >> +	if (sync)
> >> +		unlock_page(page);
> >>  	return page;
> >>  }
> >>  
> >> @@ -267,11 +265,6 @@ repeat:
> >>  	if (err)
> >>  		return ERR_PTR(err);
> >>  
> >> -	lock_page(page);
> >> -	if (!PageUptodate(page)) {
> >> -		f2fs_put_page(page, 1);
> >> -		return ERR_PTR(-EIO);
> >> -	}
> >>  	if (page->mapping != mapping) {
> >>  		f2fs_put_page(page, 1);
> >>  		goto repeat;
> >> @@ -325,11 +318,7 @@ repeat:
> >>  		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
> >>  		if (err)
> >>  			return ERR_PTR(err);
> >> -		lock_page(page);
> >> -		if (!PageUptodate(page)) {
> >> -			f2fs_put_page(page, 1);
> >> -			return ERR_PTR(-EIO);
> >> -		}
> >> +
> >>  		if (page->mapping != mapping) {
> >>  			f2fs_put_page(page, 1);
> >>  			goto repeat;
> >> @@ -399,6 +388,16 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
> >>  
> >>  	submit_bio(type, bio);
> >>  	up_read(&sbi->bio_sem);
> >> +
> >> +	if (type == READ_SYNC) {
> >> +		wait_on_page_locked(page);
> >> +		lock_page(page);
> >> +		if (!PageUptodate(page)) {
> >> +			f2fs_put_page(page, 1);
> >> +			return -EIO;
> >> +		}
> >> +	}
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> @@ -679,11 +678,7 @@ repeat:
> >>  		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
> >>  		if (err)
> >>  			return err;
> >> -		lock_page(page);
> >> -		if (!PageUptodate(page)) {
> >> -			f2fs_put_page(page, 1);
> >> -			return -EIO;
> >> -		}
> >> +
> >>  		if (page->mapping != mapping) {
> >>  			f2fs_put_page(page, 1);
> >>  			goto repeat;
> >> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> >> index f5172e2..f061554 100644
> >> --- a/fs/f2fs/node.c
> >> +++ b/fs/f2fs/node.c
> >> @@ -1534,7 +1534,6 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >>  		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
> >>  			goto out;
> >>  
> >> -		lock_page(page);
> >>  		rn = F2FS_NODE(page);
> >>  		sum_entry->nid = rn->footer.nid;
> >>  		sum_entry->version = 0;
> >> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> >> index 639eb34..ec68183 100644
> >> --- a/fs/f2fs/recovery.c
> >> +++ b/fs/f2fs/recovery.c
> >> @@ -140,8 +140,6 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
> >>  		if (err)
> >>  			goto out;
> >>  
> >> -		lock_page(page);
> >> -
> >>  		if (cp_ver != cpver_of_node(page))
> >>  			break;
> >>  
> >> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> >> index 9b74ae2..bcd19db 100644
> >> --- a/fs/f2fs/segment.c
> >> +++ b/fs/f2fs/segment.c
> >> @@ -639,7 +639,7 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
> >>  
> >>  		trace_f2fs_do_submit_bio(sbi->sb, btype, sync, sbi->bio[btype]);
> >>  
> >> -		if (type == META_FLUSH) {
> >> +		if ((type == META_FLUSH) || (rw & WRITE_SYNC)) {
> >>  			DECLARE_COMPLETION_ONSTACK(wait);
> >>  			p->is_sync = true;
> >>  			p->wait = &wait;
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

