Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaBJPyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:54:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaBJPyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:54:19 -0500
Date: Mon, 10 Feb 2014 16:53:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, rusty@rustcorp.com.au, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH 19/51] x86, therm_throt.c: Fix CPU hotplug callback
	registration
Message-ID: <20140210155323.GA8911@redhat.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220759.19080.36356.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220759.19080.36356.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Srivatsa S. Bhat wrote:
>
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -319,7 +319,7 @@ static __init int thermal_throttle_init_device(void)
>  	if (!atomic_read(&therm_throt_en))
>  		return 0;
>
> -	register_hotcpu_notifier(&thermal_throttle_cpu_notifier);
> +	cpu_maps_update_begin();
>
>  #ifdef CONFIG_HOTPLUG_CPU
>  	mutex_lock(&therm_cpu_lock);
> @@ -333,6 +333,9 @@ static __init int thermal_throttle_init_device(void)
>  	mutex_unlock(&therm_cpu_lock);
>  #endif
>
> +	__register_hotcpu_notifier(&thermal_throttle_cpu_notifier);
> +	cpu_maps_update_done();


Off-topic, but it seems that after this change therm_cpu_lock can die.
Of course this needs another patch (if I am right).

Oleg.

