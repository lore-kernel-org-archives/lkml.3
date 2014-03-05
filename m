Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaCENCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:02:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51149 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaCENCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:02:40 -0500
Date: Wed, 5 Mar 2014 14:02:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
Message-ID: <20140305130224.GQ3104@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
 <20140228160526.GD1133@krava.brq.redhat.com>
 <tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
 <20140305111415.GU9987@twins.programming.kicks-ass.net>
 <20140305072022.6f69f699@gandalf.local.home>
 <20140305122535.GA9987@twins.programming.kicks-ass.net>
 <20140305073344.2f179931@gandalf.local.home>
 <20140305125421.GB9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305125421.GB9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:54:21PM +0100, Peter Zijlstra wrote:
> On Wed, Mar 05, 2014 at 07:33:44AM -0500, Steven Rostedt wrote:
> > Then we better make sure that __do_page_fault() is never inlined.
> > Otherwise, it wont be available to trace.
> > 
> > I'm fine with adding "notrace" to do_page_fault() and to
> > trace_do_page_fault() as long as we also include a "noinline" to
> > __do_page_fault(). Would need a comment stating why that noinline is
> > there though.
> 
> When CONFIG_TRACING there's two callers, which makes it highly unlikely
> GCC would inline the massive __do_page_fault() function, but sure.
> 
> How about something like so then; still has the normal_do_page_fault()
> thing, although I suppose we could drop that.
> 
> It also puts trace_page_fault_entries() and trace_do_page_fault() under
> CONFIG_TRACING. I could only find the entry_32.S user; I suppose the
> 64bit one is hidden by CPP goo somewhere?

> +trace_errorentry page_fault normal_do_page_fault

ah found it; its in there. That also means the normal_do_page_fault()
thing won't actually compile proper.

Lemme do one with that.
