Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915Ab3JQBZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:25:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4133 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761322Ab3JQBZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:25:54 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yu Tang <ytang5@marvell.com>, Zhou Zhu <zzhu3@marvell.com>,
        Will Deacon <Will.Deacon@arm.com>
Date: Wed, 16 Oct 2013 18:25:43 -0700
Subject: RE: [Question] Ask for arm arch timer
Thread-Topic: [Question] Ask for arm arch timer
Thread-Index: Ac7KcytsrbcH3E05Sp6i/5DnVIGVrgAZE40w
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE49FCEFF37F@SC-VEXCH4.marvell.com>
References: <175CCF5F49938B4D99B2E3EF7F558EBE49FCEFF280@SC-VEXCH4.marvell.com>
 <525E8DAD.60801@gmail.com> <20131016132042.GC4196@arm.com>
In-Reply-To: <20131016132042.GC4196@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-16_07:2013-10-17,2013-10-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310160127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9H1Q1cP006046

> -----Original Message-----
> From: Catalin Marinas [mailto:catalin.marinas@arm.com]
> Sent: 2013Äê10ÔÂ16ÈÕ 21:21
> To: Rob Herring
> Cc: Neil Zhang; linux-kernel@vger.kernel.org; Yu Tang; Zhou Zhu; Will Deacon
> Subject: Re: [Question] Ask for arm arch timer
> 
> On Wed, Oct 16, 2013 at 01:59:25PM +0100, Rob Herring wrote:
> > On 10/16/2013 07:39 AM, Neil Zhang wrote:
> > > I saw your following patch called clocksource_of_init() directly in
> > > time_init() for arm64.
> > > My question is that what should we do if there are some Soc special
> > > work need to be done before arch timer can be used?
> > > Thanks in advance.
> >
> > If the timer itself is different, then you should have a different DT
> > compatible string which you can use to trigger additional initialization.
> >
> > Integration level initialization like enabling clocks would need
> > something different as no machine descriptors exist for arm64.
> >
> > Another option would be do the setup in secure world or the bootloader.
> 
> The generic timer should indeed be initialised in the firmware (bootloader may
> not be suitable if initialisation needs to happen on each CPU). Linux doesn't need
> to do other things than reading the frequency, programming the interrupts,
> counters (but definitely not SoC-specific initialisation).
> 
> > Can you be more specific what initialization is needed.
> 
> I'm interested in this as well.

Thanks Catalin and Rob!
Yes, we need to select the clk source and enable it.
Seems we need to put more and more works into firmware on arm64.

> 
> --
> Catalin

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
