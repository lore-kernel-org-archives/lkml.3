Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbbA2Cyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:54:45 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:57024 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbbA2Cyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:54:43 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127174818.GM26493@n2100.arm.linux.org.uk> <20150128005032.GK28663@atomide.com>
 <201501281458.22088@pali> <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 28 Jan 2015 09:57:18 -0600
Message-ID: <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
To: Nicolas Pitre <nico@fluxnic.net>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 8:33 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 28 Jan 2015, Pali Rohár wrote:
>
>> On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
>> > On omaps, the bootrom passes the bootreason in r1 to the
>> > bootloader that can do whatever it wants with it. We could
>> > maybe pass it in the kernel cmdline to the watchdog driver
>> > for user space?
>> >
>>
>> Not truth for N900. Bootreason depends on PRM_RSTST omap
>> register, state of vbat charger pins, time how long was power key
>> pressed, R&D data stored in CAL partition and other undocumented
>> registers for omap HS devices. I already tried to implement at
>> least some subset of it in userspace (or kernel), but it is
>> impossible because NOLO bootloader clear status of PRM_RSTST
>> register.
>>
>> There is also copy of PRM_RSTST register stored at address
>> 0x4020FFB8 (tracing data) but that address is rewritten (probably
>> by kernel), so we really cannot implement reading bootreason in
>> kernel.
>>
>> But in early stage in uboot it is possible to read 0x4020FFB8
>> address and get some part of bootreason. But still PRM_RSTST is
>> not enough!
>>
>> I would be happy if DT kernel can export /proc/atags file with
>> ATAGs passed by bootloader. It would be enough for me. In
>> userspace I can parse content and do what is needed.
>
> What about defining a DT boot reason property instead?
> Maybe it already exists?  If not, it's something that could certainly be
> generically used on other platforms too.

I'm fine with that, but we just need to have a standard kernel
userspace interface in addition to something like
/proc/device-tree/bootreason. Perhaps this can be the default
implementation for the watchdog dev. Someday when we decide DT is crap
and have a new boot interface, we'll have people relying on
/proc/device-tree. I hope to be retired when that happens...

Rob
