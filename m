Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaKJUuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:50:37 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49060 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaKJUug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:50:36 -0500
Date: Mon, 10 Nov 2014 20:50:31 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141110205031.GE1292@console-pimps.org>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107121803.GC3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107121803.GC3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov, at 01:18:03PM, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 12:23:21PM +0000, Matt Fleming wrote:
> > +	/*
> > +	 * Test whether an RMID is free for each package.
> > +	 */
> > +	preempt_disable();
> > +	smp_call_function_many(&cqm_cpumask, intel_cqm_stable, NULL, true);
> > +	preempt_enable();
> 
> Same problem again, the current cpu is not included.
> 
> Ah, just found we have on_each_cpu_mask(), which is what you want.

Aha, yes, that looks useful. Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
