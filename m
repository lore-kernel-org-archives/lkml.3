Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab3EWMoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:44:09 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:59354 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756862Ab3EWMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:44:07 -0400
X-Greylist: delayed 7159 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 08:44:07 EDT
Message-ID: <519E0F13.4080208@overkiz.com>
Date: Thu, 23 May 2013 14:44:03 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com> <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com> <20130523101825.GL18614@n2100.arm.linux.org.uk> <20130523141344.7a01ce88@skate>
In-Reply-To: <20130523141344.7a01ce88@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1134062683090417770
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2013 14:13, Thomas Petazzoni wrote:
> Dear Russell King - ARM Linux,
>
> On Thu, 23 May 2013 11:18:25 +0100, Russell King - ARM Linux wrote:
>
>> I notice arch/arm/mach-at91/pm.c makes use of some of the register
>> definitions:
>>
>>          at91_irq_suspend();
>>
>>          pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
>>                          /* remember all the always-wake irqs */
>>                          (at91_pmc_read(AT91_PMC_PCSR)
>>                                          | (1 << AT91_ID_FIQ)
>>                                          | (1 << AT91_ID_SYS)
>>                                          | (at91_extern_irq))
>>                                  & at91_aic_read(AT91_AIC_IMR),
>>                          state);
>>
>> at91_irq_suspend() is in arch/arm/mach-at91/irq.c already, so there's no
>> reason that fragment can't be moved there.
> The problem is that the goal of the patch set is to move
> arch/arm/mach-at91/irq.c into drivers/irqchip/.
>
> However, if you move that chunk of code to drivers/irqchip/irq-at91.c,
> you are using at91_pmc_read() which is defined in
> arch/arm/mach-at91/include/mach/at91_pmc.h. So,
> drivers/irqchip/irq-at91.c would have to include such an header file,
> which is something we want to avoid since drivers/ code should not
> include something in <mach/...>, as it breaks multiplatform kernels.
>
> So, I'm afraid, simply moving this chunk of code in at91_irq_suspend()
> doesn't make the thing any better.
What about keeping the former at91_aic.h in arch/arm/match-at91 and copy 
the definitions we need in drivers/irqchip/irq-at91.c ?

This way we get an aic irqchip driver independant of any specific 
machine headers and keep the non dt boards and pm drivers without any 
change.
>
> Best regards,
>
> Thomas

