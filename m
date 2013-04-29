Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab3D2TOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:14:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50359
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760289Ab3D2TOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:14:38 -0400
Date: Mon, 29 Apr 2013 21:14:29 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, xen-devel@lists.xensource.com,
        roger.pau@citrix.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-jens-3.10 xenwatch: page
 allocation failure: order:7, mode:0x10c0d0
Message-ID: <20130429191429.GA9563@kernel.dk>
References: <20130419144401.GA14700@phenom.dumpdata.com>
 <1094538380.20130424201637@eikelenboom.it>
 <20130429154623.GB12754@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429154623.GB12754@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, Apr 24, 2013 at 08:16:37PM +0200, Sander Eikelenboom wrote:
> > Friday, April 19, 2013, 4:44:01 PM, you wrote:
> > 
> > > Hey Jens,
> > 
> > > Please in your spare time (if there is such a thing at a conference)
> > > pull this branch:
> > 
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.10
> > 
> 
> .. snip..
> > Hi Konrad / Roger,
> > 
> > I tried this pull on top of latest Linus latest linux-3.9 tree, but although it seems to boot and work fine at first, i seem to get trouble after running for about a day.
> > Without this pull it runs fine for several days.
> .. snipp.
> 
> > [18496.013743] xenwatch: page allocation failure: order:7, mode:0x10c0d0
> > [18496.031948] Pid: 54, comm: xenwatch Not tainted 3.9.0-rc8-20130424-jens+ #1
> > [18496.049897] Call Trace:
> > [18496.067674]  [<ffffffff81100c51>] warn_alloc_failed+0xf1/0x140
> > [18496.085453]  [<ffffffff810b25ed>] ? trace_hardirqs_on+0xd/0x10
> > [18496.102951]  [<ffffffff810bdb24>] ? on_each_cpu_mask+0x94/0xd0
> > [18496.120270]  [<ffffffff811028af>] __alloc_pages_nodemask+0x69f/0x960
> > [18496.137306]  [<ffffffff8113a161>] alloc_pages_current+0xb1/0x160
> > [18496.154051]  [<ffffffff81100679>] __get_free_pages+0x9/0x40
> > [18496.170579]  [<ffffffff81142af4>] __kmalloc+0x134/0x160
> > [18496.186921]  [<ffffffff815832d0>] xen_blkbk_probe+0x170/0x2f0
> > [18496.202963]  [<ffffffff81474ce7>] xenbus_dev_probe+0x77/0x130
> > [18496.218714]  [<ffffffff8156a390>] ? __driver_attach+0xa0/0xa0
> > [18496.234237]  [<ffffffff8156a151>] driver_probe_device+0x81/0x220
> > [18496.249605]  [<ffffffff8198198c>] ? klist_next+0x8c/0x110
> > [18496.264681]  [<ffffffff8156a390>] ? __driver_attach+0xa0/0xa0
> > [18496.279500]  [<ffffffff8156a3db>] __device_attach+0x4b/0x50
> > [18496.294138]  [<ffffffff815684e8>] bus_for_each_drv+0x68/0x90
> > [18496.308553]  [<ffffffff8156a0c9>] device_attach+0x89/0x90
> > [18496.322694]  [<ffffffff81569258>] bus_probe_device+0xa8/0xd0
> > [18496.336640]  [<ffffffff81567c80>] device_add+0x650/0x720
> 
> .. snip..
> 
> Jens,
> I don't know if you had pulled this git tree yet (I don't see it in
> your for-3.10/* branches).
> 
> But if you have, Sander has found a bug (and Roger has a fix for it).
> 
> Whether you would like to wait until v3.11 to pull it (and me sending
> the git pull around a month) is OK. Or pull it now and we will fix the
> bugs in the -rc's as they creep up.

Thanks for letting me know. Lets postpone it for 3.11. If you have more
critical bits in your current tree, you can send them in over this week.

-- 
Jens Axboe

