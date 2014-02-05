Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaBEJzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:55:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35749 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaBEJzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:55:32 -0500
Date: Wed, 5 Feb 2014 12:52:11 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 6/8] zram: report failed read and write stats
Message-ID: <20140205095211.GA2200@swordfish.minsk.epam.com>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389877936-15543-7-git-send-email-sergey.senozhatsky@gmail.com>
 <20140204141849.d530625a13e80708446ac426@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204141849.d530625a13e80708446ac426@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/04/14 14:18), Andrew Morton wrote:
> Date: Tue, 4 Feb 2014 14:18:49 -0800
> From: Andrew Morton <akpm@linux-foundation.org>
> To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand
>  <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
>  linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv3 6/8] zram: report failed read and write stats
> X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
> 
> On Thu, 16 Jan 2014 16:12:14 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> 
> > zram accounted but did not report numbers of failed read
> > and write queries. make these stats available as failed_reads
> > and failed_writes attrs.
> > 
> > Acked-by: Minchan Kim <minchan@kernel.org>
> > Acked-by: Jerome Marchand <jmarchan@redhat.com>
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >  drivers/block/zram/zram_drv.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index e7102f1..9d67fbf 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -728,6 +728,8 @@ static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
> >  
> >  ZRAM_ATTR_RO(num_reads);
> >  ZRAM_ATTR_RO(num_writes);
> > +ZRAM_ATTR_RO(failed_reads);
> > +ZRAM_ATTR_RO(failed_writes);
> >  ZRAM_ATTR_RO(invalid_io);
> >  ZRAM_ATTR_RO(notify_free);
> >  ZRAM_ATTR_RO(zero_pages);
> > @@ -739,6 +741,8 @@ static struct attribute *zram_disk_attrs[] = {
> >  	&dev_attr_reset.attr,
> >  	&dev_attr_num_reads.attr,
> >  	&dev_attr_num_writes.attr,
> > +	&dev_attr_failed_reads.attr,
> > +	&dev_attr_failed_writes.attr,
> >  	&dev_attr_invalid_io.attr,
> >  	&dev_attr_notify_free.attr,
> >  	&dev_attr_zero_pages.attr,
> 
> Documentation/blockdev/zram.txt and
> Documentation/ABI/testing/sysfs-block-zram need updating...
> 

Hello,
sure, will update.

	-ss
