Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3DAXfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:35:42 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55491 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab3DAXfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:35:41 -0400
Date: Mon, 1 Apr 2013 16:35:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] THP: Use explicit memory barrier
In-Reply-To: <1364773535-26264-1-git-send-email-minchan@kernel.org>
Message-ID: <alpine.DEB.2.02.1304011634530.21603@chino.kir.corp.google.com>
References: <1364773535-26264-1-git-send-email-minchan@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Apr 2013, Minchan Kim wrote:

> __do_huge_pmd_anonymous_page depends on page_add_new_anon_rmap's
> spinlock for making sure that clear_huge_page write become visible
> after set set_pmd_at() write.
> 
> But lru_cache_add_lru uses pagevec so it could miss spinlock
> easily so above rule was broken so user may see inconsistent data.
> 
> This patch fixes it with using explict barrier rather than depending
> on lru spinlock.
> 

Is this the same issue that Andrea responded to in the "thp and memory 
barrier assumptions" thread at http://marc.info/?t=134333512700004 ?
