Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3CSK7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:59:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3CSK7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:59:45 -0400
Date: Tue, 19 Mar 2013 10:59:41 +0000
From: Mel Gorman <mgorman@suse.de>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd
 reclaims at each priority
Message-ID: <20130319105941.GJ2055@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-2-git-send-email-mgorman@suse.de>
 <5147A8EC.5010908@gmail.com>
 <20130319095514.GA2055@suse.de>
 <51483B12.6040502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51483B12.6040502@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 06:16:50PM +0800, Simon Jeons wrote:
> Hi Mel,
> On 03/19/2013 05:55 PM, Mel Gorman wrote:
> >On Tue, Mar 19, 2013 at 07:53:16AM +0800, Simon Jeons wrote:
> >>Hi Mel,
> >>On 03/17/2013 09:04 PM, Mel Gorman wrote:
> >>>The number of pages kswapd can reclaim is bound by the number of pages it
> >>>scans which is related to the size of the zone and the scanning priority. In
> >>>many cases the priority remains low because it's reset every SWAP_CLUSTER_MAX
> >>>reclaimed pages but in the event kswapd scans a large number of pages it
> >>>cannot reclaim, it will raise the priority and potentially discard a large
> >>>percentage of the zone as sc->nr_to_reclaim is ULONG_MAX. The user-visible
> >>>effect is a reclaim "spike" where a large percentage of memory is suddenly
> >>>freed. It would be bad enough if this was just unused memory but because
> >>Since there is nr_reclaimed >= nr_to_reclaim check if priority is
> >>large than DEF_PRIORITY in shrink_lruvec, how can a large percentage
> >>of memory is suddenly freed happen?
> >>
> >Because of the priority checks made in get_scan_count(). Patch 5 has
> >more detail on why this happens.
> >
> But nr_reclaim >= nr_to_reclaim check in function shrink_lruvec is
> after scan each evictable lru, so if priority == 0, still scan the
> whole world.
> 

Patch 5 deals with the case where priority == 0.

-- 
Mel Gorman
SUSE Labs
