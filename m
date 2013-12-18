Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3LRNr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:47:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab3LRNry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:47:54 -0500
Message-ID: <52B1A781.50002@redhat.com>
Date: Wed, 18 Dec 2013 08:47:45 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Configurable fair allocation zone policy v3
References: <1387298904-8824-1-git-send-email-mgorman@suse.de> <20131217200210.GG21724@cmpxchg.org> <20131218061750.GK21724@cmpxchg.org>
In-Reply-To: <20131218061750.GK21724@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 01:17 AM, Johannes Weiner wrote:

> Updated version with your tmpfs __GFP_PAGECACHE parts added and
> documentation, changelog updated as necessary.  I remain unconvinced
> that tmpfs pages should be round-robined, but I agree with you that it
> is the conservative change to do for 3.12 and 3.12 and we can figure
> out the rest later.  I sure hope that this doesn't drive most people
> on NUMA to disable pagecache interleaving right away as I expect most
> tmpfs workloads to see little to no reclaim and prefer locality... :/

Actually, I suspect most tmpfs heavy workloads will be things like
databases with shared memory segments. Those tend to benefit from
having all of the system's memory bandwidth available. The worker
threads/processes tend to live all over the system, too...

-- 
All rights reversed
