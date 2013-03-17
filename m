Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3CQOz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:55:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:12605 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681Ab3CQOzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:55:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,859,1355126400"; 
   d="scan'208";a="272000059"
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] mm: vmscan: Move logic from balance_pgdat() to kswapd_shrink_zone()
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
	<1363525456-10448-11-git-send-email-mgorman@suse.de>
Date: Sun, 17 Mar 2013 07:55:54 -0700
In-Reply-To: <1363525456-10448-11-git-send-email-mgorman@suse.de> (Mel
	Gorman's message of "Sun, 17 Mar 2013 13:04:16 +0000")
Message-ID: <m2sj3uhy85.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> +
> +	/*
> +	 * We put equal pressure on every zone, unless one zone has way too
> +	 * many pages free already. The "too many pages" is defined as the
> +	 * high wmark plus a "gap" where the gap is either the low
> +	 * watermark or 1% of the zone, whichever is smaller.
> +	 */
> +	balance_gap = min(low_wmark_pages(zone),
> +		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
> +		KSWAPD_ZONE_BALANCE_GAP_RATIO);

Don't like those hard coded tunables. 1% of a 512GB node can be still
quite a lot. Shouldn't the low watermark be enough?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
