Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaAFHnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:43:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36867 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaAFHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:43:14 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fcd6d00000315b-d6-52ca5e8bb50b
Content-transfer-encoding: 8BIT
Message-id: <1388994113.2101.312.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 2/6] f2fs: convert inline_data for punch_hole
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 06 Jan 2014 16:41:53 +0900
In-reply-to: <000001cf05ee$d8bd8c90$8a38a5b0$@samsung.com>
References: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
 <1388116820-15038-2-git-send-email-jaegeuk.kim@samsung.com>
 <000001cf05ee$d8bd8c90$8a38a5b0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zA92euFNBBqcfMVr8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgymg4fpW94BhPxfmV
	CxkbGNu5uhg5OCQETCRWTQrtYuQEMsUkLtxbz9bFyMUhJLCMUWLWpa1sEAkTiaPTvjFBJKYz
	Smyc2cYOkuAVEJT4MfkeC8ggZgF5iSOXskHCzALqEpPmLWKGqH/FKLF191ImiHpdifuHLzGD
	1AsL+EjMuJ4NYrIJaEts3m8AUiEkoCjxdv9dVhBbREBJ4tf8RawQIzMl5ryeDGazCKhKfPww
	Cew0TgEriZNfH7JCrNrKKHH5xXawIn4BUYnDC7czQ9yvJLG7vZMdpEhC4Bi7xLHNL5kgJglI
	fJt8iAUSELISmw5A1UtKHFxxg2UCMAiQfDkL4ctZSL5cwMi8ilE0tSC5oDgpvchQrzgxt7g0
	L10vOT93EyMk2np3MN4+YH2IMRlo40RmKdHkfGC05pXEGxqbGVmYmpgaG5lbmpEmrCTOm/Qw
	KUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo//Fj/pluUmNLS/3X/i1ZWukF0tt5KKcz83B
	HTwqutWN0ZHfspJn9SWe3b14Sd6+pt0uJ3+wOQYW7Po6UYLzg7vC/uB7lVPMFk41sihNCHjZ
	s7EtvzVZ/1kT++rEJyzZdov+rDr6o9dctddmNl/31grPhWbqVT8bZkaoXeCMb//cvrQh6Mkq
	JZbijERDLeai4kQAjlEXkcwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd3uuFNBBru6rS3+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWY0HL/KXnCMp+L8yoWMDYztXF2MnBwSAiYSR6d9Y4KwxSQu3FvP1sXIxSEk
	MJ1RYuPMNnaQBK+AoMSPyfdYuhg5OJgF5CWOXMoGCTMLqEtMmreIGaL+FaPE1t1LmSDqdSXu
	H77EDFIvLOAjMeN6NojJJqAtsXm/AUiFkICixNv9d1lBbBEBJYlf8xexQozMlJjzejKYzSKg
	KvHxwyQ2EJtTwEri5NeHrBCrtjJKXH6xHayIX0BU4vDC7cwQ9ytJ7G7vZJ/AKDQLydWzEK6e
	heTqBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/mZ1A7GlQ0WhxgFOBiVeHg/PD4Z
	JMSaWFZcmXuIUYKDWUmE9zTTqSAh3pTEyqrUovz4otKc1OJDjMlAl09klhJNzgcmmrySeENj
	EzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYOz9eHVSb0l2n8fh6+oZ
	yx6LMRZOOfI28ZuDxJbvX4Ibt6xTW5346RKzeJQ7W6CAldrqoNfJoQ8rRfpV45NPVwp+vfnp
	rXJOKYu5u0e8stCsIkPOiq68mpj8aS3mCRfDFBv5yhYvmSH26wif71PFqFuGW9JuLb+cEpjn
	N9XK3U9n0pHt1/4JKrEUZyQaajEXFScCAKuEV4IqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-12-31 (화), 14:08 +0800, Chao Yu:
> Hi,
> 
> One comment as following.
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Friday, December 27, 2013 12:00 PM
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: [f2fs-dev] [PATCH 2/6] f2fs: convert inline_data for punch_hole
> > 
> > In the punch_hole(), let's convert inline_data all the time for simplicity and
> > to avoid potential deadlock conditions.
> > It is pretty much not a big deal to do this.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> 
> Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> 
> > ---
> >  fs/f2fs/file.c | 22 +++-------------------
> >  1 file changed, 3 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 7ef2d6a..f64a1c8 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -462,25 +462,9 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
> >  	loff_t off_start, off_end;
> >  	int ret = 0;
> > 
> > -	if (f2fs_has_inline_data(inode)) {
> > -		struct page *page;
> > -		unsigned flags = AOP_FLAG_NOFS;
> > -		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
> > -		if (IS_ERR(page))
> > -			return PTR_ERR(page);
> 
> We use following code because grab_cache_page_write_begin only use
> NULL value as its error number.

Right. :)
Applied to the following patch:
f2fs: refactor f2fs_convert_inline_data.

Thanks,

-- 
Jaegeuk Kim
Samsung

