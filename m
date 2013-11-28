Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3K1GMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:12:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31699 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863Ab3K1GMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:12:09 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 27 Nov 2013 22:12:31 -0800
Subject: RE: [PATCH 2/2 v2] irqchip: mmp: add dt support for wakeup
Thread-Topic: [PATCH 2/2 v2] irqchip: mmp: add dt support for wakeup
Thread-Index: Ac7iATdEqkgNUrYbSfqNh6vwUe3MPAJ/qTCQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE4F8DD2CB40@SC-VEXCH4.marvell.com>
References: <1381479838-7794-1-git-send-email-zhangwm@marvell.com>
 <1381479838-7794-3-git-send-email-zhangwm@marvell.com>
 <CAN1soZwPVCNO5V33mP4yn-n=fye2LX-3XCYYG+Z1zw0Q6VVm4g@mail.gmail.com>
 <20131114122733.GJ16396@e106331-lin.cambridge.arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE49FD2839AB@SC-VEXCH4.marvell.com>
 <20131115125004.GI1709@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131115125004.GI1709@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-11-28_02:2013-11-28,2013-11-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311270270
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAS6CJ7d025837

Mark,

Sorry for reply late.

> -----Original Message-----
> From: Mark Rutland [mailto:mark.rutland@arm.com]
> Sent: 2013å¹´11æœˆ15æ—¥ 20:50
> To: Neil Zhang
> Cc: Haojian Zhuang; devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> Thomas Gleixner
> Subject: Re: [PATCH 2/2 v2] irqchip: mmp: add dt support for wakeup
> 
> On Fri, Nov 15, 2013 at 11:49:20AM +0000, Neil Zhang wrote:
> >
> > > -----Original Message-----
> > > From: Mark Rutland [mailto:mark.rutland@arm.com]
> > > Sent: 2013å¹´11æœˆ14æ—¥ 20:28
> > > To: Haojian Zhuang
> > > Cc: Neil Zhang; devicetree@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; Thomas Gleixner
> > > Subject: Re: [PATCH 2/2 v2] irqchip: mmp: add dt support for wakeup
> > >
> > > On Thu, Nov 14, 2013 at 10:28:53AM +0000, Haojian Zhuang wrote:
> > > > On Fri, Oct 11, 2013 at 4:23 PM, Neil Zhang <zhangwm@marvell.com>
> wrote:
> > > > > Some of the Marvell SoCs use GIC as its interrupt controller,and
> > > > > ICU only used as wakeup logic. When AP subsystem is powered off,
> > > > > GIC will lose its context, the PMU will need ICU to wakeup the AP
> subsystem.
> > > > > So add wakeup entry for such kind of usage.
> > > > >
> > > > > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > > > > ---
> > > > >  .../devicetree/bindings/arm/mrvl/intc.txt          |   14 ++-
> > > > >  drivers/irqchip/irq-mmp.c                          |  124
> > > ++++++++++++++++++++
> > > > >  include/linux/irqchip/mmp.h                        |   13 ++
> > > > >  3 files changed, 150 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > > b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > > index 8b53273..4180928 100644
> > > > > --- a/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > > +++ b/Documentation/devicetree/bindings/arm/mrvl/intc.txt
> > > > > @@ -2,7 +2,7 @@
> > > > >
> > > > >  Required properties:
> > > > >  - compatible : Should be "mrvl,mmp-intc", "mrvl,mmp2-intc" or
> > > > > -  "mrvl,mmp2-mux-intc"
> > > > > +  "mrvl,mmp2-mux-intc", "mrvl,mmp-intc-wakeupgen"
> > >
> > > Why do we need a new compatible string?
> >
> > As the patch comments said, we don't use the ICU as an interrupt
> > controller in some Marvell Socs, Just use them to wakeup CPU when GIC is
> powered off.
> 
> Hmm. Is it possible to use the ICU as an interrupt controller in those SoCs?

No, we have to use GIC as an interrupt controller since they are SMP system.

