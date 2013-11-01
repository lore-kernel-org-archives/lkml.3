Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3KAUih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:38:37 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34611 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KAUif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:38:35 -0400
Message-ID: <5274114B.7010302@gmail.com>
Date: Fri, 01 Nov 2013 16:38:35 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: kosaki.motohiro@gmail.com, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: cache largest vma
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/1/13 4:17 PM), Davidlohr Bueso wrote:
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
> overhead for a miss. Furthermore, systems with !CONFIG_MMU keep
> the current logic.

I'm slightly surprised this cache makes 15% hit. Which application
get a benefit? You listed a lot of applications, but I'm not sure
which is highly depending on largest vma.


