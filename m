Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaB1RHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:07:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbaB1RHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:07:48 -0500
Message-ID: <5310C231.5000503@redhat.com>
Date: Fri, 28 Feb 2014 12:06:57 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: smp_call_function_single with wait=0 considered harmful
References: <20131204164627.GA27677@infradead.org> <20140228122624.GF9987@twins.programming.kicks-ass.net> <20140228123905.GK3104@twins.programming.kicks-ass.net>
In-Reply-To: <20140228123905.GK3104@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 07:39 AM, Peter Zijlstra wrote:

> Subject: stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()
> 
> We must use smp_call_function_single(.wait=1) for the
> irq_cpu_stop_queue_work() to ensure the queueing is actually done under
> stop_cpus_lock. Without this we could have dropped the lock by the time
> we do the queueing and get the race we tried to fix.
> 
> Fixes: 7053ea1a34fa ("stop_machine: Fix race between stop_two_cpus() and stop_cpus()")
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
