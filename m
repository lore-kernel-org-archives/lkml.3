Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967325Ab3DRPRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:17:46 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43378 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966917Ab3DRPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:17:45 -0400
Date: Thu, 18 Apr 2013 08:16:50 -0700
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        dormando <dormando@rydia.net>, Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] mm: vmscan: Have kswapd writeback pages based on
 dirty pages encountered, not priority
Message-ID: <20130418151650.GH2018@cmpxchg.org>
References: <1365710278-6807-1-git-send-email-mgorman@suse.de>
 <1365710278-6807-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365710278-6807-7-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:57:54PM +0100, Mel Gorman wrote:
> Currently kswapd queues dirty pages for writeback if scanning at an elevated
> priority but the priority kswapd scans at is not related to the number
> of unqueued dirty encountered.  Since commit "mm: vmscan: Flatten kswapd
> priority loop", the priority is related to the size of the LRU and the
> zone watermark which is no indication as to whether kswapd should write
> pages or not.
> 
> This patch tracks if an excessive number of unqueued dirty pages are being
> encountered at the end of the LRU.  If so, it indicates that dirty pages
> are being recycled before flusher threads can clean them and flags the
> zone so that kswapd will start writing pages until the zone is balanced.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
