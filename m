Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaBFLl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:41:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62995 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766AbaBFLl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:41:58 -0500
Date: Thu, 6 Feb 2014 11:41:55 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "paulus@samba.org" <paulus@samba.org>, "oleg@redhat.com" <oleg@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "walken@google.com" <walken@google.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 29/51] arm64, debug-monitors: Fix CPU hotplug callback
 registration
Message-ID: <20140206114155.GL26035@mudshark.cambridge.arm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220957.19080.79200.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220957.19080.79200.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:09:58PM +0000, Srivatsa S. Bhat wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:

[...]

> Fix the debug-monitors code in arm64 by using this latter form of callback
> registration.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/arm64/kernel/debug-monitors.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
> index 636ba8b..959a16b 100644
> --- a/arch/arm64/kernel/debug-monitors.c
> +++ b/arch/arm64/kernel/debug-monitors.c
> @@ -155,12 +155,16 @@ static struct notifier_block os_lock_nb = {
>  
>  static int debug_monitors_init(void)
>  {
> +	cpu_maps_update_begin();
> +
>  	/* Clear the OS lock. */
>  	smp_call_function(clear_os_lock, NULL, 1);
>  	clear_os_lock(NULL);
>  
>  	/* Register hotplug handler. */
> -	register_cpu_notifier(&os_lock_nb);
> +	__register_cpu_notifier(&os_lock_nb);
> +
> +	cpu_maps_update_done();
>  	return 0;
>  }
>  postcore_initcall(debug_monitors_init);

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
