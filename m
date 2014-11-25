Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaKYWhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:37:00 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44283 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaKYWg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:36:58 -0500
X-AuditID: cbfee691-f79b86d000004a5a-89-54750488dd10
Date: Wed, 26 Nov 2014 07:35:40 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: call flush_dcache_page when the page
 was updated
Message-id: <20141125223540.GB16219@lcm>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
 <20141120060410.GB3117@lcm>
 <20141120064533.GA8860@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20141120084729.GA4740@lcm> <20141123100853.GA6356@schnuecks.de>
 <20141124024646.GB4740@lcm> <20141125190523.GA7715@schnuecks.de>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20141125190523.GA7715@schnuecks.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkRbeDpTTE4Oo5PouTu7axWjxZP4vZ
	4tIid4s9e0+yWFzeNYfNgdVj56y77B6bVnWyeexe8JnJ4/MmuQCWKC6blNSczLLUIn27BK6M
	jittbAX7dSvWz3rB2MB4SKmLkZNDQsBEYv68j8wQtpjEhXvr2boYuTiEBJYySuw/9pYRpujj
	tyYWiMQiRom1344xQjg/GSX+dF9mBaliEVCV6L5/nwnEZhPQkmg/vZYFxBYRUJE4NWUuK0gD
	s0A3o0T7p+dgDcICMRKbD7aB2bwCGhK/Hz2H2r2QSeLbo4vMEAlBiR+T74FNYgaaun7ncSYI
	W1ri0d8Z7CA2p4ChxM77E9lAbFGgbVNObgMbJCGwjV3iy7sZTBDnCUh8m3wIaBAHUEJWYtMB
	qKclJQ6uuMEygVFsFpJ1s5Csm4Vk3QJG5lWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYgdF1
	+t+ziTsY7x+wPsQowMGoxMPbcbY4RIg1say4MvcQoynQFROZpUST84ExnFcSb2hsZmRhamJq
	bGRuaaYkzqsj/TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyNX7cEFCrbv6xk721a3MtVu
	2tc956/4LBcr6zmpur1rAvVSOD7z+S9e4hf7Ue8IazurheQFRX8Flez92+prJqfPlVhss0z3
	tumW9NtqcZb2wac8G8QSn2isFro7b4NnioZVIeMDF62TUTnN6zc+Fdh5xPThGcMqregf2ru8
	zv/JUr3OtCZ2khJLcUaioRZzUXEiADfH97WpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAd12ltIQg82f5S1O7trGavFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPnbPusntsWtXJ5rF7wWcmj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYMzqutLEV7NetWD/rBWMD4yGlLkZODgkBE4mP35pYIGwx
	iQv31rN1MXJxCAksYpRY++0YI4Tzk1HiT/dlVpAqFgFVie7795lAbDYBLYn202vBukUEVCRO
	TZnLCtLALNDNKNH+6TlYg7BAjMTmg21gNq+AhsTvR8+hVixkkvj26CIzREJQ4sfke2CTmIGm
	rt95nAnClpZ49HcGO4jNKWAosfP+RDYQWxRo25ST29gmMArMQtI+C0n7LCTtCxiZVzGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEx+4zqR2MKxssDjEKcDAq8fB2nC0OEWJNLCuuzD3EKMHB
	rCTCK8FQGiLEm5JYWZValB9fVJqTWnyI0RQYHhOZpUST84FpJa8k3tDYxMzI0sjMwsjE3FxJ
	nPfGzdwQIYH0xJLU7NTUgtQimD4mDk6pBkbGTYEVJnWWwUrCT+Z0mc2aLSK6gsn3z2SmAuaJ
	0nkazNk77/xbs833VmTVn9mflpu1SD6w6nI9b3nY1XOn2GTNw9Ir9tSmvw+da9M3cdeaVzHO
	TL111p73G/o4F/2v3hQz1XORww6JqSpdNwX/59ScS9Mq+Vv/jUVk1zkJyytbsuLt/v1TWabE
	UpyRaKjFXFScCAD8XZCQ8wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

Thanks very much for your interest.
It becomes more clear due to your explanation.

Regards,
Changman

