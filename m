Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaANHR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:17:29 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:44051 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaANHR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:17:27 -0500
Date: Tue, 14 Jan 2014 10:14:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH 1/7] zram: fix race between reset and flushing pending
 work
Message-ID: <20140114071439.GC2322@swordfish>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
 <1389611942-15544-2-git-send-email-minchan@kernel.org>
 <20140113155527.5731d24ca86f01bfd5ec716f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113155527.5731d24ca86f01bfd5ec716f@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/13/14 15:55), Andrew Morton wrote:
[..]
> >
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -553,14 +553,14 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
> >  	size_t index;
> >  	struct zram_meta *meta;
> >  
> > -	flush_work(&zram->free_work);
> > -
> >  	down_write(&zram->init_lock);
> >  	if (!zram->init_done) {
> >  		up_write(&zram->init_lock);
> >  		return;
> >  	}
> >  
> > +	flush_work(&zram->free_work);
> > +
> >  	meta = zram->meta;
> >  	zram->init_done = 0;
> 
> This makes zram.lock nest inside zram.init_lock, which afaict is new
> behaviour.
> 
> That all seems OK and logical - has it been well tested with lockdep?
> 

Patches 1-7
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
