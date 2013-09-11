Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3IKUgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:36:46 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:56857 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab3IKUgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:36:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CACRpkdYfeao6bvwjq7YJhBNCoC_JVxPTwYzPPiWM0tgUQreJKg@mail.gmail.com>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
	<1378817379-8238-2-git-send-email-lee.jones@linaro.org>
	<CAOesGMgySNLKo_H0h4MCbAWvyW0h2bWa96drWBpnhAYYQwH9mw@mail.gmail.com>
	<20130910153037.GA11227@lee--X1>
	<CAOesGMiBN5SaEY26SxGaw9E4ViR3cC0PcwNMEd4cLJZMfomprQ@mail.gmail.com>
	<CACRpkdY24uU=tXirJqrxLH-45ORFGybJOg-2tDOkpSmFUQUiiw@mail.gmail.com>
	<20130911081911.GI11227@lee--X1>
	<CACRpkdY6v+LMggLBdfKc3VUPmRZXTf1zBi4a93EPhQeo21wMeQ@mail.gmail.com>
	<CAF2Aj3iPdqM-+FQ7R9MZ-6jV1Q1me9TG1P4cEGA7fSBBYH92zA@mail.gmail.com>
	<CACRpkdYfeao6bvwjq7YJhBNCoC_JVxPTwYzPPiWM0tgUQreJKg@mail.gmail.com>
Date: Wed, 11 Sep 2013 13:36:44 -0700
Message-ID: <CAOesGMi7zbGuBBaUToe7=PUJvUUT8FkdMAWzfCE0igpYiYTZSg@mail.gmail.com>
Subject: Re: [PATCH 01/38] ARM: ux500: Remove PrimeCell IDs from Nomadik I2C
 DT nodes
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 4:13 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Sep 11, 2013 at 11:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> On 11 Sep 2013 10:33, "Linus Walleij" <linus.walleij@linaro.org> wrote:
>
>>> No it was something transient, after a clean rebuild it boots
>>> just fine. :-/
>>>
>>> I'll see if I can boot the same uImage on the Snowball too.
>
> Yeah Snowball boots the same DT image with just some random
> dmesg noise from Torvalds HEAD:
>
> U8500 $ mmc rescan 1 ; fat load mmc 1 0x0 /uImage ; bootm 0x0
> Partition info retrieved
> Reading /uImage
>
> 8997342 bytes read
> ## Booting kernel from Legacy Image at 00000000 ...
>    Image Name:   Ux500 Device Tree kernel
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    8997278 Bytes =  8.6 MB
>    Load Address: 00008000
>    Entry Point:  00008000
>    Loading Kernel Image ... OK
> OK
>
> Starting kernel ...
>
> Uncompressing Linux... done, booting the kernel.
> Booting Linux on physical CPU 0x300
> Linux version 3.11.0-09031-ga22a0fd (linus@localhost.localdomain) (gcc
> version 4.8.2 20130805 (prerelease) (crosstool-NG
> linaro-1.13.1-4.8-2013.08 - Linaro GCC 2013.08) ) #48 SMP PREEMPT Wed
> Sep 11 11:14:36 CEST 2013
> CPU: ARMv7 Processor [412fc091] revision 1 (ARMv7), cr=10c5387d
> CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
> Machine: ST-Ericsson Ux5x0 platform (Device Tree Support), model:
> ST-Ericsson HREF (v60+) platform with Device Tree
> Only cachepolicy=writeback supported on ARMv6 and later
> Memory policy: ECC disabled, Data cache writealloc
> DB8500 v2.1 [0x008500b1]
> (...)
>
> I don't know what is the problem with Olof's machine :-/

Oh! Well, to start with apparantly u8500_defconfig doesn't have
APPENDED_DTB enabled, which explains some of the confusion here.

With that fixed (and the appropriate options to get the bootargs from
the atags), I get as far as console probing where output stops, if I
have DEBUG_LL on. With it disabled I get all the way up.

Not sure what was going on earlier here. Maybe just as in your case it
was a matter of cleaning out and starting fresh.

multi_v7_defconfig still doesn't boot though, but the failure seems to
be lower level than any of the others, no output with DEBUG_LL on.


-Olof
