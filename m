Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaD3CWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:22:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22890 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbaD3CWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:22:00 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Tue, 29 Apr 2014 19:21:22 -0700
Subject: RE: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac9fFvxYltw6xhxlSXi4su4knBEkCgFA854g
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
 <20140422103642.GF7484@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com>
 <20140423170821.GJ5649@arm.com>
In-Reply-To: <20140423170821.GJ5649@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-29_07:2014-04-30,2014-04-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404300039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3U2MCN0004228


> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: 2014å¹´4æœˆ24æ—¥ 1:08
> To: Neil Zhang
> Cc: linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Sudeep Holla; devicetree@vger.kernel.org
> Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
> 
> On Wed, Apr 23, 2014 at 11:31:09AM +0100, Neil Zhang wrote:
> >
> > > -----Original Message-----
> > > From: Will Deacon [mailto:will.deacon@arm.com]
> > > Sent: 2014å¹´4æœˆ22æ—¥ 18:37
> > > To: Neil Zhang
> > > Cc: linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> > > linux-kernel@vger.kernel.org; Sudeep Holla;
> > > devicetree@vger.kernel.org
> > > Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm
> > > notifier
> > >
> > > Hi Neil,
> > >
> > > On Tue, Apr 22, 2014 at 03:26:36AM +0100, Neil Zhang wrote:
> > > > This adds core support for saving and restoring CPU PMU registers
> > > > for suspend/resume support i.e. deeper C-states in cpuidle terms.
> > > > This patch adds support only to ARMv7 PMU registers save/restore.
> > > > It needs to be extended to xscale and ARMv6 if needed.
> > > >
> > > > I made this patch because DS-5 is not working on Marvell's CA7 based
> SoCs.
> > > > And it has consulted Sudeep KarkadaNagesha's patch set for multiple
> PMUs.
> > > >
> > > > Thanks Will and Sudeep's suggestion to only save / restore used events.
> > >
> > > Whilst this is a step in the right direction, I'd still like to see
> > > the save/restore predicated on something in the device-tree or
> > > otherwise. Most SoCs *don't* require these registers to be preserved
> > > by software, so we need a way to describe that the PMU is in a
> > > power-domain where its state is lost when the CPU goes idle.
> > >
> > > This doesn't sound like a PMU-specific problem, so there's a
> > > possibility that this has been discussed elsewhere, in the context
> > > of other IP blocks
> > >
> > > [adding the devicetree list in case somebody there is aware of any
> > > work in this area]
> > >
> >
> > Thanks Will.
> > What should I do now?
> > Add a filed under PMU or waiting for somebody whether there are
> > general supporting for power domain maintain.
> 
> I think we need some input from the device-tree guys to see whether they
> would object to us solving this locally (in the PMU node) or not.
> Personally, I'd much prefer a general way to describe the need for pm-notifiers,
> but if that's not being looked at then we can cook something specifically for
> our needs.
> 

No input from device-tree guys :(

> Will

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
