Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaHHSa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:30:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:5567 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750738AbaHHSaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:30:25 -0400
Date: Fri, 8 Aug 2014 14:30:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com, davej@redhat.com, mingo@redhat.com
Subject: Re: [PATCH] tracing: generate RCU warnings even when tracepoints
 are disabled
Message-ID: <20140808143022.5262f6cb@gandalf.local.home>
In-Reply-To: <20140807181356.GG5821@linux.vnet.ibm.com>
References: <20140807175204.C257CAC5@viggo.jf.intel.com>
	<20140807181356.GG5821@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 11:13:56 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Aug 07, 2014 at 10:52:04AM -0700, Dave Hansen wrote:
> > 
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > Dave Jones reported seeing a bug from one of my TLB tracepoints:
> > 
> > 	http://lkml.kernel.org/r/20140806181801.GA4605@redhat.com
> > 
> > I've been running these patches for months and never saw this.
> > But, a big chunk of my testing, especially with all the debugging
> > enabled, was in a vm where intel_idle doesn't work.  On the
> > systems where I was using intel_idle, I never had lockdep enabled
> > and this tracepoint on at the same time.
> > 
> > This patch ensures that whenever we have lockdep available, we do
> > _some_ RCU activity at the site of the tracepoint, despite
> > whether the tracepoint's condition matches or even if the
> > tracepoint itself is completely disabled.  This is a bit of a
> > hack, but it is pretty self-contained.
> > 
> > I confirmed that with this patch plus lockdep I get the same
> > splat as Dave Jones did, but without enabling the tracepoint
> > explicitly.
> > 
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Dave Jones <davej@redhat.com>,
> > Cc: paulmck@linux.vnet.ibm.com
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> 
> Looks good to me, but I must defer to Steven on this one.
> 

Looks fine. I can add it to my 3.18 queue.

Paul, want to send me an "Acked-by"?

Thanks,

-- Steve