On Tue, Nov 25, 2014 at 08:05:23PM +0100, Simon Baatz wrote:
> Hi Changman,
> 
> On Mon, Nov 24, 2014 at 11:46:46AM +0900, Changman Lee wrote:
> > Hi Simon,
> > Thanks for your explanation kindly.
> > 
> > On Sun, Nov 23, 2014 at 11:08:54AM +0100, Simon Baatz wrote:
> > > Hi Changman, Jaegeuk,
> > > 
> > > On Thu, Nov 20, 2014 at 05:47:29PM +0900, Changman Lee wrote:
> > > > On Wed, Nov 19, 2014 at 10:45:33PM -0800, Jaegeuk Kim wrote:
> > > > > On Thu, Nov 20, 2014 at 03:04:10PM +0900, Changman Lee wrote:
> > > > > > Hi Jaegeuk,
> > > > > > 
> > > > > > We should call flush_dcache_page before kunmap because the purpose of the cache flush is to address aliasing problem related to virtual address.
> > > > > 
> > > > > Oh, I just followed zero_user_segments below.
> > > > > 
> > > > > static inline void zero_user_segments(struct page *page,
> > > > > 	unsigned start1, unsigned end1,
> > > > > 	unsigned start2, unsigned end2)
> > > > > {
> > > > > 	void *kaddr = kmap_atomic(page);
> > > > > 
> > > > > 	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
> > > > > 
> > > > > 	if (end1 > start1)
> > > > > 		memset(kaddr + start1, 0, end1 - start1);
> > > > > 
> > > > > 	if (end2 > start2)
> > > > > 		memset(kaddr + start2, 0, end2 - start2);
> > > > > 
> > > > > 	kunmap_atomic(kaddr);
> > > > > 	flush_dcache_page(page);
> > > > > }
> > > > > 
> > > > > Is this a wrong reference? Or, a bug?
> > > > > 
> > > > 
> > > > Well.. Data in cache only have to be flushed until before other users read the data.
> > > > If so, it's not a bug.
> > > > 
> > > 
> > > Yes, it is not a bug, since flush_dcache_page() needs to be able to
> > > deal with non-kmapped pages. However, this may create overhead in
> > > some situations.
> > > 
> > 
> > Previously, I was vague but I thought that it should be different
> > according to vaddr exists or not. So I told jaegeuk that it should
> > be better to change an order between flush_dache_page and kunmap.
> > But actually, it doesn't matter the order between them except
> > the situation you said.
> > Could you explain the situation that makes overhead by flushing after kummap.
> > I can't imagine it by just seeing flush_dcache_page code.
> > 
> 
> I was a not very precise here. Yes, flush_dcache_page() on ARM does
> the same in both situations since it has no idea whether it is called
> before or after kunmap.  However, flush_kernel_dcache_page() can
> assume that it is called before kunmap and thus, for example, does not
> need to pin a highmem page by kmap_high_get() (apart from not having
> to care about flushing user space mappings)
> 
> > > According to documentation (see Documentation/cachetlb.txt), this is
> > > a use for flush_kernel_dcache_page(), since the page has been
> > > modified by the kernel only.  In contrast to flush_dcache_page(),
> > > this function must be called before kunmap().
> > > 
> > > flush_kernel_dcache_page() does not need to flush the user space
> > > aliases.  Additionally, at least on ARM, it does not flush at all
> > > when called within kmap_atomic()/kunmap_atomic(), when
> > > kunmap_atomic() is going to flush the page anyway.  (I know that
> > > almost no one uses flush_kernel_dcache_page() (probably because
> > > almost no one knows when to use which of the two functions), but it
> > > may save a few cache flushes on architectures which are affected by
> > > aliasing)
> > > 
> > > 
> > > > > Anyway I modified as below.
> > > > > 
> > > > > Thanks,
> > > > > 
> > > > > >From 7cb7b27c8cd2efc8a31d79239bef5b41c6e79216 Mon Sep 17 00:00:00 2001
> > > > > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > Date: Tue, 18 Nov 2014 10:50:21 -0800
> > > > > Subject: [PATCH] f2fs: call flush_dcache_page when the page was updated
> > > > > 
> > > > > Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.
> > > > > 
> > > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > > ---
> > > > >  fs/f2fs/dir.c    | 7 ++++++-
> > > > >  fs/f2fs/inline.c | 2 ++
> > > > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > > > > index 5a49995..fabf4ee 100644
> > > > > --- a/fs/f2fs/dir.c
> > > > > +++ b/fs/f2fs/dir.c
> > > > > @@ -287,8 +287,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
> > > > >  	f2fs_wait_on_page_writeback(page, type);
> > > > >  	de->ino = cpu_to_le32(inode->i_ino);
> > > > >  	set_de_type(de, inode);
> > > > > -	if (!f2fs_has_inline_dentry(dir))
> > > > > +	if (!f2fs_has_inline_dentry(dir)) {
> > > > > +		flush_dcache_page(page);
> > > > >  		kunmap(page);
> > > > > +	}
> > > 
> > > Is this a page that may be mapped into user space? (I may be
> > > completely wrong here, since I have no idea how this code works.  But
> > > it looks like as if the answer is "no" ;-) ).
> > > 
> > > It is not necessary to flush pages that cannot be seen by user space
> > > (see also the NOTE in the documentation of flush_dcache_page() in
> > > cachetlb.txt). Thus, if you know that a page will not be mapped into
> > > user space, please don't create the overhead of flushing it.
> > > 
> > 
> > In the case of dentry unlike inline data, this is not mapped to user space, so dcache flush
> > makes overhead. Do you mean that?
> 
> Yes. I suppose most architectures where D-cache aliasing is an issue
> have optimizations that "defer" the actual flush when there are no
> user space mappings.  But nevertheless, if you already now that there
> can't be any aliases, there is no need to call these functions at
> all.
> 
> 
> - Simon 
