Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbaHZDHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 23:07:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41627 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaHZDHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 23:07:49 -0400
X-AuditID: cbfee61a-f79e46d00000134f-23-53fbf9ed7d3b
From: Chao Yu <chao2.yu@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <000201cfbde2$2ae08710$80a19530$@samsung.com>
 <20140825003610.GM17372@bbox>
In-reply-to: <20140825003610.GM17372@bbox>
Subject: RE: [PATCH v3] zram: add num_discards for discarded pages stat
Date: Tue, 26 Aug 2014 11:05:47 +0800
Message-id: <008001cfc0da$de01b0d0$9a051270$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqAXr27T8dWW6NRcydERO6c93iPAIE7SYmmx2EuBA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgO7bn7+DDXY+M7KYs34Nm8WpP9eZ
	LC7vmsNmcW/Nf1aLZV/fs1tsaJnFbrH282N2B3aPnbPusntsWtXJ5rHp0yR2jxMzfrN4vN93
	lc1j56fNrB6fN8kFsEdx2aSk5mSWpRbp2yVwZezacpq94JdBxf7mV2wNjAvUuxg5OSQETCQa
	3u5khrDFJC7cW8/WxcjFISSwiFHi1srPjBDOD0aJ7wfeglWxCahILO/4zwRiiwioSaw7+IIF
	pIhZ4AajxM2fx1hBEkICkRIPNz4HK+IU0JL4MHs2WFxYwF3i36o37CA2i4CqxJp9c4DWcXDw
	ClhKrJ8PNp9XQFDix+R7LCA2s4C6xKR5i5ghbHmJzWveQl2qILHj7GtGiBusJG58amCDqBGX
	2HjkFssERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHEPP
	pHYwrmywOMQowMGoxMN7I/53sBBrYllxZe4hRgkOZiURXoaHQCHelMTKqtSi/Pii0pzU4kOM
	0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2Ms9aIGOcrmu5qa1NYd+ri0z9LnvJ7bOg9
	W6fVxWdorfFTf/XZOxE7DVyDvl965rKzRb3gwx5jthaDgvAvD5/9mR3atkFhAsfZrhmP3j5f
	Z+GmoJlisSlqFle3a9eK8zEXglUzcqzPuYUV8BrcCN+f90G1O8UmNk78Bsudom9pzau6a951
	ZFoosRRnJBpqMRcVJwIAsIHMJJ0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

> -----Original Message-----
> From: Minchan Kim [mailto:minchan@kernel.org]
> Sent: Monday, August 25, 2014 8:36 AM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; ngupta@vflare.org; 'Jerome Marchand';
> 'Sergey Senozhatsky'; 'Andrew Morton'
> Subject: Re: [PATCH v3] zram: add num_discards for discarded pages stat
> 
> Hello Chao,
> 
> On Fri, Aug 22, 2014 at 04:21:01PM +0800, Chao Yu wrote:
> > Since we have supported handling discard request in this commit
> > f4659d8e620d08bd1a84a8aec5d2f5294a242764 (zram: support REQ_DISCARD), zram got
> > one more chance to free unused memory whenever received discard request. But
> > without stating for discard request, there is no method for user to know whether
> > discard request has been handled by zram or how many blocks were discarded by
> > zram when user wants to know the effect of discard.
> 
> My concern is that how much we are able to know the effect of discard
> exactly with your patch.
> 
> The issue I can think of is zram-swap discard.
> Now, zram handles notification from VM to free duplicated copy between
> VM-owned memory and zRAM-owned's one so discarding for zram-swap might
> be pointless overhead but your stat indicates lots of free page discarded
> without real freeing so that user might think "We should keep enable
> swap discard for zRAM because the stat indicates it's really good".

Agreed.

> 
> In summary, wouldn't it better to have two?

Yeah, I'd like to.

> 
> num_discards,
> num_failed_discards?

It's good, but, IMHO, as it's not failed to discard pages due to inside
error of zRAM, How about show this information more positive by using:
num_discard_req,
num_discarded

Then user might think "We can keep on using real-time mode or batch mode
discard, because our freed pages are increased continuously shew by the
num_discarded with sending discard reqs each time.

How do you think?

