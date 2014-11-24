Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaKXCsI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:48:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10088 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaKXCsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:48:04 -0500
X-AuditID: cbfee68d-f79296d000004278-64-54729c614bd6
Date: Mon, 24 Nov 2014 11:46:46 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: call flush_dcache_page when the page
 was updated
Message-id: <20141124024646.GB4740@lcm>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
 <20141120060410.GB3117@lcm>
 <20141120064533.GA8860@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20141120084729.GA4740@lcm> <20141123100853.GA6356@schnuecks.de>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20141123100853.GA6356@schnuecks.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zI93EOUUhBl9fa1mc3LWN1eLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqweO2fdZffYtKqTzWP3gs9MHp83yQWwRHHZpKTmZJalFunbJXBl
	9G7awFRwQqli5vOjrA2Mn6S6GDk5JARMJK5t+M4GYYtJXLi3Hsjm4hASWMYoMeHkIXaYovuP
	FrJAJKYzSjxd2AZV9ZNR4uPCKYwgVSwCqhLb+8+CdbAJaEm0n17LAmKLCKhInJoylxWkgVmg
	m1Gi/dNzVpCEsECMxOaDbWA2r4C6xLYjHewQU+8xSiyYtJMFIiEo8WPyPTCbGWjq+p3HmSBs
	aYlHf2eAbeMUMJR41PIfrEYUaNuUk9vAzpMQ2MQusWT+ZlaI8wQkvk0+BFTEAZSQldh0gBni
	N0mJgytusExgFJuFZN0sJOtmIVm3gJF5FaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIdPXu
	YLx9wPoQowAHoxIP74fWwhAh1sSy4srcQ4ymQFdMZJYSTc4HxnBeSbyhsZmRhamJqbGRuaWZ
	kjivotTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MJazfjqkc+yL4JsHiEOvim1dP5ClU
	rrm/bM7i7+I31y22l8ycHbBdsj88tnlmj9jLiFLx85tuBS6oZtN76F3k8vnamxe3tlkZTUm9
	YO9g3nyl98ELz4Uaa9/5TvFquBwuy8Vw+YnQ9Hjrjh6jU3YBs2sXdpVuEvzGxxB1bV/pjOeq
	zbNCbjX+U2Ipzkg01GIuKk4EACvSdTKpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd3EOUUhBouPqFmc3LWN1eLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqweO2fdZffYtKqTzWP3gs9MHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZvRu2sBUcEKpYubzo6wNjJ+kuhg5OSQETCTuP1rIAmGL
	SVy4t56ti5GLQ0hgOqPE04VtUM5PRomPC6cwglSxCKhKbO8/yw5iswloSbSfXgvWLSKgInFq
	ylxWkAZmgW5GifZPz1lBEsICMRKbD7aB2bwC6hLbjnSwQ0y9xyixYNJOFoiEoMSPyffAbGag
	qet3HmeCsKUlHv2dAbaNU8BQ4lHLf7AaUaBtU05uY5vAKDALSfssJO2zkLQvYGRexSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iREcu8+kdjCubLA4xCjAwajEw+vRURgixJpYVlyZe4hRgoNZ
	SYT37D+gEG9KYmVValF+fFFpTmrxIUZTYHhMZJYSTc4HppW8knhDYxMzI0sjMwsjE3NzJXHe
	GzdzQ4QE0hNLUrNTUwtSi2D6mDg4pRoYQ4ILhdReLfncubihY7nhpqJvBzmmsHE+WXfF/O3S
	m2G9XXnRn8/d+eWS0rtDyK5OqvLkiUu/bt7ctJvHM4fJxSOM0elLrDkL5x97v81HBSruJSic
	Pr1dSjNDVeDefav9efvPvb56RWzyFD4Fk8zc+6uKXsdtuhdd6bfB/nBnxc7ZNebPRZ9bK7EU
	ZyQaajEXFScCAAoknmXzAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,
Thanks for your explanation kindly.

