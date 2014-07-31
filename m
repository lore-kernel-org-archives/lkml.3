Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaGaPHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:07:06 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58049 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaGaPHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:07:05 -0400
Date: Thu, 31 Jul 2014 11:06:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] memcg, vmscan: Fix forced scan of anonymous pages
Message-ID: <20140731150653.GA9952@cmpxchg.org>
References: <1406807385-5168-1-git-send-email-jmarchan@redhat.com>
 <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406807385-5168-3-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 01:49:45PM +0200, Jerome Marchand wrote:
> When memory cgoups are enabled, the code that decides to force to scan
> anonymous pages in get_scan_count() compares global values (free,
> high_watermark) to a value that is restricted to a memory cgroup
> (file). It make the code over-eager to force anon scan.
> 
> For instance, it will force anon scan when scanning a memcg that is
> mainly populated by anonymous page, even when there is plenty of file
> pages to get rid of in others memcgs, even when swappiness == 0. It
> breaks user's expectation about swappiness and hurts performance. 
> 
> This patch make sure that forced anon scan only happens when there not
> enough file pages for the all zone, not just in one random memcg.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
