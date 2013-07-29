Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3G2OPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:15:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52084 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3G2OPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:15:01 -0400
Date: Mon, 29 Jul 2013 15:14:55 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Rik van Riel <riel@redhat.com>,
        Jeremy Eder <jeder@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "youquan.song@intel.com" <youquan.song@intel.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
Message-ID: <20130729141455.GA9590@e102568-lin.cambridge.arm.com>
References: <20130726173306.GB17985@jeder.rdu.redhat.com>
 <51F2BC31.7000407@redhat.com>
 <51F2BF8C.7010308@linux.intel.com>
 <51F2C014.90102@redhat.com>
 <51F37290.5050101@linaro.org>
 <51F66A5A.9060901@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51F66A5A.9060901@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Jul 2013 14:14:58.0508 (UTC) FILETIME=[01CCE0C0:01CE8C66]
X-MC-Unique: 113072915145901701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 02:12:58PM +0100, Arjan van de Ven wrote:
> >
> > The menu governor tries to deduce the next wakeup but based on events
> > per cpu. That means if a task with a specific behavior is migrated
> > across cpus, the statistics will be wrong.
> 
> 
> btw this is largely a misunderstanding;
> tasks are not the issue; tasks use timers and those are perfectly predictable.
> It's interrupts that are not and the heuristics are for that.
> 
> Now, if your hardware does the really-bad-for-power wake-all on any interrupt,
> then the menu governor logic is not good for you; rather than looking at the next
> timer on the current cpu you need to look at the earliest timer on the set of bundled
> cpus as the upper bound of the next wake event.

Yes, that's true and we have to look into this properly, but certainly
a wake-up for a CPU in a package C-state is not beneficial to x86 CPUs either,
or I am missing something ?

Even if the wake-up interrupts just power up one of the CPUs in a package
and leave other(s) alone, all HW state shared (ie caches) by those CPUs must
be turned on. What I am asking is: this bundled next event is a concept
that should apply to x86 CPUs too, or it is entirely managed in FW/HW
and the kernel just should not care ?

I still do not understand how this "bundled" next event is managed on
x86 with the menu governor, or better why it is not managed at all, given
the importance of package C-states.

> And maybe even more special casing is needed... but I doubt it.

I lost you here, can you elaborate pls ?

Thanks a lot,
Lorenzo

