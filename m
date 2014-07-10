Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaGJMO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:14:26 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53549 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbaGJMOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:14:23 -0400
Date: Thu, 10 Jul 2014 08:14:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/6] mm: page_alloc: Abort fair zone allocation policy
 when remotes nodes are encountered
Message-ID: <20140710121419.GM29639@cmpxchg.org>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404893588-21371-6-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:13:07AM +0100, Mel Gorman wrote:
> The purpose of numa_zonelist_order=zone is to preserve lower zones
> for use with 32-bit devices. If locality is preferred then the
> numa_zonelist_order=node policy should be used. Unfortunately, the fair
> zone allocation policy overrides this by skipping zones on remote nodes
> until the lower one is found. While this makes sense from a page aging
> and performance perspective, it breaks the expected zonelist policy. This
> patch restores the expected behaviour for zone-list ordering.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

32-bit NUMA? :-) Anyway, this change also cuts down the fair pass
overhead on bigger NUMA machines, so I'm all for it.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
