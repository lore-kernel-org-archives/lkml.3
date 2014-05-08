Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaEHI7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:59:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24705 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaEHI7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:59:42 -0400
X-AuditID: cbfee61b-b7f766d00000646c-9a-536b477dc7f5
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <004801cf6908$e2149bd0$a63dd370$@samsung.com>
 <1399422592.13268.15.camel@kjgkr>
In-reply-to: <1399422592.13268.15.camel@kjgkr>
Subject: RE: [f2fs-dev][PATCH 6/6] f2fs: add a tracepoint for
 f2fs_read_data_pages
Date: Thu, 08 May 2014 16:58:57 +0800
Message-id: <000001cf6a9b$d9d14740$8d73d5c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQImpIyb2UIZ87spWRCdD1Fk4qcAkAK/KzK/mm/hF0A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jQd1a9+xgg8mveSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytjz7g1bwReRirUd
	0xkbGA8LdDFyckgImEi8OL+dDcIWk7hwbz2QzcUhJDCdUWLR7GtMEM4PRok70++zg1SxCahI
	LO/4zwRiiwhIS8z6NI8FxGYWyJS41zSDGcQWEoiVOLD8JpjNKaAn0XLuOiuILSwQInG05zbY
	NhYBVYl7N1aC1fAKWEpMOfuKBcIWlPgx+R6QzQE0U11iypRciPHaEk/eXWCFOFRBYsfZ14wQ
	J1hJXP3aygZRIy6x8cgtlgmMQrOQTJqFMGkWkkmzkHQsYGRZxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREc9s+kdzCuarA4xCjAwajEw5vhnBUsxJpYVlyZe4hRgoNZSYQ3zTE7WIg3JbGy
	KrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAPj9AN2jSERDcmt71cc
	FEpTWytZusF3lp2sgeUs9l/x/4Pe8ph8uVhUYP/5/MW/d41ffIu7dUJkp4DlGzPl1wcklq8y
	j037blMXqqWivSZyc4nO0UirWT/nbJas08oKEepX3htg+fP0vDU3fWqtNt9ZYLMvkKt4Yf/j
	9bY996pje2fFKUz7onlIiaU4I9FQi7moOBEAwgzvT3cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Wednesday, May 07, 2014 8:30 AM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 6/6] f2fs: add a tracepoint for f2fs_read_data_pages
> 
> Hi Chao,
> 
> 2014-05-06 (화), 16:54 +0800, Chao Yu:
> > This patch adds a tracepoint for f2fs_read_data_pages to trace when pages are
> > readahead by VFS.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/data.c              |    3 +++
> >  include/trace/events/f2fs.h |   26 ++++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 8c250a5..f2d1e8a 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -729,6 +729,9 @@ static int f2fs_read_data_pages(struct file *file,
> >  			struct list_head *pages, unsigned nr_pages)
> >  {
> >  	struct inode *inode = file->f_mapping->host;
> > +	struct page *page = list_entry(pages->prev, struct page, lru);
> 
> IMO, it needs to avoid the above line.

Maybe it’s not safe to access page directly in lru list here.
Let's ignore this patch.
Thanks.

> Thanks,
> 
> > +
> > +	trace_f2fs_readpages(inode, page, nr_pages);
> >
> >  	/* If the file has inline data, skip readpages */
> >  	if (f2fs_has_inline_data(inode))
> > diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> > index b983990..7fbaaaa 100644
> > --- a/include/trace/events/f2fs.h
> > +++ b/include/trace/events/f2fs.h
> > @@ -847,6 +847,32 @@ TRACE_EVENT(f2fs_writepages,
> >  		__entry->for_sync)
> >  );
> >
> > +TRACE_EVENT(f2fs_readpages,
> > +
> > +	TP_PROTO(struct inode *inode, struct page *page, unsigned int nrpage),
> > +
> > +	TP_ARGS(inode, page, nrpage),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(dev_t,	dev)
> > +		__field(ino_t,	ino)
> > +		__field(pgoff_t,	start)
> > +		__field(unsigned int,	nrpage)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->dev	= inode->i_sb->s_dev;
> > +		__entry->ino	= inode->i_ino;
> > +		__entry->start	= page->index;
> > +		__entry->nrpage	= nrpage;
> > +	),
> > +
> > +	TP_printk("dev = (%d,%d), ino = %lu, start = %lu nrpage = %u",
> > +		show_dev_ino(__entry),
> > +		(unsigned long)__entry->start,
> > +		__entry->nrpage)
> > +);
> > +
> >  TRACE_EVENT(f2fs_submit_page_mbio,
> >
> >  	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
> 
> --
> Jaegeuk Kim
> Samsung

