Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3KVLbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:31:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43182 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3KVLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:30:58 -0500
Date: Fri, 22 Nov 2013 12:30:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
Message-ID: <20131122113044.GL10022@twins.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120162736.691879744@infradead.org>
 <528CF94E.8020300@linux.intel.com>
 <20131121101018.GX10022@twins.programming.kicks-ass.net>
 <528E09F9.9030501@linux.intel.com>
 <20131121133936.GF10022@twins.programming.kicks-ass.net>
 <528F0000.7000505@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F0000.7000505@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 08:56:00AM +0200, Eliezer Tamir wrote:
> On 21/11/2013 15:39, Peter Zijlstra wrote:
> > On Thu, Nov 21, 2013 at 03:26:17PM +0200, Eliezer Tamir wrote:
> 
> >> We don't override any limit the user has put on the system call.
> > 
> > You are in fact, note how the normal select @endtime argument is only
> > set up _after_ you're done polling. So if the syscall had a timeout of 5
> > seconds, you just blew it by 55.
> > 
> 
> That's a bug, we will fix it.

The entire thing is a bug, and if I could take away sched_clock() from
you I would, but sadly its all inlines so I can't :-(

Please use local_clock(), yes its slightly more expensive, but I doubt
you can actually measure the effects on sane hardware.
