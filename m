Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3IPQJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:09:25 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37417 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3IPQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:09:22 -0400
Date: Mon, 16 Sep 2013 18:09:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel: Clean-up/reduce PEBS code
Message-ID: <20130916160921.GX18242@two.firstfloor.org>
References: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org>
 <87mwng53ki.fsf@tassilo.jf.intel.com>
 <20130916060736.GN21832@twins.programming.kicks-ass.net>
 <20130916072431.GV26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916072431.GV26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  	/*
>  	 * Should not happen, we program the threshold at 1 and do not
>  	 * set a reset value.
>  	 */
> -	WARN_ONCE(n > x86_pmu.max_pebs_events,
> -		  "Unexpected number of pebs records %d\n", n);
> +	WARN_ONCE(top - at > x86_pmu.max_pebs_events * x86_pmu.pebs_record_size,

That should work yes.

-Andi
