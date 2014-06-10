Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978AbaFJAYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:24:13 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60108 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaFJAYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:24:10 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 10 Jun 2014 09:24:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Chen Yucong <slaoub@gmail.com>
Cc: mgorman@suse.de, mhocko@suse.cz, hannes@cmpxchg.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
Message-ID: <20140610002410.GB8171@bbox>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
 <20140609232459.GA8171@bbox>
 <1402359051.22759.7.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402359051.22759.7.camel@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 08:10:51AM +0800, Chen Yucong wrote:
> On Tue, 2014-06-10 at 08:24 +0900, Minchan Kim wrote:
> > Hello,
> > 
> > On Mon, Jun 09, 2014 at 09:27:16PM +0800, Chen Yucong wrote:
> > > Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> > > original scan targets introduces extra 40 bytes on the stack. This patch
> > > is able to avoid this situation and the call to memcpy(). At the same time,
> > > it does not change the relative design idea.
> > > 
> > > ratio = original_nr_file / original_nr_anon;
> > > 
> > > If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
> > >  x = nr_file - ratio * nr_anon;
> > > 
> > > if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
> > >  x = nr_anon - nr_file / ratio;
> > 
> > Nice cleanup!
> > 
> > Below one nitpick.
> > 
> 
> > 
> > If both nr_file and nr_anon are zero, then the nr_anon could be zero
> > if HugePage are reclaimed so that it could pass the below check
> > 
> >         if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
> > 
> > 
> The Mel Gorman's patch has already handled this situation you're
> describing. It's called:
>  
> mm: vmscan: use proportional scanning during direct reclaim and full
> scan at DEF_PRIORITY

It seems I was far away from vmscan.c for a while.
Thanks for the pointing out. So,

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
