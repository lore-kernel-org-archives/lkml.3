Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaAJJiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:38:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaAJJiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:38:04 -0500
Date: Fri, 10 Jan 2014 10:37:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf: clarify comment regarding perf_pmu_contexts
Message-ID: <20140110093748.GJ31570@twins.programming.kicks-ass.net>
References: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
 <1389311492-5059-4-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389311492-5059-4-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:51:32PM -0800, Cody P Schafer wrote:
> Again, note that the behavior of task_ctx_nr < 0 is an exception.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  kernel/events/core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index e9f60d0..159ef12 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6276,8 +6276,9 @@ static int perf_event_idx_default(struct perf_event *event)
>  }
>  
>  /*
> - * Ensures all contexts with the same task_ctx_nr have the same
> - * pmu_cpu_context too.
> + * Ensures all contexts with the same task_ctx_nr (where that task_ctx_nr
> + * is >=0) have the same pmu_cpu_context too. Contexts with with negative (<0)
> + * task_ctx_nr do not share pmu_cpu_contexts.
>   */

Please stay within the enum name space; the <0 really is an
implementation detail, mostly done because testing for sign is often
cheaper than an immediate comparison.
