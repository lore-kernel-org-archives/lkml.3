Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3AaLuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:50:10 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:61735 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3AaLuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:50:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130130232408.GL2637@n2100.arm.linux.org.uk>
References: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com>
	<1359558091-29251-2-git-send-email-ruslan.bilovol@ti.com>
	<alpine.LFD.2.02.1301301402330.6300@xanadu.home>
	<20130130232408.GL2637@n2100.arm.linux.org.uk>
Date: Thu, 31 Jan 2013 13:50:07 +0200
X-Google-Sender-Auth: 1tXQGW6bPBVMleBuF63Tfq10wIk
Message-ID: <CAB=otbQuJR75BSxtB8BHdLaTKYkPWp3jvuT3pRognHY5O6pP+Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/2] ARM: kernel: update cpuinfo to print SoC model name
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, eduardo.valentin@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 1:24 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 30, 2013 at 02:07:53PM -0500, Nicolas Pitre wrote:
>> On Wed, 30 Jan 2013, Ruslan Bilovol wrote:
>>
>> > Currently, reading /proc/cpuinfo provides userspace with CPU ID of
>> > the CPU carrying out the read from the file.
>> > Userspace using this information may decide what module
>> > to load or how to configure some specific (and processor-depended)
>> > settings or so.
>> > However, since really different SoCs can share same ARM core,
>> > this information currently is not so useful.
>> > For example, TI OMAP4460 and OMAP4470 SoCs show the same
>> > information in the /proc/cpuinfo whereas they are different.
>> > Since in most cases ARM CPU is a part of some system on a chip (SoC),
>> > the "cpuinfo" file looks like exactly that place, where this
>> > information have to be displayed.
>> >
>> > So added new line "SoC name" in the "cpuinfo" output for system
>> > on a chip name. It is placed between CPU information and machine
>> > information, so the file structure looks gracefully (CPU-SoC-Hardware)
>> >
>> > Example:
>> >
>> > / # cat proc/cpuinfo
>> > [...]
>> > CPU variant     : 0x2
>> > CPU part        : 0xc09
>> > CPU revision    : 10
>> >
>> > SoC name        : OMAP4470
>> >
>> > Hardware        : OMAP4 Blaze Tablet
>>
>> Please remove that extra blank line between "SoC name" and "Hardware".
>> The blank line after "CPU revision" is fine.
>>
>> Also, please rename this to "System name".  Not all systems are "on
>> chip".  By using "System name" this is more universally useful.
>
> You may notice I've already suggested that this should be using the SoC
> infrastructure to export this information, which was explicitly designed
> to do this.
>
> If we're going to have one SoC doing one thing and another SoC exporting
> this information a completely different way, we're doomed.  We need to
> make a decision and do it one way and one way only - and that decision
> was made when drivers/base/soc.c was merged.
>
> Unfortunately, I'd forgotten about that when I made my initial comments
> about the difference between "CPU" and "SoC".

Yes agree - let's stop this discussion at this point. I'm going to
learn that soc framework and provide better solution.
Unfortunately, I didn't find it when looked into the kernel sources
for similar approaches.

Regards,
Ruslan
