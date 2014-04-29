Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaD2IEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:04:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53150 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971AbaD2IEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:04:25 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7fcd6d0000026e0-eb-535f5d07f65e
Content-transfer-encoding: 8BIT
Message-id: <1398758534.13268.8.camel@kjgkr>
Subject: RE: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in
 inode page when setattr
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 17:02:14 +0900
In-reply-to: <001901cf6380$43643c80$ca2cb580$@samsung.com>
References: <001801cf6370$e0553040$a0ff90c0$@samsung.com>
 <1398752174.13268.4.camel@kjgkr> <001901cf6380$43643c80$ca2cb580$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zA1322Phgg9YGWYv/TR/ZLC4tcrfY
	s/cki8XlXXPYHFg8di/4zOTRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGS/39DIX3FSseHxb
	voFxjlQXIyeHhICJRMuOA8wQtpjEhXvr2boYuTiEBJYxSpzd+5ENpujDp4MsEInpjBJLll5m
	BUnwCghK/Jh8DyjBwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxglzhztZYao15H4cfwpO4gtLJAi
	cebZB0aQXjYBbYnN+w1AwkICihJv998FGy8ioCTxa/4iVoiZmRL3mmaAjWERUJXYvWQx2G2c
	AlYSr++fY4fY1cUocfzZJ7AifgFRicMLt0N9piSxu70TrEhC4Bi7xJSF71khJglIfJt8COwB
	CQFZiU2wkJCUOLjiBssERolZSN6chfDmLCRvLmBkXsUomlqQXFCclF5kolecmFtcmpeul5yf
	u4kREm8TdjDeO2B9iDEZaONEZinR5HxgvOaVxBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Om3szndYkWvNyZigd9b3uy5O2R1p5899WbTokPN3M+
	dLq/3fXw1N2mvC+f3dcuqIt/s7xYw1Jkz4MrZ2L/rkpQ2LHokO+fRTNm9An28H15vGaRb4NT
	dPB0jY6C93VCqR4Cd87q5evJbQ3QYq8+KqiU6H3G7HjPPbknvC/mPzY6JWt00nbZol1KLMUZ
	iYZazEXFiQA7mHUezQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQV322PhggzuPJCz+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWa83NPLXHBTseLxbfkGxjlSXYycHBICJhIfPh1kgbDFJC7cW8/WxcjFISQw
	nVFiydLLrCAJXgFBiR+T7wEVcXAwC8hLHLmUDRJmFlCXmDRvETNE/StGiTNHe5kh6nUkfhx/
	yg5iCwukSJx59oERpJdNQFti834DkLCQgKLE2/13wcaLCChJ/Jq/iBViZqbEvaYZYGNYBFQl
	di9ZzAZicwpYSby+f44dYlcXo8TxZ5/AivgFRCUOL9zODPGAksTu9k72CYxCs5CcPQvh7FlI
	zl7AyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzian0nvYFzVYHGIUYCDUYmHtyMmLliI
	NbGsuDL3EKMEB7OSCG++VXywEG9KYmVValF+fFFpTmrxIcZkoMsnMkuJJucDE01eSbyhsYmZ
	kaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTDOE+3+0qKv7Nid89CwftNs
	9nXqeppO7T5nF3Z/vps2fa1ZwXv9qPVhD/YXdR1n0/rzw1DJpV727wRu3ZatrjKTV7/5/vvu
	sV3ZTqe3+AeuWcHkK8/E17rDS3iGEy8Dg0dUrvc0/j8bHgtwPDU46tB5IU3V3mH24qTZE851
	GYfVTH27wErf+4sSS3FGoqEWc1FxIgAdyHrAKgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-29 (화), 15:53 +0800, Chao Yu:
> Hi Kim,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Tuesday, April 29, 2014 2:16 PM
> > To: Chao Yu
> > Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in inode page when setattr
> > 
> > Hi,
> > 
> > 2014-04-29 (화), 14:03 +0800, Chao Yu:
> > > Previous we do not truncate inline data in inode page when setattr, so following
> > > case could still read the inline data which has already truncated:
> > >
> > > 1.write inline data
> > > 2.ftruncate size to 0
> > > 3.ftruncate size to max inline data size
> > > 4.read from offset 0
> > >
> > > This patch introduces truncate_inline_data() to fix this problem.
> > >
> > > change log from v1:
> > >  o fix a bug and do not truncate first page data after truncate inline data.
> > > change log from v2:
> > >  o wait to writeback for inode page if it was already submitted.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/f2fs.h   |    1 +
> > >  fs/f2fs/file.c   |    3 +++
> > >  fs/f2fs/inline.c |   19 +++++++++++++++++++
> > >  3 files changed, 23 insertions(+)
> > >
> > > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > > index 2b67679..676a2c6 100644
> > > --- a/fs/f2fs/f2fs.h
> > > +++ b/fs/f2fs/f2fs.h
> > > @@ -1410,5 +1410,6 @@ bool f2fs_may_inline(struct inode *);
> > >  int f2fs_read_inline_data(struct inode *, struct page *);
> > >  int f2fs_convert_inline_data(struct inode *, pgoff_t);
> > >  int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
> > > +void truncate_inline_data(struct inode *, u64);
> > >  int recover_inline_data(struct inode *, struct page *);
> > >  #endif
> > > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > > index b9f4fbf..d97e5c4 100644
> > > --- a/fs/f2fs/file.c
> > > +++ b/fs/f2fs/file.c
> > > @@ -369,6 +369,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
> > >  	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
> > >  	struct page *page;
> > >
> > > +	if (f2fs_has_inline_data(inode))
> > > +		return truncate_inline_data(inode, from);
> > > +
> > >  	if (!offset)
> > >  		return;
> > >
> > > diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> > > index 3258c7c..6a13997 100644
> > > --- a/fs/f2fs/inline.c
> > > +++ b/fs/f2fs/inline.c
> > > @@ -176,6 +176,25 @@ int f2fs_write_inline_data(struct inode *inode,
> > >  	return 0;
> > >  }
> > >
> > > +void truncate_inline_data(struct inode *inode, u64 from)
> > > +{
> > > +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > > +	struct page *ipage;
> > > +
> > > +	if (from >= MAX_INLINE_DATA)
> > > +		return;
> > > +
> > > +	ipage = get_node_page(sbi, inode->i_ino);
> > > +	if (IS_ERR(ipage))
> > > +		return;
> > > +
> > > +	f2fs_wait_on_page_writeback(ipage, NODE);
> > 
> > The get_node_page() triggers,
> >  grab_cache_page_write_begin()
> >   -> wait_for_stable_page()
> >      -> wait_on_page_writeback().
> 
> Oh, it's my mistake for this missing, thanks for the mention.:)
> 
> > 
> > Any bugs in there?
> 
> If we wait in grab_cache_page_write_begin(), maybe we will face long time delay
> or potential deadlock caused by f2fs bio cache. So how about use
> grab_cache_page & f2fs_wait_on_page_writeback to avoid this?

Nice catch. :)
IMO, it'd better merge your v2, and let me investigate all the paths to
avoid that.
Is it okay?

> 
> > 
> > > +	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
> > > +				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> > > +	set_page_dirty(ipage);
> > > +	f2fs_put_page(ipage, 1);
> > > +}
> > > +
> > >  int recover_inline_data(struct inode *inode, struct page *npage)
> > >  {
> > >  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > 
> > --
> > Jaegeuk Kim
> > Samsung
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

