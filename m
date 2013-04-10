Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935787Ab3DJAVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:21:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53573 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765442Ab3DJAVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:21:22 -0400
Message-ID: <5164AEF5.9020202@zytor.com>
Date: Tue, 09 Apr 2013 17:14:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        kernel-hardening@lists.openwall.com,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
Subject: Re: [PATCH v2] x86: use fixed read-only IDT
References: <20130409163932.GA19130@www.outflux.net>
In-Reply-To: <20130409163932.GA19130@www.outflux.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 09:39 AM, Kees Cook wrote:
> -
>  static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
>  {
>  	/* calling is from identify_secondary_cpu() ? */
> @@ -206,8 +192,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  	/*
>  	 * All current models of Pentium and Pentium with MMX technology CPUs
>  	 * have the F0 0F bug, which lets nonprivileged users lock up the
> -	 * system.
> -	 * Note that the workaround only should be initialized once...
> +	 * system. Announce that the fault handler will be checking for it.
>  	 */
>  	c->f00f_bug = 0;
>  	if (!paravirt_enabled() && c->x86 == 5) {
> @@ -215,7 +200,6 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  
>  		c->f00f_bug = 1;
>  		if (!f00f_workaround_enabled) {
> -			trap_init_f00f_bug();
>  			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
>  			f00f_workaround_enabled = 1;
>  		}

Why do we care about this message anymore?  It provides no relevant user
information, the flag itself is already in /proc/cpuinfo, and the
message is likely to be wrong since all it does is look for an Intel CPU
with family == 5.

	-hpa


