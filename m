Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBMRpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaBMRpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:45:41 -0500
Date: Thu, 13 Feb 2014 18:44:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Toshi Kani <toshi.kani@hp.com>, paulus@samba.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
	callback registration functions
Message-ID: <20140213174452.GB14455@redhat.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <1392081980.5612.123.camel@misato.fc.hp.com> <52F9ED11.5010800@linux.vnet.ibm.com> <20140211171553.GA26036@redhat.com> <52FA7539.4030907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA7539.4030907@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12, Srivatsa S. Bhat wrote:
>
> On 02/11/2014 10:45 PM, Oleg Nesterov wrote:
> >
> > I am a bit confused... If we do this, why we can't simply turn
> > cpu_add_remove_lock into rw_semaphore?

[...snip...]

> 	cpu_notifier_register_begin();                |  Run in parallel
>                                                       |  with similar phases
> 	for_each_online_cpu(cpu)                      |  from other subsystems.
> 		init_cpu(cpu);                        |
>
> 	/* Updates the cpu notifier chain. */
> 	register_cpu_notifier(&foobar_cpu_notifier); ||| -- Must run serially

Ah indeed, we can't use a single lock, thanks. Perhaps we can simply
add a spinlock_t which only protects cpu_chain though, but I am not
sure and currently this is off-topic anyway.

Thanks,

Oleg.

