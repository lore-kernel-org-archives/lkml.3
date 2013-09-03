Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418Ab3ICWrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:47:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54298 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760899Ab3ICWrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:47:53 -0400
Date: Tue, 3 Sep 2013 18:47:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: larmbr <nasa4836@gmail.com>
Cc: linux-mm@kvack.org, mhocko@suse.cz, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan : use vmcan_swappiness( ) basing on
 MEMCG config to elimiate unnecessary runtime cost
Message-ID: <20130903224731.GC1412@cmpxchg.org>
References: <20130826133658.GA357@larmbr-lcx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826133658.GA357@larmbr-lcx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 09:36:58PM +0800, larmbr wrote:
> Currently, we get the vm_swappiness via vmscan_swappiness(), which
> calls global_reclaim() to check if this is a global reclaim. 
> 
> Besides, the current implementation of global_reclaim() always returns 
> true for the !CONFIG_MEGCG case, and judges the other case by checking 
> whether scan_control->target_mem_cgroup is null or not.
> 
> Thus, we could just use two versions of vmscan_swappiness() based on 
> MEMCG Kconfig , to eliminate the unnecessary run-time cost for 
> the !CONFIG_MEMCG at all, and to squash all memcg-related checking
> into the CONFIG_MEMCG version.

The compiler can easily detect that global_reclaim() always returns
true for !CONFIG_MEMCG during compile time and not even generate a
branch for this.

> 2 files changed, 12 insertions(+), 3 deletions(-)

You're adding more code for now gain.
