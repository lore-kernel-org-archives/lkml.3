Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaHHSmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:42:36 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34032 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaHHSmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:42:35 -0400
Date: Fri, 8 Aug 2014 11:42:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com, davej@redhat.com, mingo@redhat.com
Subject: Re: [PATCH] tracing: generate RCU warnings even when tracepoints are
 disabled
Message-ID: <20140808184230.GE5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140807175204.C257CAC5@viggo.jf.intel.com>
 <20140807181356.GG5821@linux.vnet.ibm.com>
 <20140808143022.5262f6cb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808143022.5262f6cb@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080818-1344-0000-0000-000003570DC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 02:30:22PM -0400, Steven Rostedt wrote:
> On Thu, 7 Aug 2014 11:13:56 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Thu, Aug 07, 2014 at 10:52:04AM -0700, Dave Hansen wrote:
> > > 
> > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > > 
> > > Dave Jones reported seeing a bug from one of my TLB tracepoints:
> > > 
> > > 	http://lkml.kernel.org/r/20140806181801.GA4605@redhat.com
> > > 
> > > I've been running these patches for months and never saw this.
> > > But, a big chunk of my testing, especially with all the debugging
> > > enabled, was in a vm where intel_idle doesn't work.  On the
> > > systems where I was using intel_idle, I never had lockdep enabled
> > > and this tracepoint on at the same time.
> > > 
> > > This patch ensures that whenever we have lockdep available, we do
> > > _some_ RCU activity at the site of the tracepoint, despite
> > > whether the tracepoint's condition matches or even if the
> > > tracepoint itself is completely disabled.  This is a bit of a
> > > hack, but it is pretty self-contained.
> > > 
> > > I confirmed that with this patch plus lockdep I get the same
> > > splat as Dave Jones did, but without enabling the tracepoint
> > > explicitly.
> > > 
> > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Cc: Dave Jones <davej@redhat.com>,
> > > Cc: paulmck@linux.vnet.ibm.com
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > 
> > Looks good to me, but I must defer to Steven on this one.
> 
> Looks fine. I can add it to my 3.18 queue.
> 
> Paul, want to send me an "Acked-by"?

Here you go:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

							Thanx, Paul

