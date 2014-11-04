Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaKDO2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:28:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:60271 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaKDO2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:28:47 -0500
Date: Tue, 4 Nov 2014 15:28:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        jason@lakedaemon.net, Catalin.Marinas@arm.com, Will.Deacon@arm.com,
        liviu.dudau@arm.com, Harish.Kasiviswanathan@amd.com,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
In-Reply-To: <5458E0BE.2090803@amd.com>
Message-ID: <alpine.DEB.2.11.1411041526100.4245@nanos>
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com> <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com> <alpine.DEB.2.11.1411032300160.5308@nanos> <54584681.2010103@amd.com> <alpine.DEB.2.11.1411040903340.5308@nanos>
 <5458E0BE.2090803@amd.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Suravee Suthikulpanit wrote:
> And that's what I am trying to do here except that GIC is expecting that
> information to be passed to it via irq_domain_alloc_irqs(..., args) where args
> is struct of_phandle_args (e.g. in the kernel/irqdomain.c:
> irq_create_of_mapping). This works fine when specifying interrupt from DT, but
> that is not always the case.
> 
> Currently, I can just create a fake of_phandle_args just to pass the hwirq
> information to GIC.
> 
>     --> gicv2m_setup_msi_irq()
>      |    struct of_phandle_args phan;
>      |    phan.np = NULL;
>      |    phan.args_count = 3;
>      |    phan.args[0] = 0;
>      |    phan.args[1] = hwirq - 32;
>      |    phan.args[2] = IRQ_TYPE_EDGE_RISING;
>      |--> irq_domain_alloc_irqs(d, 1, NUMA_NO_NODE, &phan);
>       |--> gicv2m_domain_alloc(d, virq, nr_irqs, arg)
> 	|--> irq_domain_alloc_irqs_parent(d, virq, nr_irqs, arg);
> 
> I am trying to figure out what would be a common data structure for this
> purpose that would work for both Dt and non-DT case (e.g. GICv2m MSI). Unless
> you think this is ok.

You need to sort that out with Marc. It needs to be done in a way
which is usable for the other potential use cases of stacked domains
on top of GIC.

Thanks,

	tglx
