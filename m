Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaFWM4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:56:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbaFWM4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:56:07 -0400
Date: Mon, 23 Jun 2014 13:56:02 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mm: vmscan: remove remains of kswapd-managed
 zone->all_unreclaimable
Message-ID: <20140623125602.GL10819@suse.de>
References: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 12:33:47PM -0400, Johannes Weiner wrote:
> shrink_zones() has a special branch to skip the all_unreclaimable()
> check during hibernation, because a frozen kswapd can't mark a zone
> unreclaimable.
> 
> But ever since 6e543d5780e3 ("mm: vmscan: fix do_try_to_free_pages()
> livelock"), determining a zone to be unreclaimable is done by directly
> looking at its scan history and no longer relies on kswapd setting the
> per-zone flag.
> 
> Remove this branch and let shrink_zones() check the reclaimability of
> the target zones regardless of hibernation state.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
