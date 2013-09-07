Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3IGTAD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 15:00:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57720 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab3IGTAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 15:00:00 -0400
Date: Sat, 7 Sep 2013 11:59:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130907185942.GG3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
 <20130906173047.GT3966@linux.vnet.ibm.com>
 <CAMuHMdVS4jGFOuysknJ_4BcdWRrYU=7KVfO8o_gxf-pVg=5gKA@mail.gmail.com>
 <CAMuHMdXsAfo=LMF8E84_Lyhs+w5c3VKCEe7ZW5Bs7fwFV+J==w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXsAfo=LMF8E84_Lyhs+w5c3VKCEe7ZW5Bs7fwFV+J==w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090718-0320-0000-0000-000000ECA473
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 01:22:57PM +0200, Geert Uytterhoeven wrote:
> On Fri, Sep 6, 2013 at 8:50 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Fri, Sep 6, 2013 at 7:30 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> >>> Furthermore, it seems only hexagon, metag, mips, and x86 set NR_CPUS to 1
> >>> if !SMP. On other architectures, NR_CPUS is not defined and presumed to be 0.
> >>
> >> Would it make sense to require that NR_CPUS=1 for !SMP?
> >
> > Yes, this looks reasonable to me.
> 
> Perhaps we can invert the logic and define only NR_CPUS in arch-specific
> code, and derive SMP from NR_CPUS != 1 in generic code?

If we always had NR_CPUS defined, that might be a good way to go.
We would of course need acks from the various arch maintainers.  I am
guessing that we are OK for m68k.  ;-)

							Thanx, Paul

