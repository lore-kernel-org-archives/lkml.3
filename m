Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbaFJAM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:12:26 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62740 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345AbaFJAMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:12:25 -0400
Message-ID: <1402359051.22759.7.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
From: Chen Yucong <slaoub@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: mgorman@suse.de, mhocko@suse.cz, hannes@cmpxchg.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2014 08:10:51 +0800
In-Reply-To: <20140609232459.GA8171@bbox>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
	 <20140609232459.GA8171@bbox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 08:24 +0900, Minchan Kim wrote:
> Hello,
> 
> On Mon, Jun 09, 2014 at 09:27:16PM +0800, Chen Yucong wrote:
> > Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> > original scan targets introduces extra 40 bytes on the stack. This patch
> > is able to avoid this situation and the call to memcpy(). At the same time,
> > it does not change the relative design idea.
> > 
> > ratio = original_nr_file / original_nr_anon;
> > 
> > If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
> >  x = nr_file - ratio * nr_anon;
> > 
> > if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
> >  x = nr_anon - nr_file / ratio;
> 
> Nice cleanup!
> 
> Below one nitpick.
> 

> 
> If both nr_file and nr_anon are zero, then the nr_anon could be zero
> if HugePage are reclaimed so that it could pass the below check
> 
>         if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
> 
> 
The Mel Gorman's patch has already handled this situation you're
describing. It's called:
 
mm: vmscan: use proportional scanning during direct reclaim and full
scan at DEF_PRIORITY

thx!
cyc

