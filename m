Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3C0M40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:56:26 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:60076 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3C0M4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:56:24 -0400
Message-ID: <5152EC74.1050706@web.de>
Date: Wed, 27 Mar 2013 13:56:20 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness level
 for sysfs control.
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de> <20130326170203.GA23549@srcf.ucam.org> <5151D686.9070701@web.de> <20130326172103.GA24566@srcf.ucam.org> <5152DE75.5010701@web.de> <CADnq5_MECot=9sbnF3+dSX93qmkE4Er0hN2gv2cAKpEg2D8Stg@mail.gmail.com>
In-Reply-To: <CADnq5_MECot=9sbnF3+dSX93qmkE4Er0hN2gv2cAKpEg2D8Stg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1364388981-000004D6-8AFC78D4/0-0/0-0
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-03-27 13:56:21;de46256fc342d332929fda19593901b3
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-03-27 13:56:22;0682b74cbf904235927df4781ddcdc26
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail provider
 *      (dannybaumann[at]web.de)
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>>> Well, the ACPI spec says this (section B.5.2):
>>>>
>>>> "
>>>> The OEM may define the number 0 as "Zero brightness" that can mean
>>>> to turn off the lighting (e.g. LCD panel backlight) in the device.
>>>> This may be useful in the case of an output device that can still be
>>>> viewed using only ambient light, for example, a transflective LCD.
>>>> "
>>>>
>>>> My interpretation of this is that the value 0 is supposed to still
>>>> be visible. I'm pretty sure I saw a statement that 0 is supposed to
>>>> mean "barely visible" somewhere, but can't find it at the moment.
>>>> I'll search for the source of it.

BTW, I found the source for that statement: [1], section 
System.Client.BrightnessControls.SmoothBrightness. While formally it's 
not part of the ACPI spec, I'm pretty sure most vendors (except Apple, 
obviously) will follow it as if it were, if not more strictly.

>> OK, I see. And there is user space depending on that behaviour? And again -
>> how is user space supposed to know about the behavioral differences? Is it
>> something like 'if type is raw, don't expect anything'?
>> The reason for my question is that I want to determine what a) the correct
>> place to fix this and b) the correct fix is. As Xrandr abstracts away the
>> used backlight interface, I see no way for user space using Xrandr (e.g.
>> KDE) to meaningfully handle this.
>
> In practice does it really matter?  As a user if you set the
> brightness really low and you either can't see the screen or can
> barely make it out does it matter if the screen is off or just really,
> really dim?  The 0 brightness setting is probably not practically
> usable regardless of what it does.

That's right. I'm not intending to use the laptop with that low 
brightness, though, I'd just like to distinguish between my laptop being 
turned off / suspended or just its display being dimmed down by the 
desktop environment to conserve power. In order to do the latter, KDE 
sets brightness to 0 ([2]), which worked fine for me as long as 
acpi_video was working on this laptop. This isn't the case at present, 
which is why I'm using intel_backlight at the moment. As you may have 
noticed, things aren't working as expected with it, which in turn is 
what brought me over here ;) I'm fine with sending a patch to KDE if 
that's the correct thing to do, but I'm not yet sure what the correct 
thing to do is.

Thanks,

Danny

[1] http://msdn.microsoft.com/en-us/library/windows/hardware/jj128256.aspx
[2] 
https://projects.kde.org/projects/kde/kde-workspace/repository/revisions/master/entry/powerdevil/daemon/actions/bundled/dimdisplay.cpp#L53
