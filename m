Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3JGTFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:05:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab3JGTFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:05:13 -0400
Message-ID: <525305D6.2020205@redhat.com>
Date: Mon, 07 Oct 2013 15:04:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 35/63] sched: numa: Do not trap hinting faults for shared
 libraries
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-36-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-36-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> NUMA hinting faults will not migrate a shared executable page mapped by
> multiple processes on the grounds that the data is probably in the CPU
> cache already and the page may just bounce between tasks running on multipl
> nodes. Even if the migration is avoided, there is still the overhead of
> trapping the fault, updating the statistics, making scheduler placement
> decisions based on the information etc. If we are never going to migrate
> the page, it is overhead for no gain and worse a process may be placed on
> a sub-optimal node for shared executable pages. This patch avoids trapping
> faults for shared libraries entirely.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>
-- 
All rights reversed
