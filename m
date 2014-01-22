Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaAVSn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:43:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37581 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaAVSnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:43:24 -0500
Date: Wed, 22 Jan 2014 19:42:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122184253.GN30183@twins.programming.kicks-ass.net>
References: <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
 <20140122104532.GJ31570@twins.programming.kicks-ass.net>
 <20140122120048.GB389@x4>
 <20140122120757.GL31570@twins.programming.kicks-ass.net>
 <20140122122609.GA392@x4>
 <20140122123022.GN31570@twins.programming.kicks-ass.net>
 <20140122131456.GA389@x4>
 <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122183538.GA389@x4>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 07:35:38PM +0100, Markus Trippelsdorf wrote:

> >FYI it happens on real hardware on my machine:

> >[   60.375384] process: using AMD E400 aware idle routine

> But this is a different issue. I've bisected it to:
> 
> commit 20d1c86a57762f0a33a78988e3fc8818316badd4
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Nov 29 15:40:29 2013 +0100
> 
>     sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs
> 
> Reverting the commit "fixes" the issue:

Hurm.. what kind of AMD machine is that?
