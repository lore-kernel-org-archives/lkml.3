Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3LBSAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:00:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:46054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3LBSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:00:34 -0500
Date: Mon, 2 Dec 2013 19:00:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
        arnd@arndb.de, linux-pm@vger.kernel.org, rostedt@goodmis.org,
        michael@ellerman.id.au, john.stultz@linaro.org,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V4 7/9] cpuidle/powernv: Add "Fast-Sleep" CPU idle
 state
In-Reply-To: <529CA219.20109@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1312021859440.30673@ionos.tec.linutronix.de>
References: <20131129104010.651.23117.stgit@preeti.in.ibm.com> <20131129104319.651.29563.stgit@preeti.in.ibm.com> <alpine.DEB.2.02.1311291301300.30673@ionos.tec.linutronix.de> <529CA219.20109@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Preeti U Murthy wrote:
> On 11/29/2013 08:09 PM, Thomas Gleixner wrote:
> > This supports HIGHRES and NO_HZ if done right, without polling at
> > all. So you can even let the last CPU which handles the broadcast
> > hrtimer go for a long sleep, just not in the deepest idle state.
> 
> Thank you for the review. The above points are all valid. I will rework
> the design to:
> 
> 1. Eliminate the concept of a broadcast CPU and integrate its
> functionality in the timekeeping CPU.
> 
> 2. Avoid polling by using IPIs to communicate the next wakeup of the
> CPUs in deep idle state so as to reprogram the broadcast hrtimer.
> 
> 3. Make this feature generic and not arch-specific.

Great. If you need help with the generic bits, please let me know.

Thanks,

	tglx
