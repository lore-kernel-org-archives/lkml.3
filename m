Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaETJOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:14:09 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59941 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750808AbaETJOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:14:07 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Feng Kan <fkan@apm.com>
Cc: "tglx\@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches\@apm.com" <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH 2/2] irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register
In-Reply-To: <CAL85gmByuxTdPWaDZENDz=rKQtfZc44eUaCsnK04DfeXknAoYg@mail.gmail.com>
	(Feng Kan's message of "Tue, 20 May 2014 02:26:33 +0100")
Organization: ARM Ltd
References: <1400278813-3048-1-git-send-email-fkan@apm.com>
	<1400278813-3048-3-git-send-email-fkan@apm.com>
	<878upynlz4.fsf@approximate.cambridge.arm.com>
	<CAL85gmByuxTdPWaDZENDz=rKQtfZc44eUaCsnK04DfeXknAoYg@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 20 May 2014 10:14:05 +0100
Message-ID: <87wqdg3j8i.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20 2014 at  2:26:33 am BST, Feng Kan <fkan@apm.com> wrote:
>>>  #ifdef CONFIG_CPU_PM
>>> @@ -613,7 +636,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>>                                       dist_base + GIC_DIST_PRI + i * 4);
>>>
>>>       writel_relaxed(GIC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
>>> -     writel_relaxed(GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
>>> +     gic_cpu_if_up();
>>
>> Have you tested the save/restore path? It seems that we dont save
>> GICC_CTLR, so it may not do what you think it will...
>
> We are debating which is the better method. Currently we are only
> disabling the GIC distributor so it is not a problem. Later on, with
> more aggressive PM we could have the helper core to setup the GIC CTLR
> prior to releasing out of the PM state. However, it seems it would be
> more cleaner if we save off the GIC_CTLR bits in the
> gic_cpu_save. This would add additional items in to the
> gic_chip_data. Would you be open to that?

I'm open to anything that looks reasonable and doesn't introduce
regressions. Saving/restoring the CPU interface state should be fine.

	M.
-- 
Jazz is not dead. It just smells funny.