On Sun, Nov 23, 2014 at 11:08:54AM +0100, Simon Baatz wrote:
> Hi Changman, Jaegeuk,
> 
> On Thu, Nov 20, 2014 at 05:47:29PM +0900, Changman Lee wrote:
> > On Wed, Nov 19, 2014 at 10:45:33PM -0800, Jaegeuk Kim wrote:
> > > On Thu, Nov 20, 2014 at 03:04:10PM +0900, Changman Lee wrote:
> > > > Hi Jaegeuk,
> > > > 
> > > > We should call flush_dcache_page before kunmap because the purpose of the cache flush is to address aliasing problem related to virtual address.
> > > 
> > > Oh, I just followed zero_user_segments below.
> > > 
> > > static inline void zero_user_segments(struct page *page,
> > > 	unsigned start1, unsigned end1,
> > > 	unsigned start2, unsigned end2)
> > > {
> > > 	void *kaddr = kmap_atomic(page);
> > > 
> > > 	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
> > > 
> > > 	if (end1 > start1)
> > > 		memset(kaddr + start1, 0, end1 - start1);
> > > 
> > > 	if (end2 > start2)
> > > 		memset(kaddr + start2, 0, end2 - start2);
> > > 
> > > 	kunmap_atomic(kaddr);
> > > 	flush_dcache_page(page);
> > > }
> > > 
> > > Is this a wrong reference? Or, a bug?
> > > 
> > 
> > Well.. Data in cache only have to be flushed until before other users read the data.
> > If so, it's not a bug.
> > 
> 
> Yes, it is not a bug, since flush_dcache_page() needs to be able to
> deal with non-kmapped pages. However, this may create overhead in
> some situations.
> 

Previously, I was vague but I thought that it should be different
according to vaddr exists or not. So I told jaegeuk that it should
be better to change an order between flush_dache_page and kunmap.
But actually, it doesn't matter the order between them except
the situation you said.
Could you explain the situation that makes overhead by flushing after kummap.
I can't imagine it by just seeing flush_dcache_page code.

> According to documentation (see Documentation/cachetlb.txt), this is
> a use for flush_kernel_dcache_page(), since the page has been
> modified by the kernel only.  In contrast to flush_dcache_page(),
> this function must be called before kunmap().
> 
> flush_kernel_dcache_page() does not need to flush the user space
> aliases.  Additionally, at least on ARM, it does not flush at all
> when called within kmap_atomic()/kunmap_atomic(), when
> kunmap_atomic() is going to flush the page anyway.  (I know that
> almost no one uses flush_kernel_dcache_page() (probably because
> almost no one knows when to use which of the two functions), but it
> may save a few cache flushes on architectures which are affected by
> aliasing)
> 
> 
> > > Anyway I modified as below.
> > > 
> > > Thanks,
> > > 
> > > >From 7cb7b27c8cd2efc8a31d79239bef5b41c6e79216 Mon Sep 17 00:00:00 2001
> > > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > > Date: Tue, 18 Nov 2014 10:50:21 -0800
> > > Subject: [PATCH] f2fs: call flush_dcache_page when the page was updated
> > > 
> > > Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.
> > > 
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >  fs/f2fs/dir.c    | 7 ++++++-
> > >  fs/f2fs/inline.c | 2 ++
> > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > > index 5a49995..fabf4ee 100644
> > > --- a/fs/f2fs/dir.c
> > > +++ b/fs/f2fs/dir.c
> > > @@ -287,8 +287,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
> > >  	f2fs_wait_on_page_writeback(page, type);
> > >  	de->ino = cpu_to_le32(inode->i_ino);
> > >  	set_de_type(de, inode);
> > > -	if (!f2fs_has_inline_dentry(dir))
> > > +	if (!f2fs_has_inline_dentry(dir)) {
> > > +		flush_dcache_page(page);
> > >  		kunmap(page);
> > > +	}
> 
> Is this a page that may be mapped into user space? (I may be
> completely wrong here, since I have no idea how this code works.  But
> it looks like as if the answer is "no" ;-) ).
> 
> It is not necessary to flush pages that cannot be seen by user space
> (see also the NOTE in the documentation of flush_dcache_page() in
> cachetlb.txt). Thus, if you know that a page will not be mapped into
> user space, please don't create the overhead of flushing it.
> 

In the case of dentry unlike inline data, this is not mapped to user space, so dcache flush
makes overhead. Do you mean that?

Best regard,
Changman

> 
> - Simon
