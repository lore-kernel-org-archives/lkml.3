Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3DMQdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 12:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab3DMQdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 12:33:39 -0400
Date: Sat, 13 Apr 2013 18:30:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Robin Holt <holt@sgi.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
	to boot cpu.)
Message-ID: <20130413163022.GA7500@redhat.com>
References: <5162EC1A.4050204@zytor.com> <20130408165916.GA3672@sgi.com> <20130410111620.GB29752@gmail.com> <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com> <20130411053106.GA9042@drongo> <5166B05E.8010904@linux.vnet.ibm.com> <20130411134837.GE3672@sgi.com> <20130412053718.GC3887@gmail.com> <5167A52F.6020503@linux.vnet.ibm.com> <20130412093149.GT3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412093149.GT3658@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Robin Holt wrote:
>
> +void migrate_to_boot_cpu(void)
> +{
> +	/* The boot cpu is always logical cpu 0 */
> +	int reboot_cpu_id = 0;
> +
> +	/* Make certain the cpu I'm about to reboot on is online */
> +	if (!cpu_online(reboot_cpu_id))
> +		reboot_cpu_id = smp_processor_id();
> +
> +	/* Make certain I only run on the appropriate processor */
> +	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));

This is only theoretical, but perhaps it makes sense to set
PF_THREAD_BOUND before set_cpus_allowed_ptr() ? To prevent the
race with another thread doing sched_setaffinity().

Oleg.

