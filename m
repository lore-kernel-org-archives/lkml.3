Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab3LKJVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:21:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab3LKJV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:21:27 -0500
Date: Wed, 11 Dec 2013 09:21:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 8/8] sched/numa: drop unnecessary variable in
 task_weight
Message-ID: <20131211092123.GV11295@suse.de>
References: <1386723001-25408-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386723001-25408-9-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1386723001-25408-9-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 08:50:01AM +0800, Wanpeng Li wrote:
> Drop unnecessary total_faults variable in function task_weight to unify
> task_weight and group_weight.
> 
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Nak.

task_weight is called for tasks other than current. If p handles a fault
in parallel then it can drop to 0 between when it's checked and used to
divide resulting in an oops.

-- 
Mel Gorman
SUSE Labs
