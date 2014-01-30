Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaA3SHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:07:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaA3SHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:07:32 -0500
Date: Thu, 30 Jan 2014 19:06:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/6] idle: move the cpuidle entry point to the generic
 idle loop
Message-ID: <20140130180659.GI5002@laptop.programming.kicks-ass.net>
References: <1391017513-12995-1-git-send-email-nicolas.pitre@linaro.org>
 <1391017513-12995-2-git-send-email-nicolas.pitre@linaro.org>
 <alpine.LFD.2.11.1401291526320.1652@knanqh.ubzr>
 <52E9C946.50704@linux.vnet.ibm.com>
 <alpine.LFD.2.11.1401300021530.1652@knanqh.ubzr>
 <52EA5720.8010000@linaro.org>
 <alpine.LFD.2.11.1401301056180.1652@knanqh.ubzr>
 <52EA8BD4.6020803@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EA8BD4.6020803@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 06:28:52PM +0100, Daniel Lezcano wrote:
> Ok, I think the mess is coming from 'default_idle' which does not re-enable
> the local_irq but used from different places like amd_e400_idle and
> apm_cpu_idle.
> 
> void default_idle(void)
> {
>         trace_cpu_idle_rcuidle(1, smp_processor_id());
>         safe_halt();
>         trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> }
> 
> Considering the system configured without cpuidle because this one *always*
> enable the local irq, we have the different cases:
> 
> x86_idle = default_idle();
> ==> local_irq_enable is missing
> 

safe_halt() is "sti; hlt" and so very much does the irq_enable.
