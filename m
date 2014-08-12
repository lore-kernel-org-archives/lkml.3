Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaHLOQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:16:05 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:49928 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaHLOQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140812100111.GV1657@lahna.fi.intel.com>
References: <1406217076-17150-1-git-send-email-tomasz.nowicki@linaro.org>
 <CACRpkdZmKJmaTRBpDrzd7+EhPuFeScr6jEHC8+0z6-4knjFqkA@mail.gmail.com> <20140812100111.GV1657@lahna.fi.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 12 Aug 2014 07:15:41 -0700
Message-ID: <CAAVeFuJiGcx3LgNoVLEa6kZPzBBdX1z2aSkAPNGs7G6nV+tF3Q@mail.gmail.com>
Subject: Re: [RFC] ACPI: Add GPIO-signaled event simulator.
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 3:01 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Fri, Aug 08, 2014 at 02:36:02PM +0200, Linus Walleij wrote:
>> On Thu, Jul 24, 2014 at 5:51 PM, Tomasz Nowicki
>> <tomasz.nowicki@linaro.org> wrote:
>>
>> > GPIO signaled events is quite new thing in Linux kernel.
>> > AFAIK, there are not many board which can take advantage of it.
>> > However, GPIO events are very useful feature during work on ACPI
>> > subsystems.
>>
>> Overall this seems like a pretty nice debug feature.
>>
>> > This commit emulates GPIO h/w behaviour and consists on read/write
>> > operation to debugfs file. GPIO device instance is still required in DSDT
>> > table along with _AEI resources and event methods.
>> >
>> > Reading from file provides pin to GPIO device map e.g. :
>> > $ cat /sys/kernel/debug/acpi/gpio_event
>> > GPIO device name: /__SB.GPI0
>> > Available GPIO pin map:
>> > /__SB.GPI0 <-> pin 0x100
>> >
>> > Based on that, user can trigger method corresponding to device pin number:
>> > $ echo "/__SB.GPI0 0x100" > /sys/kernel/debug/acpi/gpio_event
>>
>> I need input from Rafael and Mika as to whether this is a
>> good interface.
>
> Maybe it would make sense to move this into drivers/gpio/gpiolib-acpi.c
> and hide it behind some Kconfig entry?

I actually like that this feature is contained in its own file - it
makes it easier to Kconfig-isolate and keeps the base ACPI code short
and readable. We spent some effort decoupling the sysfs and legacy
interfaces from the main gpiolib source file, let's keep that policy
going. ;)

Maybe the source file could be renamed to highlight the fact this is
an ACPI-only feature, e.g. gpio-acpi-evt-emu.c? (let's also use '-' as
separator since this is what all GPIO drivers do).
