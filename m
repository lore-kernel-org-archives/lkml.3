Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3BFRKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:10:45 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:52767 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3BFRKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <20130206131655.GH8696@gmail.com>
References: <20130204110304.GD24173@gmail.com>
	<1360009767-3633-1-git-send-email-yinghai@kernel.org>
	<20130205122432.GE21455@gmail.com>
	<CAE9FiQXn1P0RGD-O3jeFNgAdsfv4EQyH8g7r0x3KBFfh20fF=Q@mail.gmail.com>
	<20130206131655.GH8696@gmail.com>
Date: Wed, 6 Feb 2013 09:10:43 -0800
X-Google-Sender-Auth: iiddGyKV3R7tNt6v1uCOXd09nsI
Message-ID: <CAE9FiQVT7Q1=NOcTvzkmskQLpfvuX+JSW_9NBXjx7z77TDHz3Q@mail.gmail.com>
Subject: Re: [PATCH] x86, apic: Check fadt x2apic phys in x2apic_phys_probe()
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Stoney Wang <song-bo.wang@hp.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 5:16 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Tue, Feb 5, 2013 at 4:24 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Yinghai Lu <yinghai@kernel.org> wrote:
>> >
>> >> From: Stoney Wang <song-bo.wang@hp.com>
>> >>
>> >> When HP ProLiant DL980 G7 Server boot without x2apic_phys, there will be
>> >> intermittent lost interrupts and could result in a hang or data loss.
>> >
>> > What does 'boot without x2apic_phys' mean?
>> >
>> > Does it mean x2apic_phys=0 boot command line? Or, because
>> > x2apic_phys is off by default, does it simply mean that if it's
>> > booted with a default kernel, without any workaround specified
>> > on the boot command line?
>>
>> means that user does not append "x2apic_phys" in boot command line.
>
> The user does not append a whole lot of other
> behavior-modification command line options either! There's no
> apic=0 line either. Nor smp=0.
>
> Adding this essentially irrelevant piece of information to the
> *FIRST*, most important sentence of the changelog is thus not
> just confusing but utterly misleading. Communications 101.

Those system should not be out of the door with buggy bios.
Assume that HP would have release notes that require user to append
"x2apic_phys"

>
> Instead it should say something like:
>
>    When a HP ProLiant DL980 G7 Server boots a regular kernel,
>    there will be intermittent lost interrupts which could
>    result in a hang or (in extreme cases) data loss.
>
>    The reason is that this system only supports x2apic physical
>    mode, while the kernel boots with a logical-cluster default
>    setting.
>
>    This bug can be worked around by specifying the x2apic_phys=1
>    boot option, but we want to handle this sytem without
>    requiring manual workarounds.
>
> Right? Writing a clean changelog is like writing clean code -
> you have to learn it if you want to contribute to the kernel
> smoothly. Think of it as an engineering task: the other required
> half of modifying kernel code.

Yes. that is clean. just want to  update the workaround words to
"x2apic_phys" or "nox2apic"

   This bug can be worked around by specifying "x2apic_phys" or
   "nox2apic" boot option, but we want to handle this system without
   requiring manual workarounds.

Will continue to work on writing clean changelog.

Thanks

Yinghai