Thanks,
Yu

> 
> For it, we should modify zram_free_page has return value.
> What do other guys think?
> 
> >
> > In this patch, we add num_discards to stat discarded pages, and export it to
> > sysfs for users.
> >
> > * From v1
> >  * Update zram document to show num_discards in statistics list.
> >
> > * From v2
> >  * Update description of this patch with clear goal.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  Documentation/ABI/testing/sysfs-block-zram | 10 ++++++++++
> >  Documentation/blockdev/zram.txt            |  1 +
> >  drivers/block/zram/zram_drv.c              |  3 +++
> >  drivers/block/zram/zram_drv.h              |  1 +
> >  4 files changed, 15 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-block-zram
> b/Documentation/ABI/testing/sysfs-block-zram
> > index 70ec992..fa8936e 100644
> > --- a/Documentation/ABI/testing/sysfs-block-zram
> > +++ b/Documentation/ABI/testing/sysfs-block-zram
> > @@ -57,6 +57,16 @@ Description:
> >  		The failed_writes file is read-only and specifies the number of
> >  		failed writes happened on this device.
> >
> > +
> > +What:		/sys/block/zram<id>/num_discards
> > +Date:		August 2014
> > +Contact:	Chao Yu <chao2.yu@samsung.com>
> > +Description:
> > +		The num_discards file is read-only and specifies the number of
> > +		physical blocks which are discarded by this device. These blocks
> > +		are included in discard request which is sended by filesystem as
> > +		the blocks are no longer used.
> > +
> >  What:		/sys/block/zram<id>/max_comp_streams
> >  Date:		February 2014
> >  Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
> > index 0595c3f..e50e18b 100644
> > --- a/Documentation/blockdev/zram.txt
> > +++ b/Documentation/blockdev/zram.txt
> > @@ -89,6 +89,7 @@ size of the disk when not in use so a huge zram is wasteful.
> >  		num_writes
> >  		failed_reads
> >  		failed_writes
> > +		num_discards
> >  		invalid_io
> >  		notify_free
> >  		zero_pages
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index d00831c..904e7a5 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -606,6 +606,7 @@ static void zram_bio_discard(struct zram *zram, u32 index,
> >  		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
> >  		zram_free_page(zram, index);
> >  		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
> > +		atomic64_inc(&zram->stats.num_discards);
> >  		index++;
> >  		n -= PAGE_SIZE;
> >  	}
> > @@ -866,6 +867,7 @@ ZRAM_ATTR_RO(num_reads);
> >  ZRAM_ATTR_RO(num_writes);
> >  ZRAM_ATTR_RO(failed_reads);
> >  ZRAM_ATTR_RO(failed_writes);
> > +ZRAM_ATTR_RO(num_discards);
> >  ZRAM_ATTR_RO(invalid_io);
> >  ZRAM_ATTR_RO(notify_free);
> >  ZRAM_ATTR_RO(zero_pages);
> > @@ -879,6 +881,7 @@ static struct attribute *zram_disk_attrs[] = {
> >  	&dev_attr_num_writes.attr,
> >  	&dev_attr_failed_reads.attr,
> >  	&dev_attr_failed_writes.attr,
> > +	&dev_attr_num_discards.attr,
> >  	&dev_attr_invalid_io.attr,
> >  	&dev_attr_notify_free.attr,
> >  	&dev_attr_zero_pages.attr,
> > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> > index e0f725c..2994aaf 100644
> > --- a/drivers/block/zram/zram_drv.h
> > +++ b/drivers/block/zram/zram_drv.h
> > @@ -86,6 +86,7 @@ struct zram_stats {
> >  	atomic64_t num_writes;	/* --do-- */
> >  	atomic64_t failed_reads;	/* can happen when memory is too low */
> >  	atomic64_t failed_writes;	/* can happen when memory is too low */
> > +	atomic64_t num_discards;	/* no. of discarded pages */
> >  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
> >  	atomic64_t notify_free;	/* no. of swap slot free notifications */
> >  	atomic64_t zero_pages;		/* no. of zero filled pages */
> > --
> > 2.0.1.474.g72c7794
> >
> >
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> --
> Kind regards,
> Minchan Kim

