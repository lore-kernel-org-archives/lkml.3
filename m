Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3LTJDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:03:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30305 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3LTJDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:03:11 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-cd-52b407cdba11
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1387530123.2101.220.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH v2] f2fs: move all the bio initialization into
 __bio_alloc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        =?UTF-8?Q?=E4=BF=9E=E8=B6=85?= <chao2.yu@samsung.com>
Date: Fri, 20 Dec 2013 18:02:03 +0900
In-reply-to: <52B2BCC7.7060303@cn.fujitsu.com>
References: <52B2BCC7.7060303@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zI92z7FuCDJofqVv8b/rIZvG8/QCz
	xaVF7hZ79p5ksbi8aw6bA6vH/4OTmD12L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	H+63Mxas0Kl41DeZpYHxn1IXIyeHhICJxJsfl9kgbDGJC/fWA9lcHEICyxglnszcwARTtOTU
	HWaIxCJGiac/DzKDJHgFBCV+TL7HAmIzC6hLTJq3iBnCFpFoaTwDZWtLLFv4GswWEnjFKDF5
	lg9Er67E9k0rGUFsYYEoiZdP9rB2MXJwsAHVb95vAFGuKPF2/11WEFtEQE3i2btLTCA3MAsc
	YZR49KKPHSTBIqAq8a5/Ith8TgE9iT13H4DNEQKaf7bTGyTMLyAqcXjhdmaIX5Qkdrd3soPM
	kRC4xC5x/9RzVog5AhLfJh9iAemVEJCV2HQAql5S4uCKGywTGCVnIfl4FpKPZyH5eBaSjxcw
	sqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECIna3h2Mtw9YH2JMBlo/kVlKNDkfGPV5JfGG
	xmZGFqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA4eVXSEjv/
	SXezXq9Kcypvlco0tA90TGGxXPLKuCI5/+vmJ2qul4LY+s3327tc2pTY5jM38LfbCRP1VaGR
	N0L0MnbbyH41Nw+48lXpwuQlYhON4pga4rVlzzgIL6mbel8voeVq/LdjTk/mtxS3pP+ta3/Q
	VuWk3PtfwN37yezoyX82m03eOFOJpTgj0VCLuag4EQCIOqIE8AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jAd2z7FuCDL5dVLL43/SRzeJ5+wFm
	i0uL3C327D3JYnF51xw2B1aP/wcnMXvsXvCZyaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYMx4+9S84oV2x4PRj5gbGeUpdjJwcEgImEktO3WGGsMUk
	Ltxbz9bFyMUhJLCIUeLpz4NgCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RWImQwCtG
	icmzfCDKdSW2b1rJCGILC0RJvHyyhxWklU1AW2LzfgOIckWJt/vvsoLYIgJqEs/eXWICWcss
	cIRR4tGLPnaQBIuAqsS7/olg8zkF9CT23H0ANkcIaP7ZTm+QML+AqMThhduhzleS2N3eyT6B
	UWgWkqNnIRw9C8nRCxiZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/czqR2MKxssDjEK
	cDAq8fA22G4OEmJNLCuuzD3EKMHBrCTCy/EcKMSbklhZlVqUH19UmpNafIgxGejuicxSosn5
	wMSTVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MHbxS2jPX
	/ma8a+Ql9lnMV6M2vSpc99CRf8zPCkTvsFifiln1OnfBneLwZFWh5ccd4iO3LdQtu5k2S2SD
	v8qXnW98HJac/XLgNpeo1sF5m75Fez/2PPWkZ+VumR6JdTP+LvSyqBMKKgpWOC3NV7B+R7kM
	69FzW6v58hpmnhOQqrZ2+WM539VQiaU4I9FQi7moOBEA9EwUYjIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-12-19 (목), 17:30 +0800, Gu Zheng:
> Move all the bio initialization into __bio_alloc, and some minor cleanups are
> also added.
> 
> v2:
>   Use 'is_read' rather than 'rw' as Yu Chao suggested.
>   Remove the needless initialization of bio->bi_private.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/data.c |   92 +++++++++++++++++++++++++------------------------------
>  1 files changed, 42 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 9bdacc6..701e6fc 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -24,20 +24,6 @@
>  #include "segment.h"
>  #include <trace/events/f2fs.h>
>  
> -/*
> - * Low-level block read/write IO operations.
> - */
> -static struct bio *__bio_alloc(struct block_device *bdev, int npages)
> -{
> -	struct bio *bio;
> -
> -	/* No failure on bio allocation */
> -	bio = bio_alloc(GFP_NOIO, npages);
> -	bio->bi_bdev = bdev;
> -	bio->bi_private = NULL;
> -	return bio;
> -}
> -
>  static void f2fs_read_end_io(struct bio *bio, int err)
>  {
>  	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> @@ -93,6 +79,24 @@ static void f2fs_write_end_io(struct bio *bio, int err)
>  	bio_put(bio);
>  }
>  
> +/*
> + * Low-level block read/write IO operations.
> + */
> +static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
> +				int npages, int rw)

					bool is_read)

