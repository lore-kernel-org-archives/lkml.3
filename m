Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbaAaV6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:58:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:58:35 -0500
Date: Fri, 31 Jan 2014 14:58:30 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Hugh Dickins <hughd@google.com>
Cc: Kent Overstreet <kmo@daterainc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
Message-ID: <20140131215830.GB24191@kernel.dk>
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
 <20140114023346.GN9037@kmo>
 <yq161pnmcl2.fsf@sermon.lab.mkp.net>
 <20140114044841.GO9037@kmo>
 <yq1ob3el3mr.fsf@sermon.lab.mkp.net>
 <20140114222424.GA7333@moria.home.lan>
 <alpine.LSU.2.11.1401161129380.1321@eggly.anvils>
 <20140117012105.GS9037@kmo>
 <alpine.LSU.2.11.1401310852000.987@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401310852000.987@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31 2014, Hugh Dickins wrote:
> On Thu, 16 Jan 2014, Kent Overstreet wrote:
> > 
> > Ok, I reread the code and figured it out - the analagous change also has to be
> > made in __blk_segment_map_sg(). I'll mail out a patch for this tomorrow after
> > I've stared at the code more and had less beer.
> 
> I'd been hoping for a patch to try, but now your changes have hit Linus's
> tree: so today we have discard broken there too, crashing as originally
> reported on the NULL struct page pointer in __blk_recalc_rq_segments()'s
> page_to_pfn(bv.bv_page).
> 
> How to reproduce it?  I hope you'll find easier ways, but I get it with
> swapping to SSD (remember "swapon -d" to enable discard).  I'm just doing
> what I've done for years, running a pair of make -j20 kbuilds to tmpfs in
> limited RAM (I use mem=700M with 1.5G of swap: but that would be far too
> little RAM for a general config of current tree), to get plenty of fairly
> chaotic swapping but good forward progress nonetheless (if the sizes are
> too small, then it'll just thrash abysmally or be OOM-killed).
> 
> But please do send me a patch and I'll give it a try - thanks.

Hugh, sorry about that, this particular issue slipped my mind. Will get
this fixed up as soon as possible, hopefully before -rc1...

-- 
Jens Axboe

