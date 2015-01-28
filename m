Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbbA2BWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:22:17 -0500
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:43600 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbbA2BWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:22:13 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <201501281458.22088@pali>
Date: Wed, 28 Jan 2015 22:46:22 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tony Lindgren <tony@atomide.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4CCDD671-6850-4876-A523-88F3ECA29D9A@jcrosoft.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20150127174818.GM26493@n2100.arm.linux.org.uk> <20150128005032.GK28663@atomide.com> <201501281458.22088@pali>
To: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
X-Mailer: Apple Mail (2.1993)
X-Ovh-Tracer-Id: 17744745483080018696
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


> On Jan 28, 2015, at 9:58 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> 
> On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
>> * Russell King - ARM Linux <linux@arm.linux.org.uk> [150127 
> 09:51]:
>>> We _could_ (and have in the past) turned round and refused
>>> to support these kinds of hacks - which IMHO is quite a
>>> reasonable stance to take: the message we should be sending
>>> is "if you wish to design new methods without discussing it
>>> with us, we reserve the right not to support them in
>>> mainline kernels; please discuss with us your
>>> requirements."
>>> 
>>> Each time that we accept one of these hacks, we're sending a
>>> message that says "it's okay to work in this crappy way".
>>> 
>>> Yes, I realise that the N900 has little in the way of
>>> support, and we can't exert that kind of back pressure
>>> (since there's no one to direct that onto to effect any
>>> change) so I guess we just have to live with it.
>> 
>> I believe after N900 Nokia dropped the custom ATAGs and used
>> the kernel cmdline instead. And most of the n900 custom ATAGs
>> are not even needed any longer.
>> 
> 
> Yes, almost all N900 ATAGs are static and are already hardcoded 
> into kernel or DT file.
> 
> Basically there are 4 non static values which are used:
> 
> 1. ATAG_REVISION
> 
> 2. ATAG_OMAP
> 2.1 OMAP_TAG_BOOT_REASON --> boot reason

you can pass it via DT I already do it on other platform such as amineoIP
which is full DT with barebox as bootloader

> 2.2 OMAP_TAG_VERSION ("nolo") --> for bootloader version

do you really need such information in the kernel as we have a standard boot API?

> 2.3 OMAP_TAG_VERSION ("boot-mode") --> "normal" or “update"

this is application specific not related to the kernel just pass it via cmdline

Best Regards,
J.
> 
> ATAG_OMAP is non standard and contains sub-atags.
> 
> bootloader version is static now (as Nokia does not develop it 
> anymore), but boot reason and boot mode are set by bootloader and 
> are needed for userspace. boot mode tells init system/userspace 
> if to start normal OS or only small subset for flashing.
> 
>> The ATAG_REVISION is a standard feature that we should support
>> naturally. I don't think we should add any custom ATAGs,
>> except maybe for the bootreason.
>> 
>>>> I think this kind of information (how was board/computer
>>>> started) can be useful also for other architectures. E.g.
>>>> on laptop you would like to know if if was started by
>>>> RTC, power button, WakeOnLan, another ACPI event,
>>>> rebooted machine, watchdog, etc... And scripts can act
>>>> depending on this event (when by RTC, you need to run
>>>> some planned job, when by watchdog reset you should check
>>>> what caused that reason...).
>>> 
>>> There is a standard way to get the boot information already:
>>> look at the watchdog API:
>>> 
>>> #define WDIOC_GETBOOTSTATUS     _IOR(WATCHDOG_IOCTL_BASE, 2,
>>> int)
>>> 
>>> which uses the WDIOF_* flags to indicate the last boot
>>> reason.  It probably isn't as flexible as some may desire,
>>> but it should provide at least the "watchdog rebooted us"
>>> vs "over temperature" vs some other boot reason.
>>> 
>>> The other thing to consider is whether we have a way to know
>>> what the boot reason was, and what we should do if we do
>>> not have a way of supporting some of the boot reasons.  For
>>> example, if we have support for RTC alarm based booting,
>>> but no way to actually tell if the boot was caused by the
>>> RTC alarm triggering.
>> 
>> On omaps, the bootrom passes the bootreason in r1 to the
>> bootloader that can do whatever it wants with it. We could
>> maybe pass it in the kernel cmdline to the watchdog driver
>> for user space?
>> 
> 
> Not truth for N900. Bootreason depends on PRM_RSTST omap 
> register, state of vbat charger pins, time how long was power key 
> pressed, R&D data stored in CAL partition and other undocumented 
> registers for omap HS devices. I already tried to implement at 
> least some subset of it in userspace (or kernel), but it is 
> impossible because NOLO bootloader clear status of PRM_RSTST 
> register.
> 
> There is also copy of PRM_RSTST register stored at address 
> 0x4020FFB8 (tracing data) but that address is rewritten (probably 
> by kernel), so we really cannot implement reading bootreason in 
> kernel.
> 
> But in early stage in uboot it is possible to read 0x4020FFB8 
> address and get some part of bootreason. But still PRM_RSTST is 
> not enough!
> 
> I would be happy if DT kernel can export /proc/atags file with 
> ATAGs passed by bootloader. It would be enough for me. In 
> userspace I can parse content and do what is needed.
> 
> In non DT kernel file /proc/atags is always exported.
> 
>> Of course the problem is that the signed bootloader on n900
>> cannot be modified so the pass through u-boot would have to
>> translate the custom ATAG for bootreason into a kernel
>> cmdline..
>> 
>> But it may actually make sense to add the bootreason ATAGs, it
>> seems quite generic to me.
>> 
> 
> Which bootreason atag? Invent new? Or use above big ATAG_OMAP 
> structure? Inventing new does not solve anything because all 
> developers does not boot kernel for debugging from uboot -- but 
> directly.
> 
>> AFAIK, the other n900 ATAGs can be just ignored.
>> 
>> Regards,
>> 
>> Tony
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