> 
> >
> > >
> > > > >  - reg : Address and length of the register set of the interrupt controller.
> > > > >    If the interrupt controller is intc, address and length means the range
> > > > >    of the whold interrupt controller. If the interrupt
> > > > > controller is mux-intc, @@ -15,6 +15,9 @@ Required properties:
> > > > >  - interrupt-controller : Identifies the node as an interrupt controller.
> > > > >  - #interrupt-cells : Specifies the number of cells needed to encode an
> > > > >    interrupt source.
> > > > > +- mrvl,intc-gbl-mask : Specifies the address and value for
> > > > > +global mask in the
> > > > > +  interrupt controller.
> > > >
> > > > As my understanding, we should avoid to write register settings in DTS file.
> > >
> > > In general, yes. We should describe the hardware and let Linux
> > > choose how to configure it as far as possible.
> > >
> > > What is this global mask? What is it used for? Why do there seem to
> > > be multiple global masks (judging by the example)?
> > >
> >
> > Global mask will prevent distributing interrupt from ICU to GIC.
> > Since we will use GIC as the interrupt controller, so we need to mask the ICU
> global mask.
> > ICU has connection to every core in the system, so we need to mask all global
> mask registers for each core.
> 
> Why can the driver not figure out these masks for itself?

Different SoCs will have different global mask registers, so it's not suitable to hard code in driver.

> 
> >
> > > >
> > > > Loop devicetree guys.
> > > >
> > > > > +- mrvl,intc-for-cp : Specifies the irqs that will be routed to
> > > > > +cp
> > >
> > > cp?
> > >
> > > _why_ do we need this, and what exactly does routing the irqs to the cp
> imply?
> >
> > Communication processor.
> > Kernel should avoid to handle the irq lines that has been routed to
> communication processor.
> 
> Ok. Does this just tell the kernel the set of IRQs to ignore, or does this imply that
> the kernel must configure something in the hardware based on this? If so, what
> specifically?
> 

As the patch did, we need to configure it to cp when init and kernel will ignore to change them in runtime.

> >
> > >
> > > > >  - mrvl,intc-nr-irqs : Specifies the number of interrupts in the interrupt
> > > > >    controller.
> > > > >  - mrvl,clr-mfp-irq : Specifies the interrupt that needs to
> > > > > clear MFP edge @@ -39,6 +42,15 @@ Example:
> > > > >                 mrvl,intc-nr-irqs = <2>;
> > > > >         };
> > > > >
> > > > > +     intc: wakeupgen@d4282000 {
> > > > > +               compatible = "mrvl,mmp-intc-wakeupgen";
> > > > > +               reg = <0xd4282000 0x1000>;
> > > > > +               mrvl,intc-nr-irqs = <64>;
> > > > > +               mrvl,intc-gbl-mask = <0x114 0x3
> > > > > +                                     0x144 0x3>;
> > >
> > > Are these multiple entries? The binding text implied there was only one entry.
> > > What is this?
> >
> > This specify the register offset and value to mask for each core.
> 
> Why can the driver not have these offsets hard-coded? How variable are they?

As I said above, different SoCs will have different global mask registers,
It's not suitable to hard code in driver.

> 
> [...]
> 
> > > > > +       size /= sizeof(*wakeup_reg);
> > > > > +       while (i < size) {
> > > > > +               unsigned offset, val;
> > > > > +
> > > > > +               offset = be32_to_cpup(wakeup_reg + i++);
> > > > > +               val = be32_to_cpup(wakeup_reg + i++);
> > >
> > > Use of_property_read_u32_index. You don't need to deal with the raw dtb.
> >
> > It's offset / value pair, it there convenient way to get such kind of key / value
> pair?
> > Thanks.
> 
> Unfortunately there's no of_property_read_u32_array_index, but it's perfectly
> possible to do something similar to what you have here, without relying on the
> raw binary DTB:
> 
> for (;;) {
> 	u32 offset, val;
> 	if (of_property_read_u32_index(node, PROP_NAME, i++, &offset) != 0)
> 		break;
> 	if (of_property_read_u32_index(node, PROP_NAME, i++, &val) != 0)
> 		break;
> 
> 	do_something(offset, val);
> }
> 
Thanks very much, I'll change to use this way.

> >
> > >
> > > > > +               writel_relaxed(val, mmp_icu_base + offset);
> > > > > +       }
> > > > > +
> > > > > +       /* Get the irq lines and ignore irqs */
> > > > > +       cp_irq_reg = of_get_property(node, "mrvl,intc-for-cp", &size);
> > > > > +       if (!cp_irq_reg)
> > > > > +               return;
> > > > > +
> > > > > +       irq_for_cp_nr = size / sizeof(*cp_irq_reg);
> > > > > +       for (i = 0; i < irq_for_cp_nr; i++) {
> > > > > +               irq_for_cp[i] = be32_to_cpup(cp_irq_reg + i);
> > >
> > > Use of_property_read_u32_index.
> >
> > Yes, it should be OK, thanks very much.
> 
> Cheers,
> Mark.

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
