Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3DABCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 21:02:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58748 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3DABCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 21:02:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <5158DC7D.2040607@jp.fujitsu.com>
Date: Mon, 01 Apr 2013 10:01:49 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] THP: Use explicit memory barrier
References: <1364773535-26264-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1364773535-26264-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/01 8:45), Minchan Kim wrote:
> __do_huge_pmd_anonymous_page depends on page_add_new_anon_rmap's
> spinlock for making sure that clear_huge_page write become visible
> after set set_pmd_at() write.
> 
> But lru_cache_add_lru uses pagevec so it could miss spinlock
> easily so above rule was broken so user may see inconsistent data.
> This patch fixes it with using explict barrier rather than depending
> on lru spinlock.
> 

Hmm...how about do_anonymous_page() ? there are no comments/locks/barriers.
Users can see non-zero value after page fault in theory ?

Thanks,
-Kame

