Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaK1OKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:10:32 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36410 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaK1OKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:10:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141126144153.GK3836@n2100.arm.linux.org.uk>
References: <CACRpkdYmJWy1_vs0tWRA7SvkQnvbXXKqf7pHpH5b5tZ6vR+KJg@mail.gmail.com>
	<1414961549-31666-1-git-send-email-jason@lakedaemon.net>
	<5474F78F.2060906@suse.cz>
	<20141125235150.GH3836@n2100.arm.linux.org.uk>
	<20141126005710.GE22670@titan.lakedaemon.net>
	<CACRpkdZJoWbQeuZ4ZXGbQr0+SNG_9ZA+cQkAA0C2F9rnZDYtyQ@mail.gmail.com>
	<20141126144153.GK3836@n2100.arm.linux.org.uk>
Date: Fri, 28 Nov 2014 15:10:30 +0100
Message-ID: <CACRpkdYwQT3+RLxP_b_kYJoHV4L7sZ7yiU=JZWVq_zHKz0EY_g@mail.gmail.com>
Subject: Re: [PATCH] ARM: kbuild: Fix forced rebuild after 'make dtbs'
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>, Michal Marek <mmarek@suse.cz>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 3:41 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Nov 26, 2014 at 02:57:42PM +0100, Linus Walleij wrote:
>> make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
>> KBUILD_OUTPUT=build-u300 u300_defconfig
>> make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
>> KBUILD_OUTPUT=build-u300 zImage CONFIG_DEBUG_SECTION_MISMATCH=y
>> make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
>> KBUILD_OUTPUT=build-u300 dtbs
>> make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
>> KBUILD_OUTPUT=build-u300 zImage CONFIG_DEBUG_SECTION_MISMATCH=y
>>
>> -> Rebuilds everything.
>>
>> This doesn't occur before the offending commit. So it only happens
>> when specifying extra environment variables on the command line.
>
> I suspect if you also provide the CONFIG_DEBUG_SECTION_MISMATCH=y on the
> dtbs line, everything will work properly.

Yay, it works! :)

> The problem is that dtbs line executes a prepare, which I guess rebuilds
> the bounds stuff.  So, the dtbs target results in it being rebuilt without
> the section mismatch, and then you re-execute a make with it, causing
> the bounds stuff to be rebuilt again.

Yep. Not very intuitive to require passing section mismatch debug
flags to DTB rebuilding but whatever, it's not so bad I can't live with
it.

Strange that it worked before.

Yours,
Linus Walleij
