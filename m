Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaF3Kjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:39:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5729 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbaF3Kjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:39:49 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Neil Zhang <zhangwm@marvell.com>, "'Sudeep Holla'" <sudeep.holla@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>
CC: "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>
Date: Mon, 30 Jun 2014 03:39:15 -0700
Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac9vV0rzR7jl/TakQBq7behtTQicwQFkLAhwB9nT5GA=
Message-ID: <9034CBD80F070943B59700D7F8149ED90182308172@SC-VEXCH4.marvell.com>
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
 <20140422103642.GF7484@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com>
 <20140423170821.GJ5649@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
 <5360FB07.5030407@arm.com>
 <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
 <20140513184503.GF16388@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
 <537337F3.4080300@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A0875776@SC-VEXCH4.marvell.com>
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9A0875776@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-30_02:2014-06-27,2014-06-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406300115
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5UAdvu0010949

Sudeep & Willï¼Œ

> -----Original Message-----
> From: Neil Zhang
> Sent: 2014å¹´5æœˆ21æ—¥ 19:47
> To: 'Sudeep Holla'; Will Deacon
> Cc: 'linux@arm.linux.org.uk'; 'linux-arm-kernel@lists.infradead.org';
> 'linux-kernel@vger.kernel.org'; 'devicetree@vger.kernel.org'
> Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
> 
> Sudeepï¼Œ
> 
> > -----Original Message-----
> > From: Sudeep Holla [mailto:sudeep.holla@arm.com]
> > Sent: 2014å¹´5æœˆ14æ—¥ 17:32
> > To: Neil Zhang; Will Deacon
> > Cc: Sudeep Holla; 'linux@arm.linux.org.uk';
> > 'linux-arm-kernel@lists.infradead.org';
> > 'linux-kernel@vger.kernel.org'; 'devicetree@vger.kernel.org'
> > Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm
> > notifier
> >
> >
> >
> > On 14/05/14 03:28, Neil Zhang wrote:
> > >> -----Original Message-----
> > >> From: Will Deacon [mailto:will.deacon@arm.com]
> > >> Sent: 2014å¹´5æœˆ14æ—¥ 2:45
> > >> To: Neil Zhang
> > >> Cc: Sudeep Holla; 'linux@arm.linux.org.uk';
> > >> 'linux-arm-kernel@lists.infradead.org';
> > >> 'linux-kernel@vger.kernel.org'; 'devicetree@vger.kernel.org'
> > >> Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm
> > >> notifier
> > >>
> > >> On Mon, May 12, 2014 at 11:22:09AM +0100, Neil Zhang wrote:
> > >>>>> The device tree bindings for power domains is under discussion
> > >>>>> [1]
> > >>>>
> > >>>> Thanks for the information.
> > >>>> But it currently for device only, core related stuff are not supported.
> > >>>> And is it really good to register power provider for core and let
> > >>>> vfp / pmu etc to get it?
> > >>>>
> > >>>
> > >>> What's your suggestion about it?
> > >>> Is it OK that I add it under the PMU node?
> > >>
> > >> I don't really mind. I just want to avoid re-inventing the wheel in
> > >> a PMU-specific way and having to maintain that code forever because
> > >> it ended up in our DT description.
> > >>
> > >> Will
> > >
> > > I will prepare another patch to add DT description under PMU since
> > > there is no generic power domain support for pm notifier if no other
> > concerns.
> > > We can change the manner if there is generic power domain support
> > > for
> > pm notifier later.
> > > Thanks.
> >
> > No, please don't add any DT bindings for power domains specific to PMU
> > node.
> > We can't change the DT bindings once added.
> >
> > As I pointed out the DT bindings for generic power domains are under
> > discussion.
> > See if you can reuse it, if not help in extending it so that it can be used.
> >
> 
> Sorry for reply later.
> As I said before the under discussed generic power domain is not suitable for
> CPU peripherals since they are all known belong to CPU or cluster power
> domain.
> If we want to follow the way they are discussion, we need to register core
> and cluster power provider, and need vfp/gic/pmu etc to require them.
> Is it really suitable?
> 
Do you have any comments?
If no, I would like to put it under PMU node.

> > Regards,
> > Sudeep
> >
> >
> 
> Best Regards,
> Neil Zhang

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
