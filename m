Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaJTIrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:47:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16471 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513AbaJTIrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:47:00 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Will Deacon <will.deacon@arm.com>
CC: Sudeep Holla <Sudeep.Holla@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>
Date: Mon, 20 Oct 2014 01:46:17 -0700
Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac+W6EbkGB3bNyaoSLKxhFXhC8yOLxVWaUKA
Message-ID: <9034CBD80F070943B59700D7F8149ED9024EB81CD8@SC-VEXCH4.marvell.com>
References: <20140423170821.GJ5649@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
 <5360FB07.5030407@arm.com>
 <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
 <20140513184503.GF16388@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
 <537337F3.4080300@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A0875776@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED90182308172@SC-VEXCH4.marvell.com>
 <20140703175706.GI17372@arm.com>
In-Reply-To: <20140703175706.GI17372@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-20_01:2014-10-17,2014-10-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410200092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9K8lA3t023094



> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: 2014Äê7ÔÂ4ÈÕ 1:57
> To: Neil Zhang
> Cc: Sudeep Holla; 'linux@arm.linux.org.uk'; 'linux-arm-
> kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org';
> 'devicetree@vger.kernel.org'
> Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm
> notifier
> 
> On Mon, Jun 30, 2014 at 11:39:15AM +0100, Neil Zhang wrote:
> > > > > I will prepare another patch to add DT description under PMU
> > > > > since there is no generic power domain support for pm notifier
> > > > > if no other
> > > > concerns.
> > > > > We can change the manner if there is generic power domain
> > > > > support for
> > > > pm notifier later.
> > > > > Thanks.
> > > >
> > > > No, please don't add any DT bindings for power domains specific
> to
> > > > PMU node.
> > > > We can't change the DT bindings once added.
> > > >
> > > > As I pointed out the DT bindings for generic power domains are
> > > > under discussion.
> > > > See if you can reuse it, if not help in extending it so that it
> can be used.
> > > >
> > >
> > > Sorry for reply later.
> > > As I said before the under discussed generic power domain is not
> > > suitable for CPU peripherals since they are all known belong to CPU
> > > or cluster power domain.
> > > If we want to follow the way they are discussion, we need to
> > > register core and cluster power provider, and need vfp/gic/pmu etc
> to require them.
> > > Is it really suitable?
> > >
> > Do you have any comments?
> > If no, I would like to put it under PMU node.
> 
> Sudeep is a better person to comment than me, but I'd still rather this
> was handled more generically as opposed to a PMU-specific hack. I don't
> see a problem including GIC and VFP here, but only when we actually
> need to save/restore them (i.e. what the hardware guys went crazy with
> the power domains).
> 

Long time no follow up for this loop.
Sorry that I will pick it again.

Will,
I prefer to check always-on field under PMU node to check whether we need
Save/restore them.

Here is a sample for arch timer which also add under itself.
What do you think?

commit 82a5619410d4c4df65c04272db198eca5a867c18
Author: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Date:   Tue Apr 8 10:04:32 2014 +0100

    clocksource: arch_arm_timer: Fix age-old arch timer C3STOP detection issue


> Will

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
