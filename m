Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaCEMeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:34:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28428 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753850AbaCEMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:33:48 -0500
Date: Wed, 5 Mar 2014 07:33:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
Message-ID: <20140305073344.2f179931@gandalf.local.home>
In-Reply-To: <20140305122535.GA9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
	<20140228160526.GD1133@krava.brq.redhat.com>
	<tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
	<20140305111415.GU9987@twins.programming.kicks-ass.net>
	<20140305072022.6f69f699@gandalf.local.home>
	<20140305122535.GA9987@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014 13:25:35 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Mar 05, 2014 at 07:20:22AM -0500, Steven Rostedt wrote:
> > On Wed, 5 Mar 2014 12:14:15 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > Please no! I used tracing of the do_page_fault function all the time.
> > It is very useful.
> 
> Why do you trace do_page_fault and not the __do_page_fault() function?
> do_page_fault() is a minimal wrapper which doesn't actually do all that
> much?

Then we better make sure that __do_page_fault() is never inlined.
Otherwise, it wont be available to trace.

I'm fine with adding "notrace" to do_page_fault() and to
trace_do_page_fault() as long as we also include a "noinline" to
__do_page_fault(). Would need a comment stating why that noinline is
there though.

-- Steve
