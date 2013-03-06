Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3CFKgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:36:35 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:41782 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3CFKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:36:32 -0500
Date: Wed, 6 Mar 2013 11:36:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Mansoor, Illyas" <illyas.mansoor@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, X86 <x86@kernel.org>,
        Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Rudramuni, Vishwesh M" <vishwesh.m.rudramuni@intel.com>,
        "richard@nod.at" <richard@nod.at>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        "Sil, Dyut K" <dyut.k.sil@intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: fix idle notifier not being called in CONFIG_X86_32
Message-ID: <20130306103627.GC16827@gmail.com>
References: <1362375673-29287-1-git-send-email-illyas.mansoor@intel.com>
 <20130306101818.GA6587@gmail.com>
 <810586B7581CC8469141DADEBC37191224F77316@BGSMSX102.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <810586B7581CC8469141DADEBC37191224F77316@BGSMSX102.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mansoor, Illyas <illyas.mansoor@intel.com> wrote:

> > * Illyas Mansoor <illyas.mansoor@intel.com> wrote:
> > 
> > > Idle notifier not registered if CONFIG_X86_32 is defined, those
> > > callbacks are empty for X86_32 platform.
> > >
> > > ifdef CONFIG_X86_64
> > >  void enter_idle(void);
> > >  void exit_idle(void);
> > > else
> > > static inline void enter_idle(void) { } static inline void
> > > exit_idle(void) { } static inline void __exit_idle(void) { } endif
> > >
> > > Make this work on X86_32 platforms by
> > > removing the restriction for X86_64
> > 
> > What will they be used for?
> 
> It's being used by interactive governor, and since the idle notifications are not 
> received It breaks the governor functionality on X86_32

But we never allowed idle notifiers on 32-bit and wanted to phase them out even on 
x86-64 as well.

There's ongoing work to improve power saving in the scheduler - see Alex Shi's 
patchset on lkml: I think the two pieces of code should cooperate within the 
scheduler instead of going in two directions, duplicating effort and getting in each 
other's way ...

Thanks,

	Ingo
