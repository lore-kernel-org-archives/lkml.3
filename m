Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3EQDl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:41:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52089 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3EQDl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:41:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5195A6DF.4080403@jp.fujitsu.com>
Date: Fri, 17 May 2013 12:41:19 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] mm: vmscan: Obey proportional scanning requirements
 for kswapd
References: <1368432760-21573-1-git-send-email-mgorman@suse.de> <1368432760-21573-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1368432760-21573-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/13 17:12), Mel Gorman wrote:
> Simplistically, the anon and file LRU lists are scanned proportionally
> depending on the value of vm.swappiness although there are other factors
> taken into account by get_scan_count().  The patch "mm: vmscan: Limit
> the number of pages kswapd reclaims" limits the number of pages kswapd
> reclaims but it breaks this proportional scanning and may evenly shrink
> anon/file LRUs regardless of vm.swappiness.
> 
> This patch preserves the proportional scanning and reclaim. It does mean
> that kswapd will reclaim more than requested but the number of pages will
> be related to the high watermark.
> 
> [mhocko@suse.cz: Correct proportional reclaim for memcg and simplify]
> [kamezawa.hiroyu@jp.fujitsu.com: Recalculate scan based on target]
> [hannes@cmpxchg.org: Account for already scanned pages properly]
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


