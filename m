Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab3LKJOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:14:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab3LKJOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:14:25 -0500
Date: Wed, 11 Dec 2013 09:14:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 7/8] sched/numa: fix record hinting faults check
Message-ID: <20131211091422.GU11295@suse.de>
References: <1386723001-25408-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386723001-25408-8-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1386723001-25408-8-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 08:50:00AM +0800, Wanpeng Li wrote:
> Adjust numa_scan_period in task_numa_placement, depending on how much useful
> work the numa code can do. The local faults and remote faults should be used
> to check if there is record hinting faults instead of local faults and shared
> faults. This patch fix it.
> 
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

This potentially has the side-effect of making it easier to reduce the
scan rate because it'll only take the most recent scan window into
account. The existing code takes recent shared accesses into account.
What sort of tests did you do on this patch and what was the result?

-- 
Mel Gorman
SUSE Labs