> +{
> +	struct bio *bio;
> +
> +	/* No failure on bio allocation */
> +	bio = bio_alloc(GFP_NOIO, npages);
> +
> +	bio->bi_bdev = sbi->sb->s_bdev;
> +	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> +	bio->bi_end_io = rw ? f2fs_read_end_io : f2fs_write_end_io;

			  is_read ? ---

> +
> +	return bio;
> +}
> +
>  static void __submit_merged_bio(struct f2fs_bio_info *io)
>  {
>  	struct f2fs_io_info *fio = &io->fio;
> @@ -104,25 +108,26 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
>  	rw = fio->rw | fio->rw_flag;
>  
>  	if (is_read_io(rw)) {
> -		trace_f2fs_submit_read_bio(io->sbi->sb, rw, fio->type, io->bio);
> +		trace_f2fs_submit_read_bio(io->sbi->sb, rw,
> +						fio->type, io->bio);
>  		submit_bio(rw, io->bio);
> -		io->bio = NULL;
> -		return;
> -	}
> -	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
> -
> -	/*
> -	 * META_FLUSH is only from the checkpoint procedure, and we should wait
> -	 * this metadata bio for FS consistency.
> -	 */
> -	if (fio->type == META_FLUSH) {
> -		DECLARE_COMPLETION_ONSTACK(wait);
> -		io->bio->bi_private = &wait;
> -		submit_bio(rw, io->bio);
> -		wait_for_completion(&wait);
>  	} else {
> -		submit_bio(rw, io->bio);
> +		trace_f2fs_submit_write_bio(io->sbi->sb, rw,
> +						fio->type, io->bio);
> +		/*
> +		 * META_FLUSH is only from the checkpoint procedure, and we
> +		 * should wait this metadata bio for FS consistency.
> +		 */
> +		if (fio->type == META_FLUSH) {
> +			DECLARE_COMPLETION_ONSTACK(wait);
> +			io->bio->bi_private = &wait;
> +			submit_bio(rw, io->bio);
> +			wait_for_completion(&wait);
> +		} else {
> +			submit_bio(rw, io->bio);
> +		}
>  	}
> +
>  	io->bio = NULL;
>  }
>  
> @@ -152,17 +157,12 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
>  int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
>  					block_t blk_addr, int rw)
>  {
> -	struct block_device *bdev = sbi->sb->s_bdev;
>  	struct bio *bio;
>  
>  	trace_f2fs_submit_page_bio(page, blk_addr, rw);
>  
>  	/* Allocate a new bio */
> -	bio = __bio_alloc(bdev, 1);
> -
> -	/* Initialize the bio */
> -	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> -	bio->bi_end_io = is_read_io(rw) ? f2fs_read_end_io : f2fs_write_end_io;
> +	bio = __bio_alloc(sbi, blk_addr, 1, is_read_io(rw));
>  
>  	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
>  		bio_put(bio);
> @@ -178,17 +178,16 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
>  			block_t blk_addr, struct f2fs_io_info *fio)
>  {
>  	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
> -	struct block_device *bdev = sbi->sb->s_bdev;
>  	struct f2fs_bio_info *io;
> -	int bio_blocks;
> +	int is_read = is_read_io(fio->rw);

	 bool is_read = is_read_io(fio->rw);

>  
> -	io = is_read_io(fio->rw) ? &sbi->read_io : &sbi->write_io[btype];
> +	io = is_read ? &sbi->read_io : &sbi->write_io[btype];
>  
>  	verify_block_addr(sbi, blk_addr);
>  
>  	mutex_lock(&io->io_mutex);
>  
> -	if (!is_read_io(fio->rw))
> +	if (!is_read)
>  		inc_page_count(sbi, F2FS_WRITEBACK);
>  
>  	if (io->bio && (io->last_block_in_bio != blk_addr - 1 ||
> @@ -196,17 +195,10 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
>  		__submit_merged_bio(io);
>  alloc_new:
>  	if (io->bio == NULL) {
> -		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> -		io->bio = __bio_alloc(bdev, bio_blocks);
> -		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> -		io->bio->bi_end_io = is_read_io(fio->rw) ? f2fs_read_end_io :
> -							f2fs_write_end_io;
> +		int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> +
> +		io->bio = __bio_alloc(sbi, blk_addr, bio_blocks, is_read);
>  		io->fio = *fio;
> -		/*
> -		 * The end_io will be assigned at the sumbission phase.
> -		 * Until then, let bio_add_page() merge consecutive IOs as much
> -		 * as possible.
> -		 */
>  	}
>  
>  	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <

-- 
Jaegeuk Kim
Samsung

