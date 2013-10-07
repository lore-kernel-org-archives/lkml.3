Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3JGSjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3JGSjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:39:42 -0400
Message-ID: <5252FFD8.2020800@redhat.com>
Date: Mon, 07 Oct 2013 14:39:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/63] sched: Update NUMA hinting faults once per scan
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-22-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-22-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> NUMA hinting fault counts and placement decisions are both recorded in the
> same array which distorts the samples in an unpredictable fashion. The values
> linearly accumulate during the scan and then decay creating a sawtooth-like
> pattern in the per-node counts. It also means that placement decisions are
> time sensitive. At best it means that it is very difficult to state that
> the buffer holds a decaying average of past faulting behaviour. At worst,
> it can confuse the load balancer if it sees one node with an artifically high
> count due to very recent faulting activity and may create a bouncing effect.
> 
> This patch adds a second array. numa_faults stores the historical data
> which is used for placement decisions. numa_faults_buffer holds the
> fault activity during the current scan window. When the scan completes,
> numa_faults decays and the values from numa_faults_buffer are copied
> across.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
