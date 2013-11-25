Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3KYRxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:53:34 -0500
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:51316 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753997Ab3KYRxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:53:33 -0500
MIME-Version: 1.0
In-Reply-To: <529316D3.8030301@arm.com>
References: <1384897358-22940-1-git-send-email-fkan@apm.com>
	<528C95D2.5090200@arm.com>
	<CAAhSdy2e_zmVEBsKLOC0DjHLL=dxDn9g4vV7sfs0jfSmPvEOow@mail.gmail.com>
	<529316D3.8030301@arm.com>
Date: Mon, 25 Nov 2013 09:53:32 -0800
Message-ID: <CAL85gmCf9EW_fq=oYwL1Zz7CrqK5gD-47PxFA7dCPze1_G0fCQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] irq-gic: add capability to set bypass flag in GIC
From: Feng Kan <fkan@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Anup Patel <anup@brainfault.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Vinayak Kale <vinayak.kale@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "Kumar, Satendra" <Satendra.Kumar@lsi.com>, Loc Ho <lho@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> The Legacy-IRQ bypass disable and Legacy-FIQ bypass disable is a
>> feature of GIC-400 and its not X-Gene specific. The only difference in X-Gene
>> is that we use PPI31 (Legacy-IRQ) for timer and PPI28 (Legacy-FIQ) for perf
>
> Amazing. Someone managed to push the weird-o-meter one level higher.
> Were you *that* short on PPIs that you had to use these two?

We don't support bypass enable at all, nothing to do with the PPI. It must be
set to bypass disable always for us. Those two are the unfortunate victims.

>
>> event. The issue is that IRQBypDisGrp0, FIQBypDisGrp0, IRQBypDisGrp1
>> and FIQBypDisGrp1 bits are 0 by default and for X-Gene we need to set
>> these bits to 1 so that GIC-400 does not bypass PPI31 (Legacy-IRQ) and
>> PPI28 (Legacy-FIQ).
>>
>> We should have more cleaner and optional device tree binding for GIC
>> which can help us set IRQBypDisGrp0, FIQBypDisGrp0, IRQBypDisGrp1
>> and FIQBypDisGrp1 bits for X-Gene.
>
> Well, here's an alternative approach for you. As you said, this is in no
> way X-Gene specific, so maybe we should address it directly in the GIC
> code. Just hook something in the irq_mask/irq_unmask methods, so we can
> detect the use of these two PPIs, and toggle the bypass flags
> accordingly bits accordingly.

Yes, I hope Catalin could comment on this one. I don't think he would like this
as well since it is our platform specific.

>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
