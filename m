Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3HAFP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:15:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58883 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3HAFPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:15:25 -0400
Date: Thu, 1 Aug 2013 10:43:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] sched: Retry migration of tasks to CPU on a
 preferred node
Message-ID: <20130801051327.GF4880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-18-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1373901620-2021-18-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080105-3620-0000-0000-000003C5C99F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mel Gorman <mgorman@suse.de> [2013-07-15 16:20:19]:

> When a preferred node is selected for a tasks there is an attempt to migrate
> the task to a CPU there. This may fail in which case the task will only
> migrate if the active load balancer takes action. This may never happen if

Apart from load imbalance or heavily loaded cpus on the preferred node,
what could be the other reasons for migration failure with
migrate_task_to()? I see it almost similar to active load balance except
for pushing instead of pulling tasks.

If load imbalance is the only reason, do we need to retry? If the task
is really so attached to memory on that node, shouldn't we getting
task_numa_placement hit before the next 5 seconds? 

> the conditions are not right. This patch will check at NUMA hinting fault
> time if another attempt should be made to migrate the task. It will only
> make an attempt once every five seconds.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

-- 
Thanks and Regards
Srikar Dronamraju

