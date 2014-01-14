Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaANHMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:12:05 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:45814 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaANHMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:12:03 -0500
Date: Tue, 14 Jan 2014 10:09:14 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH 6/7] zram: remove workqueue for freeing removed pending
 slot
Message-ID: <20140114070914.GB2322@swordfish>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
 <1389611942-15544-7-git-send-email-minchan@kernel.org>
 <20140113194111.GA2322@swordfish>
 <20140113233848.GT1992@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113233848.GT1992@bbox>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Minchan,

On (01/14/14 08:38), Minchan Kim wrote:
> Hello Sergey,
> 
> On Mon, Jan 13, 2014 at 10:42:56PM +0300, Sergey Senozhatsky wrote:
> > On (01/13/14 20:19), Minchan Kim wrote:
> > 
> > Hello Minchan,
> > I think we need to down_write init_lock in zram_slot_free_notify(),
> > and thus can avoid locking meta->tb_lock. otherwise, I think,
> 
> zram_slot_free_notify is atomic path so we couldn't hold mutex.
> 
> > there is a chance that zram_slot_free_notify() can race with
> > device reset, e.g.
> > 	
> > 	zram_slot_free_notify()			zram_reset_device()
> > 						down_write(&zram->init_lock);
> > 	meta = zram->meta
> > 						zram_meta_free(zram->meta);
> > 						zram->meta = NULL;
> > 	write_lock(&meta->tb_lock);
> > 	[...]
> > 	write_unlock(&meta->tb_lock);
> > 						[..]
> > 						up_write(&zram->init_lock);
> > 
> 
> Nope. We couldn't reset active device by bdev->bd_holders check
> logic in reset_store.
> 

true. sorry for the noise.

	-ss
