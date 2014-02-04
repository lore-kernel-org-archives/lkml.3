Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaBDKCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:02:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:45165 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaBDKBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:01:53 -0500
Date: Tue, 4 Feb 2014 11:01:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        galak@kernel.crashing.org, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com, agraf@suse.de,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2 1/2] time: Change the return type of clockevents_notify()
 to integer
In-Reply-To: <20140124065739.17564.97259.stgit@preeti.in.ibm.com>
Message-ID: <alpine.DEB.2.02.1402041100250.24986@ionos.tec.linutronix.de>
References: <20140124065501.17564.39363.stgit@preeti.in.ibm.com> <20140124065739.17564.97259.stgit@preeti.in.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Preeti U Murthy wrote:
> -extern void tick_broadcast_oneshot_control(unsigned long reason);
> +extern int tick_broadcast_oneshot_control(unsigned long reason);

> -static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
> +static inline int tick_broadcast_oneshot_control(unsigned long reason) { }

> -static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
> +static inline int tick_broadcast_oneshot_control(unsigned long reason) { }

The inline stubs need to return 0.

Thanks,

	tglx
