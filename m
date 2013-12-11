Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3LKOvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:51:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3LKOvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:51:04 -0500
Date: Wed, 11 Dec 2013 09:50:28 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386773428-bwklwan0-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20131211092123.GV11295@suse.de>
References: <1386723001-25408-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386723001-25408-9-git-send-email-liwanp@linux.vnet.ibm.com>
 <20131211092123.GV11295@suse.de>
Subject: Re: [PATCH v5 8/8] sched/numa: drop unnecessary variable in
 task_weight
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20131211092123.GV11295@suse.de>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 09:21:23AM +0000, Mel Gorman wrote:
> On Wed, Dec 11, 2013 at 08:50:01AM +0800, Wanpeng Li wrote:
> > Drop unnecessary total_faults variable in function task_weight to unify
> > task_weight and group_weight.
> > 
> > Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> 
> Nak.
> 
> task_weight is called for tasks other than current. If p handles a fault
> in parallel then it can drop to 0 between when it's checked and used to
> divide resulting in an oops.

So we have the same race on group_weight(), and we have to add a local
variable to store p->numa_group->total_faults?

Thanks,
Naoya Horiguchi
