Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3JGRnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab3JGRnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:43:14 -0400
Message-ID: <5252F2A1.4040204@redhat.com>
Date: Mon, 07 Oct 2013 13:42:57 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/63] Revert "mm: sched: numa: Delay PTE scanning until
 a task is scheduled on a new node"
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-16-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-16-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:28 AM, Mel Gorman wrote:
> PTE scanning and NUMA hinting fault handling is expensive so commit
> 5bca2303 ("mm: sched: numa: Delay PTE scanning until a task is scheduled
> on a new node") deferred the PTE scan until a task had been scheduled on
> another node. The problem is that in the purely shared memory case that
> this may never happen and no NUMA hinting fault information will be
> captured. We are not ruling out the possibility that something better
> can be done here but for now, this patch needs to be reverted and depend
> entirely on the scan_delay to avoid punishing short-lived processes.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
