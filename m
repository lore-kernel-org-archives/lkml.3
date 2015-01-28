Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbbA2BHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:07:24 -0500
Received: from 1.mo6.mail-out.ovh.net ([46.105.56.136]:36040 "EHLO
	1.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbA2BHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:07:17 -0500
X-Greylist: delayed 17373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 20:07:16 EST
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
Date: Thu, 29 Jan 2015 02:00:25 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0ED606B9-34EB-4FEC-BCC1-19BC60BCF768@jcrosoft.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20150127174818.GM26493@n2100.arm.linux.org.uk> <20150128005032.GK28663@atomide.com> <201501281458.22088@pali> <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr> <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
To: Rob Herring <robherring2@gmail.com>
X-Mailer: Apple Mail (2.1993)
X-Ovh-Tracer-Id: 2575214564009225180
X-Ovh-Remote: 80.15.34.121 (lmontsouris-656-1-34-121.w80-15.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrvdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jan 28, 2015, at 11:57 PM, Rob Herring <robherring2@gmail.com> wrote:
> 
> On Wed, Jan 28, 2015 at 8:33 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
>> On Wed, 28 Jan 2015, Pali Rohár wrote:
>> 
>>> On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
>>>> On omaps, the bootrom passes the bootreason in r1 to the
>>>> bootloader that can do whatever it wants with it. We could
>>>> maybe pass it in the kernel cmdline to the watchdog driver
>>>> for user space?
>>>> 
>>> 
>>> Not truth for N900. Bootreason depends on PRM_RSTST omap
>>> register, state of vbat charger pins, time how long was power key
>>> pressed, R&D data stored in CAL partition and other undocumented
>>> registers for omap HS devices. I already tried to implement at
>>> least some subset of it in userspace (or kernel), but it is
>>> impossible because NOLO bootloader clear status of PRM_RSTST
>>> register.
>>> 
>>> There is also copy of PRM_RSTST register stored at address
>>> 0x4020FFB8 (tracing data) but that address is rewritten (probably
>>> by kernel), so we really cannot implement reading bootreason in
>>> kernel.
>>> 
>>> But in early stage in uboot it is possible to read 0x4020FFB8
>>> address and get some part of bootreason. But still PRM_RSTST is
>>> not enough!
>>> 
>>> I would be happy if DT kernel can export /proc/atags file with
>>> ATAGs passed by bootloader. It would be enough for me. In
>>> userspace I can parse content and do what is needed.
>> 
>> What about defining a DT boot reason property instead?
>> Maybe it already exists?  If not, it's something that could certainly be
>> generically used on other platforms too.
> 
> I'm fine with that, but we just need to have a standard kernel
> userspace interface in addition to something like
> /proc/device-tree/bootreason. Perhaps this can be the default
> implementation for the watchdog dev. Someday when we decide DT is crap
> and have a new boot interface, we'll have people relying on
> /proc/device-tree. I hope to be retired when that happens…

but if we try to do this generic, where will you store the boot mode

I mean where the SoC boot from

useful to for the Userspace to known where is the bootloader in case of multi boot mode

Best Regards,
J.
> 
> Rob
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

