Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaBJS7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:59:32 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:37739 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaBJS7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:59:31 -0500
Date: Tue, 11 Feb 2014 00:28:43 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 24/51] x86, hpet: Fix CPU hotplug callback registration
Message-ID: <20140210185843.GC3416@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220859.19080.7550.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220859.19080.7550.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021018-0928-0000-0000-000006750A9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 06, 2014 at 03:39:00AM +0530, Srivatsa S. Bhat wrote:
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index da85a8e..199aaae 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -943,12 +943,14 @@ static __init int hpet_late_init(void)
>  	if (boot_cpu_has(X86_FEATURE_ARAT))
>  		return 0;
> 
> +	cpu_maps_update_begin();
>  	for_each_online_cpu(cpu) {
>  		hpet_cpuhp_notify(NULL, CPU_ONLINE, (void *)(long)cpu);
>  	}
> 
>  	/* This notifier should be called after workqueue is ready */
> -	hotcpu_notifier(hpet_cpuhp_notify, -20);
> +	__hotcpu_notifier(hpet_cpuhp_notify, -20);

We could #define HPET_CPUHP_PRIO relative to the workqueue priority instead of
hardcoding this it this way.


--
Thanks and Regards
gautham.

