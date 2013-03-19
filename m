Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3CSKfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:35:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3CSKfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:35:17 -0400
Date: Tue, 19 Mar 2013 10:35:12 +0000
From: Mel Gorman <mgorman@suse.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] mm: vmscan: Have kswapd writeback pages based on
 dirty pages encountered, not priority
Message-ID: <20130319103512.GG2055@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-7-git-send-email-mgorman@suse.de>
 <20130318110850.GA7144@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130318110850.GA7144@hacker.(null)>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 07:08:50PM +0800, Wanpeng Li wrote:
> >@@ -2735,8 +2748,12 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
> > 				end_zone = i;
> > 				break;
> > 			} else {
> >-				/* If balanced, clear the congested flag */
> >+				/*
> >+				 * If balanced, clear the dirty and congested
> >+				 * flags
> >+				 */
> > 				zone_clear_flag(zone, ZONE_CONGESTED);
> >+				zone_clear_flag(zone, ZONE_DIRTY);
> 
> Hi Mel,
> 
> There are two places in balance_pgdat clear ZONE_CONGESTED flag, one
> is during scan zone which have free_pages <= high_wmark_pages(zone), the 
> other one is zone get balanced after reclaim, it seems that you miss the 
> later one.
> 

I did and it's fixed now. Thanks.

-- 
Mel Gorman
SUSE Labs
