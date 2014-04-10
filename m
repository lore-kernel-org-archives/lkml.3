Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935471AbaDJKar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:30:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48453 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933885AbaDJKap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:30:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 07/27] irqchip: Declare cortex-a7's irqchip to initialize gic from dt
From: armdev <armdev.ftm@gmail.com>
In-Reply-To: <874n2132o8.fsf@approximate.cambridge.arm.com>
Date: Thu, 10 Apr 2014 16:00:41 +0530
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "hyunhee.kim@samsung.com" <hyunhee.kim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yj44.cho@samsung.com" <yj44.cho@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <254FD85F-0C8E-4D16-8207-5BA4E7FBDE65@gmail.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com> <1397122124-15690-8-git-send-email-cw00.choi@samsung.com> <878urd33g4.fsf@approximate.cambridge.arm.com> <C136A675-6D64-42EE-918E-351A266946C5@gmail.com> <874n2132o8.fsf@approximate.cambridge.arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10-Apr-2014, at 3:51 pm, Marc Zyngier <marc.zyngier@arm.com> wrote:

> On Thu, Apr 10 2014 at 11:09:02 am BST, armdev <armdev.ftm@gmail.com> wrote:
>> On 10-Apr-2014, at 3:34 pm, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> 
>>> On Thu, Apr 10 2014 at 10:28:24 am BST, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>> This patch declare coretex-a7's irqchip to initialze gic from dt
>>>> with "arm,cortex-a7-gic" data.
>>>> 
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>> drivers/irqchip/irq-gic.c | 1 +
>>>> 1 file changed, 1 insertion(+)
>>>> 
>>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>>> index 4300b66..8e906e4 100644
>>>> --- a/drivers/irqchip/irq-gic.c
>>>> +++ b/drivers/irqchip/irq-gic.c
>>>> @@ -1069,6 +1069,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>>>> }
>>>> IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
>>>> IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
>>>> +IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
>>>> IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
>>>> IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
>>> 
>>> Frankly, this patch adds no value. Are we going to add
>>> "arm,cortex-a12-gic", "arm,cortex-a17-gic", "arm,cortex-a53-gic",
>>> "arm,cortex-a57-gic"? And that's just to mention the ARM Ltd cores...
>>> 
>>> Instead, how about defining a generic "arm,gic" property, and mandate
>>> that new DT files are using that? We can always use a more precise
>>> compatible for quirks.
>>> 
>> 
>> How about keeping it simple and tied to arm gic versions
>> arm,gicv1, arm,gicv2, arm,gicv2ve
> 
> That's a variation on the same theme. As for GICv2, we don't need to
> distinguish between having the Virtualization Extentions, the binding
> already allows you to tell one from the other.
> 
So if there be just 2 types of gic, it would be simple.
gicv1 - 2 address sets (gicc and gicd)
gicv2 - 4 sets (gicc gicd gicv gich) and 1 maintenance interrupt. Right?

> 	M.
> -- 
> Jazz is not dead. It just smells funny.

