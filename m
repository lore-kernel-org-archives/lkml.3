Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab3CQPJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:09:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab3CQPJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:09:39 -0400
Date: Sun, 17 Mar 2013 15:09:36 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] mm: vmscan: Flatten kswapd priority loop
Message-ID: <20130317150935.GB2026@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-4-git-send-email-mgorman@suse.de>
 <m2ehfejdp5.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <m2ehfejdp5.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 07:36:22AM -0700, Andi Kleen wrote:
> Mel Gorman <mgorman@suse.de> writes:
> >
> > To avoid infinite looping for high-order allocation requests kswapd will
> > not reclaim for high-order allocations when it has reclaimed at least
> > twice the number of pages as the allocation request.
> 
> Will this make higher order allocations fail earlier? Or does compaction 
> still kick in early enough.
> 

Compaction should still kick in early enough. The impact it might have
is that direct reclaim/compaction may be used more than it was in the
past.

-- 
Mel Gorman
SUSE Labs
