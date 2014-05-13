Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbaEMBit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:38:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38879 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaEMBis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:38:48 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 13 May 2014 10:40:49 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Yong-Taek Lee <ytk.lee@samsung.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/2] mm/page_alloc: DEBUG_VM checks for free_list
 placement of CMA and RESERVE pages
Message-ID: <20140513014049.GE23803@js1304-P5Q-DELUXE>
References: <1396539618-31362-2-git-send-email-vbabka@suse.cz>
 <53616F39.2070001@oracle.com>
 <53638ADA.5040200@suse.cz>
 <5367A1E5.2020903@oracle.com>
 <5367B356.1030403@suse.cz>
 <20140507013333.GB26212@bbox>
 <536A4A3B.1090403@suse.cz>
 <20140508055421.GC9161@js1304-P5Q-DELUXE>
 <20140508061937.GE5282@bbox>
 <20140508153433.7fcbe624549259b68659fe10@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508153433.7fcbe624549259b68659fe10@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 03:34:33PM -0700, Andrew Morton wrote:
> On Thu, 8 May 2014 15:19:37 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > > I also think that VM_DEBUG overhead isn't problem because of same
> > > reason from Vlastimil.
> > 
> > Guys, please read this.
> > 
> > https://lkml.org/lkml/2013/7/17/591
> > 
> > If you guys really want it, we could separate it with
> > CONFIG_DEBUG_CMA or CONFIG_DEBUG_RESERVE like stuff.
> > Otherwise, just remain in mmotm.
> 
> Wise words, those.
> 
> Yes, these checks are in a pretty hot path.  I'm inclined to make the
> patch -mm (and -next) only.
> 
> Unless there's a really good reason, such as "nobody who uses CMA is
> likely to be testing -next", which sounds likely :(

Hello,

Now, I think that dropping this patch is better if we can only use it
on MIGRATE_CMA case. Later, if I feel that this case should be checked,
I will resend the patch with appropriate argument.

Thanks.
