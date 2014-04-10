Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965890AbaDJKqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:46:44 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20888 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965541AbaDJKqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:46:42 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Chanho Park <chanho61.park@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "t.figa\@samsung.com" <t.figa@samsung.com>,
        "hyunhee.kim\@samsung.com" <hyunhee.kim@samsung.com>,
        "sw0312.kim\@samsung.com" <sw0312.kim@samsung.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yj44.cho\@samsung.com" <yj44.cho@samsung.com>,
        "inki.dae\@samsung.com" <inki.dae@samsung.com>,
        "kyungmin.park\@samsung.com" <kyungmin.park@samsung.com>,
        "kgene.kim\@samsung.com" <kgene.kim@samsung.com>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/27] irqchip: Declare cortex-a7's irqchip to initialize gic from dt
In-Reply-To: <002e01cf54a8$d59897e0$80c9c7a0$@samsung.com> (Chanho Park's
	message of "Thu, 10 Apr 2014 11:37:12 +0100")
Organization: ARM Ltd
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
	<1397122124-15690-8-git-send-email-cw00.choi@samsung.com>
	<878urd33g4.fsf@approximate.cambridge.arm.com>
	<002e01cf54a8$d59897e0$80c9c7a0$@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 10 Apr 2014 11:46:39 +0100
Message-ID: <87vbuh1my8.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10 2014 at 11:37:12 am BST, Chanho Park <chanho61.park@samsung.com> wrote:
> Hi,
>
>> -----Original Message-----
>> From: linux-arm-kernel [mailto:linux-arm-kernel-
>> bounces@lists.infradead.org] On Behalf Of Marc Zyngier
>> Sent: Thursday, April 10, 2014 7:05 PM
>> To: Chanwoo Choi
>> Cc: mark.rutland@arm.com; linux-samsung-soc@vger.kernel.org;
>> t.figa@samsung.com; hyunhee.kim@samsung.com; sw0312.kim@samsung.com;
>> linux-kernel@vger.kernel.org; yj44.cho@samsung.com; inki.dae@samsung.com;
>> kyungmin.park@samsung.com; kgene.kim@samsung.com; Thomas Gleixner;
>> linux-arm-kernel@lists.infradead.org
>> Subject: Re: [PATCH 07/27] irqchip: Declare cortex-a7's irqchip to
>> initialize gic from dt
>> 
>> On Thu, Apr 10 2014 at 10:28:24 am BST, Chanwoo Choi
>> <cw00.choi@samsung.com> wrote:
>> > This patch declare coretex-a7's irqchip to initialze gic from dt
>> > with "arm,cortex-a7-gic" data.
>> >
>> > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> > ---
>> >  drivers/irqchip/irq-gic.c | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> > index 4300b66..8e906e4 100644
>> > --- a/drivers/irqchip/irq-gic.c
>> > +++ b/drivers/irqchip/irq-gic.c
>> > @@ -1069,6 +1069,7 @@ gic_of_init(struct device_node *node, struct
>> device_node *parent)
>> >  }
>> >  IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
>> >  IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
>> > +IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
>> >  IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
>> >  IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
>> 
>> Frankly, this patch adds no value. Are we going to add
>> "arm,cortex-a12-gic", "arm,cortex-a17-gic", "arm,cortex-a53-gic",
>> "arm,cortex-a57-gic"? And that's just to mention the ARM Ltd cores...
>> 
>> Instead, how about defining a generic "arm,gic" property, and mandate
>> that new DT files are using that? We can always use a more precise
>> compatible for quirks.
>
> I prefer it would be arm,gicv2 instead arm-gic.

If you prefer, fine by me. Consider spelling it "arm,gic-v2", which
seems to be the current convention for version numbers.

> In case of GICv3 of arm64, it can be arm,gicv3.

GICv3 and arm64 are independent of each other, and the binding has
already been specified as "arm,gic-v3".

	M.
-- 
Jazz is not dead. It just smells funny.
