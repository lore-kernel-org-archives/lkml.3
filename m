Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaGORHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:07:11 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:17702
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576AbaGORHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:07:06 -0400
X-WSS-ID: 0N8RJJL-07-TJF-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Dave Airlie <airlied@gmail.com>,
        =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
CC: Jerome Glisse <j.glisse@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: RE: [PATCH 00/83] AMD HSA kernel driver
Thread-Topic: [PATCH 00/83] AMD HSA kernel driver
Thread-Index: AQHPnIhRgu4cBSEvqEGszfo01ez7ZpuaJWaAgAAHkICAAXhzgIABnKmAgABkh4CAAHT6oIAAYx0AgAEJCoCAAU6ggIAAixtA
Date: Tue, 15 Jul 2014 17:06:56 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
References: <1405028727-5276-1-git-send-email-oded.gabbay@amd.com>
	<20140710222423.GA14219@gmail.com>
	<019CCE693E457142B37B791721487FD91809E4C2@storexdag01.amd.com>
	<20140711211850.GU1870@gmail.com>
	<019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
	<20140713035535.GB5301@gmail.com>
	<D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
	<20140713164901.GB10624@gmail.com>	<53C396D3.9000600@vodafone.de>
 <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
In-Reply-To: <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(13464003)(377454003)(51704005)(199002)(189002)(4396001)(20776003)(47776003)(79102001)(23676002)(86362001)(64706001)(106466001)(44976005)(74662001)(31966008)(81542001)(81342001)(68736004)(19580405001)(19580395003)(84676001)(83322001)(101416001)(33656002)(50466002)(74502001)(107046002)(99396002)(92566001)(92726001)(80022001)(76482001)(85306003)(106116001)(21056001)(95666004)(83072002)(53416004)(97736001)(105586002)(85852003)(77982001)(77096002)(93886003)(76176999)(55846006)(2656002)(50986999)(87936001)(46102001)(54356999)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB045;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6FH7ITV016499



>-----Original Message-----
>From: Dave Airlie [mailto:airlied@gmail.com]
>Sent: Tuesday, July 15, 2014 12:35 AM
>To: Christian KÃ¶nig
>Cc: Jerome Glisse; Bridgman, John; Lewycky, Andrew; linux-
>kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Deucher,
>Alexander; akpm@linux-foundation.org
>Subject: Re: [PATCH 00/83] AMD HSA kernel driver
>
>On 14 July 2014 18:37, Christian KÃ¶nig <deathsimple@vodafone.de> wrote:
>>> I vote for HSA module that expose ioctl and is an intermediary with
>>> the kernel driver that handle the hardware. This gives a single point
>>> for HSA hardware and yes this enforce things for any hardware
>manufacturer.
>>> I am more than happy to tell them that this is it and nothing else if
>>> they want to get upstream.
>>
>> I think we should still discuss this single point of entry a bit more.
>>
>> Just to make it clear the plan is to expose all physical HSA capable
>> devices through a single /dev/hsa device node to userspace.
>
>This is why we don't design kernel interfaces in secret foundations, and
>expect anyone to like them.

Understood and agree. In this case though this isn't a cross-vendor interface designed by a secret committee, it's supposed to be more of an inoffensive little single-vendor interface designed *for* a secret committee. I'm hoping that's better ;)

>
>So before we go any further, how is this stuff planned to work for multiple
>GPUs/accelerators?

Three classes of "multiple" :

1. Single CPU with IOMMUv2 and multiple GPUs:

- all devices accessible via /dev/kfd
- topology information identifies CPU + GPUs, each has "node ID" at top of userspace API, "global ID" at user/kernel interface
 (don't think we've implemented CPU part yet though)
- userspace builds snapshot from sysfs info & exposes to HSAIL runtime, which in turn exposes the "standard" API
- kfd sets up ATC aperture so GPUs can access system RAM via IOMMUv2 (fast for APU, relatively less so for dGPU over PCIE)
- to-be-added memory operations allow allocation & residency control (within existing gfx driver limits) of buffers in VRAM & carved-out system RAM
- queue operations specify a node ID to userspace library, which translates to "global ID" before calling kfd

2. Multiple CPUs connected via fabric (eg HyperTransport) each with 0 or more GPUs:

- topology information exposes CPUs & GPUs, along with affinity info showing what is connected to what
- everything else works as in (1) above

3. Multiple CPUs not connected via fabric (eg a blade server) each with 0 or more GPUs

- no attempt to cover this with HSA topology, each CPU and associated GPUs is accessed independently via separate /dev/kfd instances

>
>Do we have a userspace to exercise this interface so we can see how such a
>thing would look?

Yes -- initial IP review done, legal stuff done, sanitizing WIP, hoping for final approval this week

There's a separate test harness to exercise the userspace lib calls, haven't started IP review or sanitizing for that but legal stuff is done

>
>Dave.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
