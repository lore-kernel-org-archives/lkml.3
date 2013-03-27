Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3C0MfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:35:04 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:38309 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3C0MfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <5152DE75.5010701@web.de>
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
	<20130326170203.GA23549@srcf.ucam.org>
	<5151D686.9070701@web.de>
	<20130326172103.GA24566@srcf.ucam.org>
	<5152DE75.5010701@web.de>
Date: Wed, 27 Mar 2013 08:35:01 -0400
Message-ID: <CADnq5_MECot=9sbnF3+dSX93qmkE4Er0hN2gv2cAKpEg2D8Stg@mail.gmail.com>
Subject: Re: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness level
 for sysfs control.
From: Alex Deucher <alexdeucher@gmail.com>
To: Danny Baumann <dannybaumann@web.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 7:56 AM, Danny Baumann <dannybaumann@web.de> wrote:
> Hi,
>
>>> Well, the ACPI spec says this (section B.5.2):
>>>
>>> "
>>> The OEM may define the number 0 as "Zero brightness" that can mean
>>> to turn off the lighting (e.g. LCD panel backlight) in the device.
>>> This may be useful in the case of an output device that can still be
>>> viewed using only ambient light, for example, a transflective LCD.
>>> "
>>>
>>> My interpretation of this is that the value 0 is supposed to still
>>> be visible. I'm pretty sure I saw a statement that 0 is supposed to
>>> mean "barely visible" somewhere, but can't find it at the moment.
>>> I'll search for the source of it.
>>
>>
>> I think that's a stretch - "This may be useful" isn't normative
>> language, "The OEM may define" is. But even if we do assert it for the
>> ACPI backlight, it's not true for other interfaces - zero backlight
>> intensity is supposed to be screen off on Apple hardware, for instance.
>
>
> OK, I see. And there is user space depending on that behaviour? And again -
> how is user space supposed to know about the behavioral differences? Is it
> something like 'if type is raw, don't expect anything'?
> The reason for my question is that I want to determine what a) the correct
> place to fix this and b) the correct fix is. As Xrandr abstracts away the
> used backlight interface, I see no way for user space using Xrandr (e.g.
> KDE) to meaningfully handle this.

In practice does it really matter?  As a user if you set the
brightness really low and you either can't see the screen or can
barely make it out does it matter if the screen is off or just really,
really dim?  The 0 brightness setting is probably not practically
usable regardless of what it does.

Alex
