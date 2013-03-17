Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3CQOjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:39:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:49266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab3CQOji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:39:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,859,1355126400"; 
   d="scan'208";a="304108359"
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] mm: vmscan: Obey proportional scanning requirements for kswapd
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
	<1363525456-10448-3-git-send-email-mgorman@suse.de>
Date: Sun, 17 Mar 2013 07:39:37 -0700
In-Reply-To: <1363525456-10448-3-git-send-email-mgorman@suse.de> (Mel Gorman's
	message of "Sun, 17 Mar 2013 13:04:08 +0000")
Message-ID: <m2a9q2jdjq.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:
> +
> +	/*
> +	 * For direct reclaim, reclaim the number of pages requested. Less
> +	 * care is taken to ensure that scanning for each LRU is properly
> +	 * proportional. This is unfortunate and is improper aging but
> +	 * minimises the amount of time a process is stalled.
> +	 */
> +	if (!current_is_kswapd()) {
> +		if (nr_reclaimed >= nr_to_reclaim) {
> +			for_each_evictable_lru(l)

Don't we need some NUMA awareness here?
Similar below.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
