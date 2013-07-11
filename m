Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab3GKOa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:30:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab3GKOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:30:26 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=tbluxUFyrLkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kkAV0wLU1hcA:10 a=D19gQVrFAAAA:8 a=PTq3U4hPHSjgs63iyFoA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373553022.17876.11.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT 6/6] vtime: Convert vtime_seqlock into
 raw_spinlock_t and seqcount combo
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 10:30:22 -0400
In-Reply-To: <20130710171212.GA13553@windriver.com>
References: <20130626192806.107564905@goodmis.org>
	 <20130626193050.529670718@goodmis.org>
	 <20130710171212.GA13553@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 13:12 -0400, Paul Gortmaker wrote:
> [[RFC][PATCH RT 6/6] vtime: Convert vtime_seqlock into raw_spinlock_t and seqcount combo] On 26/06/2013 (Wed 15:28) Steven Rostedt wrote:
> 
> > The vtime seqlock needs to be taken in true interrupt context on -rt.
> > The normal seqlocks are converted to mutexes when PREEMPT_RT_FULL is
> > enabled, which will break the vtime code as the calls are done from
> > interrupt context.
> > 
> > Convert the vtime seqlock into the raw_spinlock_t and seqcount combo
> > that can be done in interrupt context.
> 
> Alternatively, we could revive the raw seqlock patch from Thomas?
> 
> https://lkml.org/lkml/2010/2/17/238
> 
> Below is a version updating it to 3.8.x-RT.  One downside is that
> current mainline kernels have raw_seqcount_begin() function, which has
> nothing to do with preempt-rt, so the seqcount function namespace can
> get confusing unless we rename raw_seqcount_begin to something that
> doesn't sound RT-ish.

There's a reason that Thomas didn't bring that patch forward, but I
don't recall what it was.

Thomas?

-- Steve


