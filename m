Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaHOJpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:45:47 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50449 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbaHOJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:45:45 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Sudeep Holla <sudeep.holla@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 15 Aug 2014 02:45:09 -0700
Subject: RE: [PATCH] arm: irq: fix the affinity when migrate a irq
Thread-Topic: [PATCH] arm: irq: fix the affinity when migrate a irq
Thread-Index: Ac+4ZQqgOmi7NuOFRViXEqfdQAAQ1wACHiOw
Message-ID: <9034CBD80F070943B59700D7F8149ED9020D8CC38A@SC-VEXCH4.marvell.com>
References: <1408087917-22603-1-git-send-email-zhangwm@marvell.com>
 <53EDC89F.4020300@arm.com>
In-Reply-To: <53EDC89F.4020300@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-15_03:2014-08-14,2014-08-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408150117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7F9jqmN032711



> -----Original Message-----
> From: Sudeep Holla [mailto:sudeep.holla@arm.com]
> Sent: 2014Äê8ÔÂ15ÈÕ 16:45
> To: Neil Zhang; linux@arm.linux.org.uk
> Cc: Sudeep Holla; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] arm: irq: fix the affinity when migrate a irq
> 
> Hi Neil,
> 
> On 15/08/14 08:31, Neil Zhang wrote:
> > Commit ffde1de64012 ("irqchip: Gic: Support forced affinity setting")
> > has enable the forcing cpu affinity of interrupts for gic.
> >
> > The current code of migrate_one_irq will pass the current affinity
> > mask to irq_set_affinity with force is true, it may select the cpu
> > being offlined as the target CPU again, then the interrupt won't be
> > migrated correctly.
> >
> 
> I had posted similar patch [1] a while ago and the discussion[2] did not
> conclude. We need feedback from Thomas Gleixner.
> 
> Regards,
> Sudeep
> 
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/254838.html
> [2]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265191.html

I see, thanks.

> 
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >   arch/arm/kernel/irq.c |    5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c index
> > 2c42576..6f5a878 100644
> > --- a/arch/arm/kernel/irq.c
> > +++ b/arch/arm/kernel/irq.c
> > @@ -167,11 +167,10 @@ static bool migrate_one_irq(struct irq_desc *desc)
> >   	if (irqd_is_per_cpu(d) || !cpumask_test_cpu(smp_processor_id(), affinity))
> >   		return false;
> >
> > -	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
> > -		affinity = cpu_online_mask;
> > +	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids)
> >   		ret = true;
> > -	}
> >
> > +	affinity = cpu_online_mask;
> >   	c = irq_data_get_irq_chip(d);
> >   	if (!c->irq_set_affinity)
> >   		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
> >

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
