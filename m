Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbaGIXDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:03:32 -0400
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:45917 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756790AbaGIXDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140708224732.GK13433@titan.lakedaemon.net>
References: <1404335939-31754-1-git-send-email-fkan@apm.com>
	<1404335939-31754-2-git-send-email-fkan@apm.com>
	<20140708224732.GK13433@titan.lakedaemon.net>
Date: Wed, 9 Jul 2014 16:03:29 -0700
Message-ID: <CAL85gmC2DPnDXR3m+BEE44JN1h0+trVCmR3Et2w4y-MZxcJtyg@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] irqchip: gic: replace hex numbers with defines.
From: Feng Kan <fkan@apm.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 3:47 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> Feng,
>
> On Wed, Jul 02, 2014 at 02:18:58PM -0700, Feng Kan wrote:
>> This is to cleanup some hex numbers used in the code and replace
>> then with defines to make the code cleaner.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> Reviewed-by: Anup Patel <apatel@apm.com>
>> ---
>>  drivers/irqchip/irq-gic.c       | 62 ++++++++++++++++++++++++++++-------------
>>  include/linux/irqchip/arm-gic.h |  2 --
>>  2 files changed, 43 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 7e11c9d..9ec3f4c 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -48,6 +48,23 @@
>>
>>  #include "irqchip.h"
>>
>> +#define GIC_DIST_ENABLE                      0x1
>> +#define GIC_DIST_DISABLE             0x0
>> +#define GIC_DIST_INT_CLR_EN_32               0xffffffff
>> +#define GIC_DIST_INT_SET_EN_SGI              0x0000ffff
>> +#define GIC_DIST_INT_CLR_EN_PPI              0xffff0000
>
> Please watch your whitespace here...
>
>> +#define GIC_DIST_INT_LVL_TRIGGER     0x0
>> +#define GIC_DIST_INT_DEF_PRI         0xa0
>> +#define GIC_DIST_INT_DEF_PRI_4               ((GIC_DIST_INT_DEF_PRI << 24) |\
>> +                                     (GIC_DIST_INT_DEF_PRI << 16) |\
>> +                                     (GIC_DIST_INT_DEF_PRI << 8) |\
>> +                                     GIC_DIST_INT_DEF_PRI)
>> +
>> +#define GIC_CPU_ENABLE                       0x1
>
> And here.

I am not sure what you mean here, I have listed the listings below.  Do you
mean the extra line or tab?
+#define GIC_DIST_ENABLE^I^I^I0x1$
+#define GIC_DIST_DISABLE^I^I0x0$
+#define GIC_DIST_INT_CLR_EN_32^I^I0xffffffff$
+#define GIC_DIST_INT_SET_EN_SGI^I^I0x0000ffff$
+#define GIC_DIST_INT_CLR_EN_PPI^I^I0xffff0000$
+#define GIC_DIST_INT_LVL_TRIGGER^I0x0$
+#define GIC_DIST_INT_DEF_PRI^I^I0xa0$
+#define GIC_DIST_INT_DEF_PRI_4^I^I((GIC_DIST_INT_DEF_PRI << 24) |\$
+^I^I^I^I^I(GIC_DIST_INT_DEF_PRI << 16) |\$
+^I^I^I^I^I(GIC_DIST_INT_DEF_PRI << 8) |\$
+^I^I^I^I^IGIC_DIST_INT_DEF_PRI)$
+$
+#define GIC_CPU_ENABLE^I^I^I0x1$
+#define GIC_CPU_INT_PRI_THRESHOLD^I0xf0$
+#define GIC_CPU_INT_SPURIOUS^I^I1023$
+#define GIC_CPU_INT_ID_MASK^I^I0x3ff$
+$
>
> I imagine quite a few of these magic numbers were cleaned up in Marc's
> series adding GICv3.  Please see my response to your coverletter.
Thanks, I am basing off that right now. Not sure if you want the defines in the
common.h or only placed in the file that they affect.

