Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaBKQob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:44:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:6589 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbaBKQoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:44:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,826,1384329600"; 
   d="scan'208";a="481659378"
Message-ID: <52FA5366.3020007@linux.intel.com>
Date: Tue, 11 Feb 2014 08:44:22 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86/nmi: Push duration printk() to irq context
References: <tip-rdw0au56a5ymis1u8p48c12d@git.kernel.org> <52F9021C.1030801@linux.intel.com> <20140211150116.GO27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140211150116.GO27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 07:01 AM, Peter Zijlstra wrote:
> -	irq_work_queue(&perf_duration_work);
> +	if (!irq_work_queue(&perf_duration_work)) {
> +		early_printk("perf interrupt took too long (%lld > %lld), lowering "
> +			     "kernel.perf_event_max_sample_rate to %d\n",
> +			     avg_local_sample_len, allowed_ns >> 1,
> +			     sysctl_perf_event_sample_rate);
> +	}
>  }

That's a cool trick.  Works for me.
