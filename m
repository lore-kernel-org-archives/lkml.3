Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3BFNVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:21:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3BFNVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:21:30 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Bp3_fu7e2UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIfm1DkAj9kA:10 a=uYVGJH5IAAAA:8 a=TP7dVeSyjimTlQAVxQcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360156888.2621.42.camel@gandalf.local.home>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Wed, 06 Feb 2013 08:21:28 -0500
In-Reply-To: <5111F6F6.7010402@candelatech.com>
References: <5111AD8D.1080005@candelatech.com>
	   <20130206015430.GA9161@home.goodmis.org>
	  <5111BF51.5010607@candelatech.com>
	  <1360119124.2621.37.camel@gandalf.local.home>
	  <5111CE60.4080403@candelatech.com>
	 <1360125419.2621.39.camel@gandalf.local.home>
	 <5111F6F6.7010402@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 22:23 -0800, Ben Greear wrote:
> On 02/05/2013 08:36 PM, Steven Rostedt wrote:
> > On Tue, 2013-02-05 at 19:30 -0800, Ben Greear wrote:
> >
> >> It's huge, so here's a link:
> >>
> >> http://www.candelatech.com/~greearb/debug.tgz
> >>
> >
> > The trace shows that __netif_receive_skb() is grabbing an
> > rcu_read_lock() but never releasing it. But I don't see any possible way
> > that can be true in the code.
> >
> > Can you apply the following patch and run the trace again. I'd like to
> > see if the code is going in the path I expect it is.
> 
> I'll look at this in detail tomorrow.  I have a few patches in dev.c code, maybe
> I merged something badly....

I wish you told me that in the beginning. That you modified the core
code. In that case I would have asked to see your modifications before
anything else.

I'm 99% sure that the bug is in your modifications.

-- Steve


