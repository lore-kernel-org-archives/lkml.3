Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaE0GYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:24:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10735 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaE0GYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:24:37 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-95-53842fa2d8ee
Date: Tue, 27 May 2014 15:23:07 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid overflow when large directory
 feathure is enabled
Message-id: <20140527062307.GB4886@cm224.lee>
References: <00f601cf7948$1263a480$372aed80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <00f601cf7948$1263a480$372aed80$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zA91F+i3BBh8vsln8b/rIZnF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXRt/RRqaC
	fuGK1eenMzcwnuHvYuTkkBAwkWibcZsVwhaTuHBvPVsXIxeHkMAyRomjfRdZYIre9e1ngUgs
	YpToW/4JyvnJKHHzzTdGkCoWAVWJWwvvs4HYbAJaEu2n14J1iwgoSfyav4gVpIFZYAKjxP9F
	78ESwgLxEmvOXmXuYuTg4BXQlTg9OQ4kLCRgKTHryX5mEJtXQFDix+R7YOXMQDPX7zzOBGFL
	Szz6O4MdxOYUsJJ48+46mC0qoCIx5eQ2sBckBHaxS7y8dJcN4jgBiW+TD7GA7JIQkJXYdIAZ
	4jNJiYMrbrBMYBSbhWTdLCTrZiFZt4CReRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSDz1
	7WC8ecD6EGMy0MqJzFKiyfnAeMwriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYxMjM82dbrYXLSw3Krt9CYlneGZZoXlcf4/kUUvnlwyj3kovNux
	6sfnb/EPDutrL3tgM/d92KyoptZouX1FYoc5Mtj2fY7wVDe+eXn/rpiWg0bXFYpcXLxe/+rw
	2p+/brpEEt+T/41cx62sflx+/+o8z+cgbhsR7XO/PP3MdnSEvd9Y/fjUb3MlluKMREMt5qLi
	RABeA8KWvQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgO4i/ZZgg/cnmCz+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMaPvaCNTQb9wxerz05kbGM/wdzFyckgImEi869vPAmGLSVy4t56t
	i5GLQ0hgEaNE3/JPLBDOT0aJm2++MYJUsQioStxaeJ8NxGYT0JJoP70WrFtEQEni1/xFrCAN
	zAITGCX+L3oPlhAWiJdYc/YqcxcjBwevgK7E6clxIGEhAUuJWU/2M4PYvAKCEj8m3wMrZwaa
	uX7ncSYIW1ri0d8Z7CA2p4CVxJt318FsUQEViSknt7FNYBSYhaR9FpL2WUjaFzAyr2IUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIjtZn0jsYVzVYHGIU4GBU4uGd4NscLMSaWFZcmXuIUYKD
	WUmEN5apJViINyWxsiq1KD++qDQntfgQYzIwNCYyS4km5wMTSV5JvKGxiZmRpZGZhZGJuTlp
	wkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MCqruB2aw+Zrv3lZyn8ByY/3kqsuRxadKM5c
	39smMJdPZXXmq5lP6o2C7lawrpA6XtyWfD9oZtbFTplpMk6ZC1Y/YH3ndbnj6EmuSV+Lz69a
	I/HgzkbzPe1OLMeu3nOftzR78cL6kmu/uEMWSQXOzxOa+XQJT21XTN7CPSFrxXUnR3R6Ltpp
	FqHEUpyRaKjFXFScCAAuy4spGgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Chao
Good catch. Please, modify Documentation/filesytems/f2fs.txt

On Tue, May 27, 2014 at 09:06:52AM +0800, Chao Yu wrote:
> When large directory feathure is enable, We have one case which could cause
> overflow in dir_buckets() as following:
> special case: level + dir_level >= 32 and level < MAX_DIR_HASH_DEPTH / 2.
> 
> Here we define MAX_DIR_BUCKETS to limit the return value when the condition
> could trigger potential overflow.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/dir.c           |    4 ++--
>  include/linux/f2fs_fs.h |    3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index c3f1485..966acb0 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -23,10 +23,10 @@ static unsigned long dir_blocks(struct inode *inode)
>  
>  static unsigned int dir_buckets(unsigned int level, int dir_level)
>  {
> -	if (level < MAX_DIR_HASH_DEPTH / 2)
> +	if (level + dir_level < MAX_DIR_HASH_DEPTH / 2)
>  		return 1 << (level + dir_level);
>  	else
> -		return 1 << ((MAX_DIR_HASH_DEPTH / 2 + dir_level) - 1);
> +		return MAX_DIR_BUCKETS;
>  }
>  
>  static unsigned int bucket_blocks(unsigned int level)
> diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
> index 8c03f71..ba6f312 100644
> --- a/include/linux/f2fs_fs.h
> +++ b/include/linux/f2fs_fs.h
> @@ -394,6 +394,9 @@ typedef __le32	f2fs_hash_t;
>  /* MAX level for dir lookup */
>  #define MAX_DIR_HASH_DEPTH	63
>  
> +/* MAX buckets in one level of dir */
> +#define MAX_DIR_BUCKETS		(1 << ((MAX_DIR_HASH_DEPTH / 2) - 1))
> +
>  #define SIZE_OF_DIR_ENTRY	11	/* by byte */
>  #define SIZE_OF_DENTRY_BITMAP	((NR_DENTRY_IN_BLOCK + BITS_PER_BYTE - 1) / \
>  					BITS_PER_BYTE)
> -- 
> 1.7.10.4
> 
> 
> 
> ------------------------------------------------------------------------------
> The best possible search technologies are now affordable for all companies.
> Download your FREE open source Enterprise Search Engine today!
> Our experts will assist you in its installation for $59/mo, no commitment.
> Test it for FREE on our Cloud platform anytime!
> http://pubads.g.doubleclick.net/gampad/clk?id=145328191&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
