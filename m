Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3C0L4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:56:41 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:46758 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3C0L4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:56:40 -0400
Message-ID: <5152DE75.5010701@web.de>
Date: Wed, 27 Mar 2013 12:56:37 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness level
 for sysfs control.
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de> <20130326170203.GA23549@srcf.ucam.org> <5151D686.9070701@web.de> <20130326172103.GA24566@srcf.ucam.org>
In-Reply-To: <20130326172103.GA24566@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1364385398-000004D6-3FAE65D8/0-0/0-0
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-03-27 12:56:38;ebf1cfd9add5f02d5173ace1fd3f60f9
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-03-27 12:56:38;4b5c11ae722a059e269755b935a5a00d
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

>> Well, the ACPI spec says this (section B.5.2):
>>
>> "
>> The OEM may define the number 0 as "Zero brightness" that can mean
>> to turn off the lighting (e.g. LCD panel backlight) in the device.
>> This may be useful in the case of an output device that can still be
>> viewed using only ambient light, for example, a transflective LCD.
>> "
>>
>> My interpretation of this is that the value 0 is supposed to still
>> be visible. I'm pretty sure I saw a statement that 0 is supposed to
>> mean "barely visible" somewhere, but can't find it at the moment.
>> I'll search for the source of it.
>
> I think that's a stretch - "This may be useful" isn't normative
> language, "The OEM may define" is. But even if we do assert it for the
> ACPI backlight, it's not true for other interfaces - zero backlight
> intensity is supposed to be screen off on Apple hardware, for instance.

OK, I see. And there is user space depending on that behaviour? And 
again - how is user space supposed to know about the behavioral 
differences? Is it something like 'if type is raw, don't expect anything'?
The reason for my question is that I want to determine what a) the 
correct place to fix this and b) the correct fix is. As Xrandr abstracts 
away the used backlight interface, I see no way for user space using 
Xrandr (e.g. KDE) to meaningfully handle this.

Thanks,

Danny
