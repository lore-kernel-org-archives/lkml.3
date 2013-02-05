Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3BET1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:27:06 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39241 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab3BET1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:27:04 -0500
Date: Tue, 5 Feb 2013 14:26:40 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: akpm@linux-foundation.org, Linux MM <linux-mm@kvack.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        m.szyprowski@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: rename confusing function names
Message-ID: <20130205192640.GC6481@cmpxchg.org>
References: <51113CE3.5090000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51113CE3.5090000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 01:09:55AM +0800, Zhang Yanfei wrote:
> Function nr_free_zone_pages, nr_free_buffer_pages and nr_free_pagecache_pages
> are horribly badly named, they count present_pages - pages_high within zones
> instead of free pages, so why not rename them to reasonable names, not cofusing
> people.
> 
> patch2 and patch3 are based on patch1. So please apply patch1 first.
> 
> Zhang Yanfei (3):
>   mm: rename nr_free_zone_pages to nr_free_zone_high_pages
>   mm: rename nr_free_buffer_pages to nr_free_buffer_high_pages
>   mm: rename nr_free_pagecache_pages to nr_free_pagecache_high_pages

I don't feel that this is an improvement.

As you said, the "free" is already misleading, because those pages
might all be allocated.  "High" makes me think not just of highmem,
but drug abuse in general.

nr_available_*_pages?  I don't know, but if we go through with all
that churn, it had better improve something.
