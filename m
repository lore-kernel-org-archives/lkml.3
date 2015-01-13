Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbbAMKuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:50:14 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32813 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbbAMKuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:50:12 -0500
Message-ID: <54B4F857.3050909@arm.com>
Date: Tue, 13 Jan 2015 10:49:59 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiang Liu <jiang.liu@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] genirq: Make irqchip flags work with stacked irq
 domains
References: <1420738365-22063-1-git-send-email-marc.zyngier@arm.com> <54AF45E0.2080803@linux.intel.com> <54AFA4EE.5080906@arm.com> <alpine.DEB.2.11.1501131140540.17382@nanos>
In-Reply-To: <alpine.DEB.2.11.1501131140540.17382@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/15 10:41, Thomas Gleixner wrote:
> On Fri, 9 Jan 2015, Marc Zyngier wrote:
>> Hi Jiang,
>>
>> On 09/01/15 03:07, Jiang Liu wrote:
>>> On 2015/1/9 1:32, Marc Zyngier wrote:
>>>> With the landing of stacked irq domains in 3.19, we have ended up in a
>>>> situation where we have a stack of IRQ controllers, each with their
>>>> set of flags, but the core code is only able to look at the top-most,
>>>> which is not very helpful. This small series is trying to fix this.
>>>>
>>>> The first patch converts all access to desc->irq_data.chip->flags to
>>>> using an accessor, without changing anything else. The second patch
>>>> adds some logic to combine these flags as we allocate the interrupts,
>>>> ultimately storing the resulting set as part of the irq_desc
>>>> structure.
>>>>
>>>> We end-up with a configuration where the flags can either be located
>>>> in the irq_chip structure (non stacked case), or in the irq_desc
>>>> (stacked case). While this isn't really ideal, this gives at least the
>>>> right level of information to the rest of the IRQ framework.
>>> Hi Mark,
>>> 	By this way, we need to aggregate irq_chip flags for every
>>> irq. How about changing irq_desc_get_chip_flags(struct irq_desc *desc)
>>> to irq_desc_check_chip_flags(struct irq_desc *desc, unsigned int flags)
>>> which dynamically walks the stacked irqchips?
>>
>> That was the other option, but I felt that going through the list of
>> irqchips was not a very nice idea performance wise. This is used is some
>> moderately hot paths (cond_unmask_eoi_irq, for example), and I wondered
>> if we wanted to pay this price at runtime...
> 
> We rather do it at setup time.

That was my thought as well. I'll respin the series with Jiang's fix.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
