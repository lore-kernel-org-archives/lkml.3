Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3ARW7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:59:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:10111 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3ARW7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:59:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="192800771"
Date: Fri, 18 Jan 2013 14:59:40 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 03/18] perf/x86: add flags to event constraints
Message-ID: <20130118225940.GH4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1367,8 +1367,10 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
>  
>  	if (x86_pmu.event_constraints) {
>  		for_each_event_constraint(c, x86_pmu.event_constraints) {
> -			if ((event->hw.config & c->cmask) == c->code)
> +			if ((event->hw.config & c->cmask) == c->code) {
> +				event->hw.flags |= c->flags;
>  				return c;
> +			}

It's not fully clear where that hw.flags field gets initially zeroed. Is that implicit
in the allocation? Some comments would be good about its live cycle.

Or just use a = instead of |=? Why would you have multiple flags in different places?

-Andi
