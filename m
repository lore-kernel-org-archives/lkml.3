Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbbA1GWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:22:31 -0500
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:43537 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbbA1GWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:22:30 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <alpine.LFD.2.11.1501272027390.1322@knanqh.ubzr>
Date: Wed, 28 Jan 2015 14:21:55 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1FECE32B-0D63-4696-BED7-74FE5845C260@jcrosoft.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20150127132127.GA869@amd> <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com> <201501271532.25540@pali> <20150127174818.GM26493@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr> <20150127210943.GN26493@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr> <20150127223331.GP26493@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501272027390.1322@knanqh.ubzr>
To: Nicolas Pitre <nico@fluxnic.net>
X-Mailer: Apple Mail (2.1993)
X-Ovh-Tracer-Id: 9225905312511601592
X-Ovh-Remote: 80.15.34.121 (lmontsouris-656-1-34-121.w80-15.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jan 28, 2015, at 10:07 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> 
> On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:
> 
>> On Tue, Jan 27, 2015 at 04:34:47PM -0500, Nicolas Pitre wrote:
>>> On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:
>>>> Or we pass both the ATAGs and wrapped DT to the kernel when both exist,
>>>> and let the kernel deal with it in a much saner environment than the
>>>> restricted decompressor environment.
>>> 
>>> ... which would be a step backward in the context of the transition to 
>>> DT we accepted.  People will have even less of an incentive to fix their 
>>> stuff.
>> 
>> Where's the people fixing their stuff today?
> 
> At least some people in this thread are, otherwise they'd still be away 
> hacking on their own.
> 
>> I think your position is something of an idealist rather than a 
>> realist - the reality is that five years down the line of DT, the 
>> platforms which have not converted are now *never* going to convert, 
>> irrespective of how much "incentive" we may think we should apply to 
>> the situation.
> 
> Don't get me wrong.  I'm not expecting those platforms to do native DT 
> booting ever.  However "faking" DT booting with already proven solutions 
> that don't bastardize the kernel further should be encouraged.
> 
>>> If there is indeed a sizable following for the device then someone 
>>> should figure out how to cope with upstream kernels, either through the 
>>> installation of some intermediate bootloader that can talk FDT directly, 
>>> or via a shim layer.  None of that has to be performed by nor linked 
>>> with the kernel binary, nor maintained in the kernel tree. And it's not 
>>> even that hard to do: we have precedents on other platforms with crappy 
>>> bootloaders where this just works.
>> 
>> That's a rediculous position if you want something which "just works"
>> on as much hardware as possible, which is, after all, what the single
>> zImage project is all about.
> 
> Agreed.
> 
>> To be pro single-zImage, and anti popular hardware is quite contradictory.
> 
> Indeed.  I'm not against popular hardware.
> 
>> You only have to look at x86 for this: just because ACPI came along does
>> not mean that the Linux kernel started demanding that ACPI is the only
>> way to describe the world.  Linux continues to directly support all the
>> old boot protocols that it did since the days of i386, such as the e820
>> memory interface and doesn't convert these to an ACPI table just because
>> it can.
> 
> Booting from a floppy boot sector is no longer supported though.
> 
> But that's besides the point.  If someone needs a 5-line addition to 
> atags_to_fdt.c in order to boot some old stuff then let's just do it and 
> move on. I'll happily ACK the patch. The code is there and it is not 
> going away soon.
> 
> However, if something more involved is needed, is platform specific and 
> is likely to require about as many lines in the kernel than it would 
> need in some externat shim then the shim solution should be encouraged 
> instead.  After all that's why LILO, Syslinux and Grub were created on 
> X86: to Supplement the crappy PC BIOS boot interface.  And if the 
> hardware is popular, then finding a motivated hacker to do it shouldn't 
> be too hard, right?
> 
> In other words, what prevents someone from creating, say, a custom 
> minimal Barebox version that sits on top of the existing N900 
> bootloader?  Wouldn't that provide a much better user experience?

I do agree with Nicolas

If I can get my hand on a phone I’ll put barebox on it

Best Regards,
J.
> 
> 
> Nicolas
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

