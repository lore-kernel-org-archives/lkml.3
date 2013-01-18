Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3ARAgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:36:35 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:24661
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076Ab3ARAge convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:36:34 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz17326ah8275bh8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h1155h)
X-WSS-ID: 0MGSPNX-01-1E4-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux 3.8-rc3 reboot and shutdown
Thread-Topic: linux 3.8-rc3 reboot and shutdown
Thread-Index: AQHN9OVfBOBCoX5Y/Ea73ubzySE7LJhN7CZQgAChWAD//6JnAIAAb9CA//+do9A=
Date: Fri, 18 Jan 2013 00:35:56 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DC30C52@sausexdag04.amd.com>
References: <CAKocOOMagCzn7fkkZJM+r5K--yXjZ40jCsHpwi97gCKo1keZ1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC2FB3A@sausexdag04.amd.com>
	<CAKocOOMrTf9RMa17Zy_oK+uPJ_B7uNwxhsX7dOm4okVdnmwY5A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30C27@sausexdag04.amd.com>
 <CAKocOOPNf5HZOO421Cvhb35fMxM6Tfu7w2aXZb3UF3igS9S=Kw@mail.gmail.com>
In-Reply-To: <CAKocOOPNf5HZOO421Cvhb35fMxM6Tfu7w2aXZb3UF3igS9S=Kw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.12.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Thursday, January 17, 2013 7:26 PM
> To: Deucher, Alexander
> Cc: jglisse@redhat.com; linux-kernel@vger.kernel.org
> Subject: Re: linux 3.8-rc3 reboot and shutdown
> 
> On Thu, Jan 17, 2013 at 4:48 PM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> Sent: Thursday, January 17, 2013 6:21 PM
> >> To: Deucher, Alexander
> >> Cc: jglisse@redhat.com; linux-kernel@vger.kernel.org
> >> Subject: Re: linux 3.8-rc3 reboot and shutdown
> >>
> >> On Thu, Jan 17, 2013 at 12:45 PM, Deucher, Alexander
> >> <Alexander.Deucher@amd.com> wrote:
> >> >> -----Original Message-----
> >> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> >> >> Sent: Thursday, January 17, 2013 2:03 PM
> >> >> To: jglisse@redhat.com; Deucher, Alexander
> >> >> Cc: linux-kernel@vger.kernel.org; Shuah Khan
> >> >> Subject: linux 3.8-rc3 reboot and shutdown
> >> >>
> >> >> Alex,
> >> >>
> >> >> I started seeing hang during shutdown and reboot on my laptop that
> has
> >> >> ATI radeon VGA.
> >> >>
> >> >> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD]
> nee
> >> >> ATI RV620 [Mobility Radeon HD 3400 Series] (prog-if 00 [VGA
> >> >> controller])
> >> >>
> >> >> My bisect narrowed it to the following commit.
> >> >
> >> > Should be fixed by this commit:
> >> > http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-
> >> 3.8&id=19fc42ed9950d5fe17089c0a928121047c882092
> >> > Which should be finding its way upstream any day now.
> >> >
> >> > Alex
> >> >
> >>
> >> Alex,
> >>
> >> Applied this patch on 3.8-rc3 and tested it. reboot still hung. The
> >> only thing that fixes the problem is reverting
> >> 71e3d1578c954cf29f1f4db1c8930d3574025eb0
> >
> > Does the attached patch applied in addition to:
> > http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-
> 3.8&id=19fc42ed9950d5fe17089c0a928121047c882092
> > fix the issue?
> >
> > Alex
> 
> No reboot still hung after applying
> 0001-drm-radeon-don-t-attempt-to-soft-reset-DMA-ring-on-r.patch  in
> addition to 19fc42ed9950d5fe17089c0a928121047c882092

Can you send me the dmesg from the failed reboot?

Alex

