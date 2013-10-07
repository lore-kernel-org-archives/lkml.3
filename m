Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3JGSoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:44:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3JGSoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:44:16 -0400
Message-ID: <525300EE.8020505@redhat.com>
Date: Mon, 07 Oct 2013 14:43:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 27/63] mm: numa: Scan pages with elevated page_mapcount
References: <1381141781-10992-1-git-send-email-mgorman@suse.de> <1381141781-10992-28-git-send-email-mgorman@suse.de>
In-Reply-To: <1381141781-10992-28-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 06:29 AM, Mel Gorman wrote:
> Currently automatic NUMA balancing is unable to distinguish between false
> shared versus private pages except by ignoring pages with an elevated
> page_mapcount entirely. This avoids shared pages bouncing between the
> nodes whose task is using them but that is ignored quite a lot of data.
> 
> This patch kicks away the training wheels in preparation for adding support
> for identifying shared/private pages is now in place. The ordering is so
> that the impact of the shared/private detection can be easily measured. Note
> that the patch does not migrate shared, file-backed within vmas marked
> VM_EXEC as these are generally shared library pages. Migrating such pages
> is not beneficial as there is an expectation they are read-shared between
> caches and iTLB and iCache pressure is generally low.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
