Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBJSvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:51:19 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50149 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaBJSvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:51:17 -0500
Date: Tue, 11 Feb 2014 00:20:56 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 16/51] x86, vsyscall: Fix CPU hotplug callback
 registration
Message-ID: <20140210185056.GB3416@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220727.19080.71911.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220727.19080.71911.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021018-0320-0000-0000-0000026D8025
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 06, 2014 at 03:37:27AM +0530, Srivatsa S. Bhat wrote:
> @@ -393,9 +393,13 @@ static int __init vsyscall_init(void)
>  {
>  	BUG_ON(VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE));
> 
> +	cpu_maps_update_begin();
> +
>  	on_each_cpu(cpu_vsyscall_init, NULL, 1);
>  	/* notifier priority > KVM */
> -	hotcpu_notifier(cpu_vsyscall_notifier, 30);
> +	__hotcpu_notifier(cpu_vsyscall_notifier, 30);

While we're at it, we could also #define the VSYSCALL_PRIO relative to
KVM_PRIO instead of hard-coding the value here, no ?

> +
> +	cpu_maps_update_done();
> 
>  	return 0;
>  }
> 

