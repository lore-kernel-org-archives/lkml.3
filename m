Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3A3UiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:38:16 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43506 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3A3UiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1301301402330.6300@xanadu.home>
References: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com>
 <1359558091-29251-2-git-send-email-ruslan.bilovol@ti.com> <alpine.LFD.2.02.1301301402330.6300@xanadu.home>
From: Matt Sealey <matt@genesi-usa.com>
Date: Wed, 30 Jan 2013 14:37:53 -0600
Message-ID: <CAKGA1bncYCAwvU1-ZYkAYd_RGUvqq4NCWDeV5EXt4Z6qrgr3Sw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/2] ARM: kernel: update cpuinfo to print SoC model name
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Ruslan Bilovol <ruslan.bilovol@ti.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        tony@atomide.com, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        eduardo.valentin@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 1:07 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 30 Jan 2013, Ruslan Bilovol wrote:
>
>> Currently, reading /proc/cpuinfo provides userspace with CPU ID of
>> the CPU carrying out the read from the file.
>> Userspace using this information may decide what module
>> to load or how to configure some specific (and processor-depended)
>> settings or so.
>> However, since really different SoCs can share same ARM core,
>> this information currently is not so useful.
>> For example, TI OMAP4460 and OMAP4470 SoCs show the same
>> information in the /proc/cpuinfo whereas they are different.
>> Since in most cases ARM CPU is a part of some system on a chip (SoC),
>> the "cpuinfo" file looks like exactly that place, where this
>> information have to be displayed.
>>
>> So added new line "SoC name" in the "cpuinfo" output for system
>> on a chip name. It is placed between CPU information and machine
>> information, so the file structure looks gracefully (CPU-SoC-Hardware)
>>
>> Example:
>>
>> / # cat proc/cpuinfo
>> [...]
>> CPU variant     : 0x2
>> CPU part        : 0xc09
>> CPU revision    : 10
>>
>> SoC name        : OMAP4470
>>
>> Hardware        : OMAP4 Blaze Tablet
>
> Please remove that extra blank line between "SoC name" and "Hardware".
> The blank line after "CPU revision" is fine.
>
> Also, please rename this to "System name".  Not all systems are "on
> chip".  By using "System name" this is more universally useful.

I can't agree with "System name", it is confusing in common
terminology since it's about the same definition as the current
"Hardware" line.

If we're just printing out the name of the device surrounding the CPU
- be it a Northbridge/Southbridge combination or SoC packaging -
"Chipset" might be a better name for it.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
