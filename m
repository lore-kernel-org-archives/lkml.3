Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3KAVYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:24:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3KAVYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:24:00 -0400
Message-ID: <52741BE0.4070306@redhat.com>
Date: Fri, 01 Nov 2013 17:23:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        aswin@hp.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: cache largest vma
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 04:17 PM, Davidlohr Bueso wrote:
> While caching the last used vma already does a nice job avoiding
> having to iterate the rbtree in find_vma, we can improve. After
> studying the hit rate on a load of workloads and environments,
> it was seen that it was around 45-50% - constant for a standard
> desktop system (gnome3 + evolution + firefox + a few xterms),
> and multiple java related workloads (including Hadoop/terasort),
> and aim7, which indicates it's better than the 35% value documented
> in the code.
> 
> By also caching the largest vma, that is, the one that contains
> most addresses, there is a steady 10-15% hit rate gain, putting
> it above the 60% region. This improvement comes at a very low

I suspect this will especially help when also using automatic
numa balancing, which causes periodic page faults.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
