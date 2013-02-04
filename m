Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3BDQe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:34:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3BDQez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:34:55 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ahUY3ffXF30A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=oZrvqZDRve4A:10 a=20KFwNOVAAAA:8 a=oyBUEGRHBUGe4ifzOBUA:9 a=PUjeQqilurYA:10 a=c_8uTHk3LtgA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359995693.5642.62.camel@gandalf.local.home>
Subject: Re: [PATCH 6/6] uprobes/perf: Always increment trace_uprobe->nhit
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 11:34:53 -0500
In-Reply-To: <20130204162611.GB28145@linux.vnet.ibm.com>
References: <20130131191752.GA30410@redhat.com>
	 <20130131191832.GA30457@redhat.com>
	 <20130204111711.GB12900@linux.vnet.ibm.com>
	 <20130204151850.GA6641@redhat.com>
	 <20130204162611.GB28145@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 21:56 +0530, Srikar Dronamraju wrote:
> * Oleg Nesterov <oleg@redhat.com> [2013-02-04 16:18:50]:
> 
> > On 02/04, Srikar Dronamraju wrote:
> > >
> > > * Oleg Nesterov <oleg@redhat.com> [2013-01-31 20:18:32]:
> > >
> > > > Move tu->nhit++ from uprobe_trace_func() to uprobe_dispatcher().
> > > >
> > > > ->nhit counts how many time we hit the breakpoint inserted by this
> > > > uprobe, we do not want to loose this info if uprobe was enabled by
> > > > sys_perf_event_open().
> > > >
> > >
> > > Though I dont see a problem with this change, It seems unnecessary for
> > > me.
> > >
> > > Info from nhits is mostly for /sys/kernel/debug/tracing/uprobe_profile
> > 
> > It is only for uprobe_profile, yes, and it is useful. Why should we hide
> > this info if this uprobe is used by perf?
> 
> Fine with me.
> 
> Steve, Masami, Do you have comments/suggestions on this. 

I have no problem with the change.

> (Since kprobe_profile just accounts for kprobetracer and doesnt account
> for perf record.)
> May we should make a similar change in kprobetracer to keep things
> similar.

I'm fine either way.

-- Steve


