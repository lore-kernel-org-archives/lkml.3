Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab3HGWYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:24:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48636 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933398Ab3HGWYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:24:16 -0400
Message-ID: <1375914247.8674.35.camel@smoke>
Subject: Re: [PATCH 04/22] block: Abstract out bvec iterator
From: Geoff Levand <geoff@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 07 Aug 2013 15:24:07 -0700
In-Reply-To: <1375912471-5106-5-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
	 <1375912471-5106-5-git-send-email-kmo@daterainc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

On Wed, 2013-08-07 at 14:54 -0700, Kent Overstreet wrote:
> Immutable biovecs are going to require an explicit iterator. To
> implement immutable bvecs, a later patch is going to add a bi_bvec_done
> member to this struct; for now, this patch effectively just renames
> things.

> diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
> index d754a88..464be78 100644
> --- a/drivers/block/ps3disk.c
> +++ b/drivers/block/ps3disk.c
> @@ -104,7 +104,7 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
>  		dev_dbg(&dev->sbd.core,
>  			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
>  			__func__, __LINE__, i, bio_segments(iter.bio),
> -			bio_sectors(iter.bio), iter.bio->bi_sector);
> +			bio_sectors(iter.bio), iter.bio->bi_iter.bi_sector);
>  
>  		size = bvec->bv_len;
>  		buf = bvec_kmap_irq(bvec, &flags);

The ps3 part looks OK.  Please try a build test with the powerpc
defconfig_ps3 if you can.

Acked-by: Geoff Levand <geoff@infradead.org>


