Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaLXKhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 05:37:33 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48700 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaLXKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 05:37:31 -0500
Date: Wed, 24 Dec 2014 11:37:27 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Geoff Levand <geoff@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: [RFC PATCH 01/17] block: make generic_make_request handle
 arbitrarily sized bios
Message-ID: <20141224103727.GA28836@gmail.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <1419362071.4364.104.camel@smoke>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419362071.4364.104.camel@smoke>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.12.2014 11:14, Geoff Levand wrote:
> On Mon, 2014-12-22 at 12:48 +0100, Dongsu Park wrote:
> > From: Kent Overstreet <kmo@daterainc.com>
> 
> > --- a/drivers/block/ps3vram.c
> > +++ b/drivers/block/ps3vram.c
> > @@ -603,6 +603,8 @@ static void ps3vram_make_request(struct request_queue *q, struct bio *bio)
> >  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
> >  	int busy;
> >  
> > +	blk_queue_split(q, &bio, q->bio_split);
> > +
> >  	dev_dbg(&dev->core, "%s\n", __func__);
> >  
> >  	spin_lock_irq(&priv->lock);
> 
> The dev_dbg() here marks the entry to ps3vram_make_request(), so
> we should put the blk_queue_split() call after the dev_dbg() call.

Okay, I'll do it. Thanks for the review.

Dongsu

> -Geoff
> 
