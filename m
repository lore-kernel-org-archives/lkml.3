Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3KSGeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 01:34:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54679 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3KSGeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 01:34:11 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f836d000001b39-09-528b065c7257
Content-transfer-encoding: 8BIT
Message-id: <1384842794.26319.32.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 1/2] f2fs: clean up the do_submit_bio flow
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 19 Nov 2013 15:33:14 +0900
In-reply-to: <001401cee4e8$09cf01b0$1d6d0510$@samsung.com>
References: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com>
 <001401cee4e8$09cf01b0$1d6d0510$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zY90Ytu4gg7Nr1Sz+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZSz+Wl9wVqBi0oZ7
	rA2Ms3i7GDk4JARMJLZsruhi5AQyxSQu3FvP1sXIxSEksIxRYtrEFcwQCROJzzsns0MkFjFK
	dE98ywaS4BUQlPgx+R4LyCBmAXmJI5eyQcLMAuoSk+YtYoaof8UosXDXVHaIel2J4x9msILY
	wgKeEtfXXWUD6WUT0JbYvN8AJCwkoCjxdv9dsBIRASWJX/MXsULMzJSY83oymM0ioCqx9+d9
	MJtTwErix7uJrBC95RLtG6cxgtj8AqIShxduh7pfSWJ3eyfY/RICx9glzh39xQIxSEDi2+RD
	LJCAkJXYdACqXlLi4IobLBMYJWYh+XIWwpezkHy5gJF5FaNoakFyQXFSepGxXnFibnFpXrpe
	cn7uJkZIrPXvYLx7wPoQYzLQxonMUqLJ+cBYzSuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAh
	gfTEktTs1NSC1KL4otKc1OJDjEwcnFINjOopar9P2j3O42Jxu+mR62dRw2axT+GYseSLbf6r
	qvmvyUhNeXep7sjW4Mz/8wNDtrpPDuNgvJJ//xLvu/z7qUXue71786/PiRdXEA9Nm9N+gTG/
	zI7T8nTitPv3kzfe5Z+cOr9QbmFYD8eVKVVT9pufcDPYr76zxjGNac4bzehltlOzhSWOK7EU
	ZyQaajEXFScCAK4nGzjLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd0Ytu4gg79LFC3+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWYs/lpfcFagYtKGe6wNjLN4uxg5OSQETCQ+75zMDmGLSVy4t56ti5GLQ0hg
	EaNE98S3bCAJXgFBiR+T77F0MXJwMAvISxy5lA0SZhZQl5g0bxEzRP0rRomFu6ayQ9TrShz/
	MIMVxBYW8JS4vu4qG0gvm4C2xOb9BiBhIQFFibf774KViAgoSfyav4gVYmamxJzXk8FsFgFV
	ib0/74PZnAJWEj/eTWSF6C2XaN84jRHE5hcQlTi8cDszxP1KErvbO9knMArNQnL1LISrZyG5
	egEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Fh+Jr2DcVWDxSFGAQ5GJR7eCe5dQUKs
	iWXFlbmHGCU4mJVEeCWvAIV4UxIrq1KL8uOLSnNSiw8xJgMdPpFZSjQ5H5hm8kriDY1NzIws
	jcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsa36htT5d2dvpWvzH7v41nzF
	gkMnfvt8+DJhmtNlq98aE6XFP7QVnXMVOPcgd92eaJEPwe2XN/bqLl4++5j698WGf+++Mrnz
	fZfZjRs2378teXGjk9/Sf6MI38HeI5a7uj20/Oa7hN7a2GgS8V74xjJJ5pMrRS7/E9kT3LpJ
	86Vk34NDhhuiN09TYinOSDTUYi4qTgQARJfawCkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-19 (화), 13:25 +0800, Chao Yu:
> Hi
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Monday, November 18, 2013 5:12 PM
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: [f2fs-dev] [PATCH 1/2] f2fs: clean up the do_submit_bio flow
> > 
> > This patch introduces PAGE_TYPE_OF_BIO() and cleans up do_submit_bio() with it.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/f2fs.h    |  1 +
> >  fs/f2fs/segment.c | 39 +++++++++++++++++++++------------------
> >  2 files changed, 22 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index fe5c2fc..1c783fd 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -351,6 +351,7 @@ enum count_type {
> >   *			with waiting the bio's completion
> >   * ...			Only can be used with META.
> >   */
> > +#define PAGE_TYPE_OF_BIO(type)	(type) > META ? META : (type)


I'll add parenthesis as you suggested. Thanks.

> >  enum page_type {
> >  	DATA,
> >  	NODE,
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 1f83999..dad5f1a 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -837,32 +837,35 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
> >  				enum page_type type, bool sync)
> >  {
> >  	int rw = sync ? WRITE_SYNC : WRITE;
> > -	enum page_type btype = type > META ? META : type;
> > +	enum page_type btype = PAGE_TYPE_OF_BIO(type);
> 
> ->f2fs_submit_bio()
> 	: enum page_type btype = PAGE_TYPE_OF_BIO(type);
> 	->do_submit_bio()
> 		: enum page_type btype = PAGE_TYPE_OF_BIO(type);
> 
> Could we remove PAGE_TYPE_OF_BIO or use f2fs_bug_on to instead
> in do_submit_bio()? because it looks redundant , and also 
> submit_write_page() will not pass the type which is larger than META.

The f2fs_submit_bio(type) calls do_submit_bio(type) in which the type is
able to be META_FLUSH from sync_meta_pages().
So, we need to do this. :)

-- 
Jaegeuk Kim
Samsung

