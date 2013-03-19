Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab3CSKTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:19:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab3CSKTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:19:42 -0400
Date: Tue, 19 Mar 2013 10:19:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] mm: vmscan: Decide whether to compact the pgdat
 based on reclaim progress
Message-ID: <20130319101937.GE2055@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-5-git-send-email-mgorman@suse.de>
 <20130318111130.GA7245@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130318111130.GA7245@hacker.(null)>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 07:11:30PM +0800, Wanpeng Li wrote:
> >@@ -2864,46 +2879,21 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
> > 		if (try_to_freeze() || kthread_should_stop())
> > 			break;
> >
> >-		/* If no reclaim progress then increase scanning priority */
> >-		if (sc.nr_reclaimed - nr_reclaimed == 0)
> >-			raise_priority = true;
> >+		/* Compact if necessary and kswapd is reclaiming efficiently */
> >+		this_reclaimed = sc.nr_reclaimed - nr_reclaimed;
> >+		if (order && pgdat_needs_compaction &&
> >+				this_reclaimed > nr_to_reclaim)
> >+			compact_pgdat(pgdat, order);
> >
> 
> Hi Mel,
> 
> If you should check compaction_suitable here to confirm it's not because
> other reasons like large number of pages under writeback to avoid blind
> compaction. :-)
> 

This starts as a question but it is not a question so I am not sure how
I should respond.

Checking compaction_suitable here is unnecessary because compact_pgdat()
makes the same check when it calls compact_zone().

-- 
Mel Gorman
SUSE Labs