>
> thx,
>
> Jason.
>
>> +#define GIC_CPU_INT_PRI_THRESHOLD    0xf0
>> +#define GIC_CPU_INT_SPURIOUS         1023
>> +#define GIC_CPU_INT_ID_MASK          0x3ff
>> +
>>  union gic_base {
>>       void __iomem *common_base;
>>       void __percpu * __iomem *percpu_base;
>> @@ -291,7 +308,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>>
>>       do {
>>               irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
>> -             irqnr = irqstat & GICC_IAR_INT_ID_MASK;
>> +             irqnr = irqstat & GIC_CPU_INT_ID_MASK;
>>
>>               if (likely(irqnr > 15 && irqnr < 1021)) {
>>                       irqnr = irq_find_mapping(gic->domain, irqnr);
>> @@ -322,8 +339,8 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
>>       status = readl_relaxed(gic_data_cpu_base(chip_data) + GIC_CPU_INTACK);
>>       raw_spin_unlock(&irq_controller_lock);
>>
>> -     gic_irq = (status & 0x3ff);
>> -     if (gic_irq == 1023)
>> +     gic_irq = (status & GIC_CPU_INT_ID_MASK);
>> +     if (gic_irq == GIC_CPU_INT_SPURIOUS)
>>               goto out;
>>
>>       cascade_irq = irq_find_mapping(chip_data->domain, gic_irq);
>> @@ -384,13 +401,14 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>>       unsigned int gic_irqs = gic->gic_irqs;
>>       void __iomem *base = gic_data_dist_base(gic);
>>
>> -     writel_relaxed(0, base + GIC_DIST_CTRL);
>> +     writel_relaxed(GIC_DIST_DISABLE, base + GIC_DIST_CTRL);
>>
>>       /*
>>        * Set all global interrupts to be level triggered, active low.
>>        */
>>       for (i = 32; i < gic_irqs; i += 16)
>> -             writel_relaxed(0, base + GIC_DIST_CONFIG + i * 4 / 16);
>> +             writel_relaxed(GIC_DIST_INT_LVL_TRIGGER,
>> +                             base + GIC_DIST_CONFIG + i * 4 / 16);
>>
>>       /*
>>        * Set all global interrupts to this CPU only.
>> @@ -405,16 +423,18 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>>        * Set priority on all global interrupts.
>>        */
>>       for (i = 32; i < gic_irqs; i += 4)
>> -             writel_relaxed(0xa0a0a0a0, base + GIC_DIST_PRI + i * 4 / 4);
>> +             writel_relaxed(GIC_DIST_INT_DEF_PRI_4,
>> +                                     base + GIC_DIST_PRI + i * 4 / 4);
>>
>>       /*
>>        * Disable all interrupts.  Leave the PPI and SGIs alone
>>        * as these enables are banked registers.
>>        */
>>       for (i = 32; i < gic_irqs; i += 32)
>> -             writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
>> +             writel_relaxed(GIC_DIST_INT_CLR_EN_32,
>> +                             base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
>>
>> -     writel_relaxed(1, base + GIC_DIST_CTRL);
>> +     writel_relaxed(GIC_DIST_ENABLE, base + GIC_DIST_CTRL);
>>  }
>>
>>  static void gic_cpu_init(struct gic_chip_data *gic)
>> @@ -443,17 +463,20 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>        * Deal with the banked PPI and SGI interrupts - disable all
>>        * PPI interrupts, ensure all SGI interrupts are enabled.
>>        */
>> -     writel_relaxed(0xffff0000, dist_base + GIC_DIST_ENABLE_CLEAR);
>> -     writel_relaxed(0x0000ffff, dist_base + GIC_DIST_ENABLE_SET);
>> +     writel_relaxed(GIC_DIST_INT_CLR_EN_PPI,
>> +                     dist_base + GIC_DIST_ENABLE_CLEAR);
>> +     writel_relaxed(GIC_DIST_INT_SET_EN_SGI,
>> +                     dist_base + GIC_DIST_ENABLE_SET);
>>
>>       /*
>>        * Set priority on PPI and SGI interrupts
>>        */
>>       for (i = 0; i < 32; i += 4)
>> -             writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>> +             writel_relaxed(GIC_DIST_INT_DEF_PRI_4,
>> +                             dist_base + GIC_DIST_PRI + i * 4 / 4);
>>
>> -     writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>> -     writel_relaxed(1, base + GIC_CPU_CTRL);
>> +     writel_relaxed(GIC_CPU_INT_PRI_THRESHOLD, base + GIC_CPU_PRIMASK);
>> +     writel_relaxed(GIC_CPU_ENABLE, base + GIC_CPU_CTRL);
>>  }
>>
>>  void gic_cpu_if_down(void)
>> @@ -519,14 +542,14 @@ static void gic_dist_restore(unsigned int gic_nr)
>>       if (!dist_base)
>>               return;
>>
>> -     writel_relaxed(0, dist_base + GIC_DIST_CTRL);
>> +     writel_relaxed(GIC_DIST_DISABLE, dist_base + GIC_DIST_CTRL);
>>
>>       for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
>>               writel_relaxed(gic_data[gic_nr].saved_spi_conf[i],
>>                       dist_base + GIC_DIST_CONFIG + i * 4);
>>
>>       for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
>> -             writel_relaxed(0xa0a0a0a0,
>> +             writel_relaxed(GIC_DIST_INT_DEF_PRI_4,
>>                       dist_base + GIC_DIST_PRI + i * 4);
>>
>>       for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
>> @@ -537,7 +560,7 @@ static void gic_dist_restore(unsigned int gic_nr)
>>               writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
>>                       dist_base + GIC_DIST_ENABLE_SET + i * 4);
>>
>> -     writel_relaxed(1, dist_base + GIC_DIST_CTRL);
>> +     writel_relaxed(GIC_DIST_ENABLE, dist_base + GIC_DIST_CTRL);
>>  }
>>
>>  static void gic_cpu_save(unsigned int gic_nr)
>> @@ -591,10 +614,11 @@ static void gic_cpu_restore(unsigned int gic_nr)
>>               writel_relaxed(ptr[i], dist_base + GIC_DIST_CONFIG + i * 4);
>>
>>       for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
>> -             writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
>> +             writel_relaxed(GIC_DIST_INT_DEF_PRI_4,
>> +                                     dist_base + GIC_DIST_PRI + i * 4);
>>
>> -     writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
>> -     writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
>> +     writel_relaxed(GIC_CPU_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
>> +     writel_relaxed(GIC_CPU_ENABLE, cpu_base + GIC_CPU_CTRL);
>>  }
>>
>>  static int gic_notifier(struct notifier_block *self, unsigned long cmd,      void *v)
>> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
>> index 45e2d8c..7ed92d0 100644
>> --- a/include/linux/irqchip/arm-gic.h
>> +++ b/include/linux/irqchip/arm-gic.h
>> @@ -21,8 +21,6 @@
>>  #define GIC_CPU_ACTIVEPRIO           0xd0
>>  #define GIC_CPU_IDENT                        0xfc
>>
>> -#define GICC_IAR_INT_ID_MASK         0x3ff
>> -
>>  #define GIC_DIST_CTRL                        0x000
>>  #define GIC_DIST_CTR                 0x004
>>  #define GIC_DIST_IGROUP                      0x080
>> --
>> 1.9.1
>>
