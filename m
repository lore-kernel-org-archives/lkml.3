Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaIHSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:25:56 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:43627 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaIHSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140908110131.GX4703@rric.localhost>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <7863371.EMkUuntQWU@wuerfel> <20140905142245.GG20164@leverpostej>
 <2952834.1P42roDKD9@wuerfel> <20140908110131.GX4703@rric.localhost>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 8 Sep 2014 13:25:34 -0500
Message-ID: <CAL_JsqLgimdX0Ff4Wsyx68-8NaFDx=0CN36qnLUtXNTicybAgA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium
 Thunder SoC Family
To: Robert Richter <rric@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        Olof Johansson <olof@lixom.net>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 6:01 AM, Robert Richter <rric@kernel.org> wrote:
> On 05.09.14 18:25:35, Arnd Bergmann wrote:
>> On Friday 05 September 2014 15:22:46 Mark Rutland wrote:
>> >
>> > > A common pattern these days is to do dependencies like
>> > >
>> > > arch/*/Kconfig:
>> > >       config ARCH_FOO
>> > >       bool "Enable support for Foo platform"
>> > >       help
>> > >         ...
>> > >
>> > >
>> > > drivers/*/Kconfig
>> > >       config SUBSYS_FOO
>> > >       bool "SUBSYS driver for Foo"
>> > >       depends on ARCH_FOO || COMPILE_TEST
>> > >       depends on OF && REGULATOR && GENERIC_PHY # or whatever
>> >
>> > Russell's comments w.r.t. Kconfig warnings when config names change
>> > still holds regardless of select vs depends on.
>>
>> Yes, that's what I wrote in my reply as well.
>>
>> > > That way we can enable everything in the defconfig, but someone
>> > > who likes to build a more specialized kernel can disable the
>> > > other platforms and won't get the drivers that are specific to
>> > > those.
>> > >
>> > > I personally think this is a bit more verbose than what we need, but
>> > > I don't strongly object doing it that way.
>> >
>> > You'd still be able to do this without ARCH_FOO, though you would need
>> > to know which drivers are necessary for a particular SoC. That seems to
>> > be the way things are handled on x86; I don't recall having to select
>> > support for specific machines there, just the individual drivers.
>
> This is well hidden on x86, but each vendor has a config option. For
> AMD systems we have had our own option to disable vendor specific
> code, see CPU_SUP_AMD for example. Disabling this will remove all AMD
> specific code in the kernel. Of course this is enabled per default.
>
> With ARCH_THUNDER I intended to do the same (you could name this also
> SOC_SUP_CAVIUM or so but I kept the current naming scheme). In patch
> 4/4 I have added the option to defconfig. This enables this per
> default and nobody has to deal with any option manually, just running
> make defconfig is fine.
>
> Also, at least to disable building the dtb file for foo, you will need
> ARCH_FOO too. How else would you deal with dtb files then?

dtb builds are quick and don't affect the image size at all.
Personally, I would prefer to see all dtb's get built for the dtbs
rule. You can still specify the specific dtb you want in the case of
only caring about 1 platform.

Rob
