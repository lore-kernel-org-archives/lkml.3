Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaCFVMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:12:53 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:59172 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaCFVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:12:50 -0500
Date: Thu, 6 Mar 2014 16:12:46 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 07/11] mm, memcg: allow processes handling oom
 notifications to access reserves
Message-ID: <20140306211246.GB17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041956040.8067@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041956040.8067@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:29PM -0800, David Rientjes wrote:
> Now that a per-process flag is available, define it for processes that
> handle userspace oom notifications.  This is an optimization to avoid
> mantaining a list of such processes attached to a memcg at any given time
> and iterating it at charge time.
> 
> This flag gets set whenever a process has registered for an oom
> notification and is cleared whenever it unregisters.
> 
> When memcg reclaim has failed to free any memory, it is necessary for
> userspace oom handlers to be able to dip into reserves to pagefault text,
> allocate kernel memory to read the "tasks" file, allocate heap, etc.
> 
> System oom conditions are not addressed at this time, but the same per-
> process flag can be used in the page allocator to determine if access
> should be given to userspace oom handlers to per-zone memory reserves at
> a later time once there is consensus.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

ntil consensus on the whole approach can be reached,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
