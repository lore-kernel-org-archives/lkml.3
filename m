Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3JRLzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:55:03 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49795 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab3JRLy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:54:58 -0400
Date: Fri, 18 Oct 2013 04:54:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Message-ID: <20131018115451.GM31306@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131015163906.342d8ffa@gandalf.local.home>
 <20131016114036.GB12773@localhost.localdomain>
 <20131016084518.44eaf61a@gandalf.local.home>
 <20131016130856.GE12773@localhost.localdomain>
 <20131016193632.GH4553@linux.vnet.ibm.com>
 <20131016155730.7fd55ac5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016155730.7fd55ac5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101811-7182-0000-0000-000008CB0F28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:57:30PM -0400, Steven Rostedt wrote:
> On Wed, 16 Oct 2013 12:36:32 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> 
> > > Ah but we have an in_interrupt() check in context_tracking_user_enter() that protects
> > > us against that.
> > 
> > Here you are relying on the exception being treated as an interrupt,
> > correct?
> 
> I don't think so. It's relying on nmi_enter() also makes in_interrupt()
> return true.

Got it, never mind!

							Thanx, Paul

> Like I said before. An NMI interrupting userspace should be no
> different than an interrupt interrupting userspace. They both can
> trigger vmalloc faults, and we should be able to deal with it.
> 
> -- Steve
> 

