Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3FRK0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:26:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38739 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab3FRK0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:26:17 -0400
Date: Tue, 18 Jun 2013 11:26:14 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v4 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
Message-ID: <20130618102614.GB1564@e102568-lin.cambridge.arm.com>
References: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1371484269-11743-3-git-send-email-lorenzo.pieralisi@arm.com>
 <alpine.LFD.2.03.1306180001410.18597@syhkavp.arg>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1306180001410.18597@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 18 Jun 2013 10:26:15.0474 (UTC) FILETIME=[434C5120:01CE6C0E]
X-MC-Unique: 113061811261500401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 05:25:22AM +0100, Nicolas Pitre wrote:
> On Mon, 17 Jun 2013, Lorenzo Pieralisi wrote:
> 
> > The TC2 versatile express core tile integrates a logic block that provides the
> > interface between the dual cluster test-chip and the M3 microcontroller that
> > carries out power management. The logic block, called Serial Power Controller
> > (SPC), contains several memory mapped registers to control among other things
> > low-power states, operating points and reset control.
> 
> [...]
> 
> I slightly modified the following before committing this patch to my TC2 
> branch:
> 
> > +/**
> > + * ve_spc_cpu_wakeup_irq()
> > + *
> > + * Function to set/clear per-CPU wake-up IRQs. Not protected by locking since
> > + * it might be used in code paths where normal cacheable locks are not
> > + * working. Locking must be provided by the caller to ensure atomicity.
> > + *
> > + * @cpu: mpidr[7:0] bitfield describing cpu affinity level
> > + * @cluster: mpidr[15:8] bitfield describing cluster affinity level
> > + * @set: if true, wake-up IRQs are set, if false they are cleared
> > + */
> > +void ve_spc_cpu_wakeup_irq(u32 cpu, u32 cluster, bool set)
> > +{
> 
> I made cluster first then cpu.  All the other functions have the cluster 
> argument first, and ve_spc_set_resume_addr() already uses that order.

Ok thanks.

> [...]
> > +#ifdef CONFIG_VEXPRESS_SPC
> > +int ve_spc_probe(void);
> > +int ve_spc_get_freq(u32 cluster);
> > +int ve_spc_set_freq(u32 cluster, u32 freq);
> > +int ve_spc_get_freq_table(u32 cluster, const u32 **fptr);
> > +void ve_spc_global_wakeup_irq(bool set);
> > +void ve_spc_cpu_wakeup_irq(u32 cpu, u32 cluster, bool set);
> > +void ve_spc_set_resume_addr(u32 cluster, u32 cpu, u32 addr);
> > +u32 ve_spc_get_nr_cpus(u32 cluster);
> > +void ve_spc_powerdown(u32 cluster, bool enable);
> > +#else
> > +static inline bool ve_spc_probe(void) { return -ENODEV; }
> 
> s/bool/int/

Bah, sorry.

Thanks a lot,
Lorenzo

