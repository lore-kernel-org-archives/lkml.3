Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3CQOml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:42:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:17082 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab3CQOmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:42:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,859,1355126400"; 
   d="scan'208";a="304108831"
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] mm: vmscan: Have kswapd writeback pages based on dirty pages encountered, not priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
	<1363525456-10448-7-git-send-email-mgorman@suse.de>
Date: Sun, 17 Mar 2013 07:42:39 -0700
In-Reply-To: <1363525456-10448-7-git-send-email-mgorman@suse.de> (Mel Gorman's
	message of "Sun, 17 Mar 2013 13:04:12 +0000")
Message-ID: <m2620qjdeo.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> @@ -495,6 +495,9 @@ typedef enum {
>  	ZONE_CONGESTED,			/* zone has many dirty pages backed by
>  					 * a congested BDI
>  					 */
> +	ZONE_DIRTY,			/* reclaim scanning has recently found
> +					 * many dirty file pages
> +					 */

Needs a better name. ZONE_DIRTY_CONGESTED ? 

> +	 * currently being written then flag that kswapd should start
> +	 * writing back pages.
> +	 */
> +	if (global_reclaim(sc) && nr_dirty &&
> +			nr_dirty >= (nr_taken >> (DEF_PRIORITY - sc->priority)))
> +		zone_set_flag(zone, ZONE_DIRTY);
> +
>  	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,

I suppose you want to trace the dirty case here too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
