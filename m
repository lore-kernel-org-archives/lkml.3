Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaAaRSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:18:09 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45930 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaAaRSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:18:06 -0500
Date: Fri, 31 Jan 2014 09:17:25 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Kent Overstreet <kmo@daterainc.com>
cc: Hugh Dickins <hughd@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
In-Reply-To: <20140117012105.GS9037@kmo>
Message-ID: <alpine.LSU.2.11.1401310852000.987@eggly.anvils>
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils> <20140114023346.GN9037@kmo> <yq161pnmcl2.fsf@sermon.lab.mkp.net> <20140114044841.GO9037@kmo> <yq1ob3el3mr.fsf@sermon.lab.mkp.net> <20140114222424.GA7333@moria.home.lan> <alpine.LSU.2.11.1401161129380.1321@eggly.anvils>
 <20140117012105.GS9037@kmo>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Kent Overstreet wrote:
> 
> Ok, I reread the code and figured it out - the analagous change also has to be
> made in __blk_segment_map_sg(). I'll mail out a patch for this tomorrow after
> I've stared at the code more and had less beer.

I'd been hoping for a patch to try, but now your changes have hit Linus's
tree: so today we have discard broken there too, crashing as originally
reported on the NULL struct page pointer in __blk_recalc_rq_segments()'s
page_to_pfn(bv.bv_page).

How to reproduce it?  I hope you'll find easier ways, but I get it with
swapping to SSD (remember "swapon -d" to enable discard).  I'm just doing
what I've done for years, running a pair of make -j20 kbuilds to tmpfs in
limited RAM (I use mem=700M with 1.5G of swap: but that would be far too
little RAM for a general config of current tree), to get plenty of fairly
chaotic swapping but good forward progress nonetheless (if the sizes are
too small, then it'll just thrash abysmally or be OOM-killed).

But please do send me a patch and I'll give it a try - thanks.

Hugh
