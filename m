Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaDOMxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:53:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52704 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbaDOMxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:53:45 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Date: Tue, 15 Apr 2014 05:53:15 -0700
Subject: RE: [PATCH v2] ARM: perf: save/restore pmu registers in pm notifier
Thread-Topic: [PATCH v2] ARM: perf: save/restore pmu registers in pm notifier
Thread-Index: Ac9YqTyCddk9KhcMQvCXfexBheIf7wAAEQCQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE55075F187A@SC-VEXCH4.marvell.com>
References: <1397439742-28337-1-git-send-email-zhangwm@marvell.com>
 <20140415084749.GG17408@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE55075F1873@SC-VEXCH4.marvell.com>
 <20140415124100.GK17408@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE55075F1875@SC-VEXCH4.marvell.com>
 <20140415124953.GL17408@arm.com>
In-Reply-To: <20140415124953.GL17408@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404150214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3FCrwAa027192


> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: 2014Äê4ÔÂ15ÈÕ 20:50
> To: Neil Zhang
> Cc: linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; Sudeep Holla
> Subject: Re: [PATCH v2] ARM: perf: save/restore pmu registers in pm notifier
> 
> On Tue, Apr 15, 2014 at 01:46:08PM +0100, Neil Zhang wrote:
> > > On Tue, Apr 15, 2014 at 01:37:17PM +0100, Neil Zhang wrote:
> > > > > On Mon, Apr 14, 2014 at 02:42:22AM +0100, Neil Zhang wrote:
> > > > > > From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> > > > > >
> > > > > > This adds core support for saving and restoring CPU PMU
> > > > > > registers for suspend/resume support i.e. deeper C-states in cpuidle
> terms.
> > > > > > This patch adds support only to ARMv7 PMU registers save/restore.
> > > > > > It needs to be extended to xscale and ARMv6 if needed.
> > > > > >
> > > > > > [Neil] We found that DS-5 not work on our CA7 based SoCs.
> > > > > > After debuging, found PMU registers were lost because of core
> > > > > > power
> > > down.
> > > > > > Then i found Sudeep had a patch to fix it about two years ago
> > > > > > but not in the mainline, just port it.
> > > > >
> > > > > What I don't like about this patch is that we're introducing
> > > > > significant overhead for SoCs that don't require save/restore of
> > > > > the PMU state. I'd much rather see core power down disabled
> > > > > whilst the PMU is in use but, if that's not possible, then I think we need
> to:
> > > > >
> > > > >  (1) Make this conditional for cores that really need it
> > > > >
> > > > >  (2) Only save/restore if the PMU is in use (even better, just
> save/restore
> > > > >      the live registers, but that's probably not worth the effort
> > > > >      initially).
> > > > >
> > > >
> > > > The patch has check the ARMV7_PMNC_E bit when save / restore, so
> > > > suppose only the core's that use PMU will do the save / restore work.
> > >
> > > Seems pretty fragile to base our save/restore decision on the value
> > > of one of the registers, though. What happens if the control
> > > register is zeroed by the core power down?
> > >
> > It will check the saved control value when restore, so is should be OK
> > while control register is zeroed.
> 
> Ah yes, I mixed up and save and restore functions. It's still horrible that we
> have to read the control register unconditionally during the save though
> -- it might be nicer if we simply register/unregister the notifier during perf runs
> (in the same way that we request/free the PMU IRQs).
> 

Thanks for the comments, I will refine it according to your suggestion.

> Will

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
