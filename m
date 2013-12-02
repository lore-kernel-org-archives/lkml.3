Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3LBIZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:25:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19261 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3LBIZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:25:11 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7f666d0000048b0-70-529c43e6590f
Content-transfer-encoding: 8BIT
Message-id: <1385972652.2417.111.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: refactor bio-related operations
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Mon, 02 Dec 2013 17:24:12 +0900
In-reply-to: <000101ceef19$ae149b50$0a3dd1f0$@samsung.com>
References: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
 <000101ceef19$ae149b50$0a3dd1f0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zA91nznOCDPZMErT43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxoFJfawF
	5wUrDv+awtbA+IS3i5GTQ0LARGL3pEtMELaYxIV769m6GLk4hASWMUqcvHGCpYuRA6yorT0f
	Ir6IUeLNLJAiTg5eAUGJH5PvgdUwC8hLHLmUDRJmFlCXmDRvETNE/StGiT3L7zJC1OtKbPpx
	ngXEFhZwleh59pkdpJdNQFti834DkLCQgKLE2/13WUFsEQEliV/zF7GCzGEWWMgocXDBTbC9
	LAKqEj0Hp4MVcQpYSRy72sIO0VwusftXG1gNv4CoxOGF25khHlOS2N3eyQ4ySELgErvE9t//
	WCEGCUh8m3wI6klZiU0HoOolJQ6uuMEygVFiFpI3ZyG8OQvJmwsYmVcxiqYWJBcUJ6UXmeoV
	J+YWl+al6yXn525ihETexB2M9w9YH2JMBto4kVlKNDkfGLl5JfGGxmZGFqYmpsZG5pZmpAkr
	ifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAoxi/nX/Q/kS91d0fI9vYnEb2u9k4c
	FfOiF1w53fWbPce7UsE0zH7Zb4Uri/jbf04MdVcQYY5hjxX//ES5oOrBkxZWC/0bAawnLjye
	s2f62f9PdvFrq/s8Z6qSe/aQ4aXnh2mrjC9JZMWWZVnaVfe8VXVpjgmK/vPxkkTk1t8ytse+
	ZE9rzVJiKc5INNRiLipOBAA6I3/Z0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd1nznOCDPZ/5LH43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aBSX2sBecFKw7/msLWwPiEt4uRg0NCwESirT2/i5ETyBSTuHBv
	PVsXIxeHkMAiRok3s0AcTg5eAUGJH5PvsYDUMwvISxy5lA0SZhZQl5g0bxEzRP0rRok9y+8y
	QtTrSmz6cZ4FxBYWcJXoefaZHaSXTUBbYvN+A5CwkICixNv9d1lBbBEBJYlf8xexgsxhFljI
	KHFwwU2wvSwCqhI9B6eDFXEKWEkcu9rCDtFcLrH7VxtYDb+AqMThhduZIR5Qktjd3sk+gVFo
	FpKzZyGcPQvJ2QsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMf1M6kdjCsbLA4xCnAw
	KvHwXhSeEyTEmlhWXJl7iFGCg1lJhJfl7+wgId6UxMqq1KL8+KLSnNTiQ4zJQIdPZJYSTc4H
	ppy8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamAsj/gu9s/d
	7Emb1s6UuUtfdcos3Jez4Kdx5iyWpA9Xf51fK2VwvL6692B5Jt9r9qO3JtXIbS3w91iUr+lx
	SnfTmXb3teo+3+1yT9l5FvZFve/+2OLSr/Pg0GRXI7tcFRs/j2sb3mm+3ndyxlUOf6Hm1mt6
	JY3tJksEDi5YMznwxNpNE3UnfVRXYinOSDTUYi4qTgQA110qQC8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-12-02 (월), 12:47 +0800, Chao Yu:
> Hi,
> 
> Some comments as following.
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Saturday, November 30, 2013 2:26 PM
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: [f2fs-dev] [PATCH] f2fs: refactor bio-related operations
> > 
> 
> [snip]
> 
> > +void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
> > +			block_t blk_addr, enum page_type type, int rw)
> > +{
> > +	enum page_type btype = PAGE_TYPE_OF_BIO(type);
> > +	struct block_device *bdev = sbi->sb->s_bdev;
> > +	struct f2fs_bio_info *io;
> > +	int bio_blocks;
> > +
> > +	io = is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
> > +
> > +	verify_block_addr(sbi, blk_addr);
> > +
> > +	mutex_lock(&io->io_mutex);
> > +
> > +	if (!is_read_io(rw))
> > +		inc_page_count(sbi, F2FS_WRITEBACK);
> > +
> > +	if (io->bio && io->last_block_in_bio != blk_addr - 1)
> > +		__submit_merged_bio(sbi, io, type, true, rw);
> > +alloc_new:
> > +	if (io->bio == NULL) {
> > +		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > +		io->bio = __bio_alloc(bdev, bio_blocks);
> > +		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> > +		io->bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io :
> > +							f2fs_write_end_io;
> > +		/*
> > +		 * The end_io will be assigned at the sumbission phase.
> > +		 * Until then, let bio_add_page() merge consecutive IOs as much
> > +		 * as possible.
> > +		 */
> > +	}
> > +
> > +	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
> > +							PAGE_CACHE_SIZE) {
> > +		__submit_merged_bio(sbi, io, type, true, rw);
> > +		io->bio = NULL;
> 
> We should remove the redundant code " io->bio = NULL;" here,
> because __submit_merged_bio does the same job.

Agreed.

> 
> [snip]
> 
> >  /*
> >   * data.c
> >   */
> > +void f2fs_submit_merged_bio(struct f2fs_sb_info *, enum page_type, bool, int);
> > +int f2fs_submit_page_bio(struct f2fs_sb_info *, struct page *, block_t, int);
> 
> Redundant to the following code.

Ah, agreed.
Thank you for the review. :)

-- 
Jaegeuk Kim
Samsung

