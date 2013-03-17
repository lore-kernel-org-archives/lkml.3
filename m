Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3CQOxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:53:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:25093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610Ab3CQOxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,859,1355126400"; 
   d="scan'208";a="280701803"
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] mm: vmscan: Have kswapd shrink slab only once per priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
	<1363525456-10448-9-git-send-email-mgorman@suse.de>
Date: Sun, 17 Mar 2013 07:53:10 -0700
In-Reply-To: <1363525456-10448-9-git-send-email-mgorman@suse.de> (Mel Gorman's
	message of "Sun, 17 Mar 2013 13:04:14 +0000")
Message-ID: <m2wqt6hycp.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> If kswaps fails to make progress but continues to shrink slab then it'll
> either discard all of slab or consume CPU uselessly scanning shrinkers.
> This patch causes kswapd to only call the shrinkers once per priority.

Great. This was too aggressive for a long time. Probably still needs
more intelligence in the shrinkers itself to be really good though
(e.g. the old defrag heuristics in dcache)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
