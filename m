Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaDYJET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:04:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaDYJEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:04:16 -0400
Date: Fri, 25 Apr 2014 10:04:12 +0100
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched,numa: count pages on active node as local
Message-ID: <20140425090412.GA23991@suse.de>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
 <1397235629-16328-2-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1397235629-16328-2-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:00:27PM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> The NUMA code is smart enough to distribute the memory of workloads
> that span multiple NUMA nodes across those NUMA nodes.
> 
> However, it still has a pretty high scan rate for such workloads,
> because any memory that is left on a node other than the node of
> the CPU that faulted on the memory is counted as non-local, which
> causes the scan rate to go up.
> 
> Counting the memory on any node where the task's numa group is
> actively running as local, allows the scan rate to slow down
> once the application is settled in.
> 
> This should reduce the overhead of the automatic NUMA placement
> code, when a workload spans multiple NUMA nodes.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Tested-by: Vinod Chegu <chegu_vinod@hp.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
