Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaAJJfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:35:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaAJJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:35:21 -0500
Date: Fri, 10 Jan 2014 10:34:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf: comment on usage of perf_invalid_context
Message-ID: <20140110093458.GH31570@twins.programming.kicks-ass.net>
References: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
 <1389311492-5059-2-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389311492-5059-2-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:51:30PM -0800, Cody P Schafer wrote:
> Context numbers less than 0 are treated specially within the events
> code, add a comment to document this.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  include/linux/sched.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 53f97eb..f574820 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1033,6 +1033,10 @@ struct sched_rt_entity {
>  struct rcu_node;
>  
>  enum perf_event_task_context {
> +	/*
> +	 * When <0, allocate a pmu local pmu->pmu_cpu_context (instead
> +	 * of sharing among pmus in the same context) and forbid task tracking.
> +	 */

Please explain things in terms of the existing enum names; we don't want
people to start using randon negative values instead of
'perf_invalid_context'.

>  	perf_invalid_context = -1,
>  	perf_hw_context = 0,
>  	perf_sw_context,
> -- 
> 1.8.5.2
> 
