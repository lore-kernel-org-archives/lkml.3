Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaLWTOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:14:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:46682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLWTOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:14:37 -0500
Message-ID: <1419362071.4364.104.camel@smoke>
Subject: Re: [RFC PATCH 01/17] block: make generic_make_request handle
 arbitrarily sized bios
From: Geoff Levand <geoff@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>
Date: Tue, 23 Dec 2014 11:14:31 -0800
In-Reply-To: <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
	 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2014-12-22 at 12:48 +0100, Dongsu Park wrote:
> From: Kent Overstreet <kmo@daterainc.com>

> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -603,6 +603,8 @@ static void ps3vram_make_request(struct request_queue *q, struct bio *bio)
>  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
>  	int busy;
>  
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	dev_dbg(&dev->core, "%s\n", __func__);
>  
>  	spin_lock_irq(&priv->lock);

The dev_dbg() here marks the entry to ps3vram_make_request(), so
we should put the blk_queue_split() call after the dev_dbg() call.

-Geoff

