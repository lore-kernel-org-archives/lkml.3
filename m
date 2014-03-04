Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaCDXl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:41:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:29957 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755035AbaCDXl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:41:26 -0500
Date: Tue, 4 Mar 2014 18:41:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Closing on the CR2 leak bug
Message-ID: <20140304184112.0a3fe811@gandalf.local.home>
In-Reply-To: <531654D8.5040409@zytor.com>
References: <531654D8.5040409@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2014 14:34:00 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> So we need to get something into x86/urgent for the CR2 bug.
> 
> It seems like a no-brainer to do the hoisting patch, for which I prefer
> the version proposed by Jiri Olsa which reads %cr2 and then passes it to
> __do_page_fault() in a GPR:
> 
> http://lkml.kernel.org/r/20140228160526.GD1133@krava.brq.redhat.com
> 
> As fart as I can tell this should fix Vince's problem as well.
> 
> Anyone who objects to this?  Otherwise I will put it in tip:x86/urgent
> tomorrow.
> 
> Do we need any more refinements this late in the -rc cycle?
> 

The only other issue is if perf traces from function context and traces
the trace_do_page_fault() call. But other than that, sure, take Jiri's
patch.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Please also add the reported/tested-by from Vince Weaver and add a
Link: to the other thread, as it got pretty detailed there too.


 -- Steve
