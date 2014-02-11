Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaBKLJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 06:09:22 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39678 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaBKLJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:09:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhMzaymrV4qF+jR5rPo-ve_YV5-GpRSwVvGC83CCaUg0Yg@mail.gmail.com>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
	<20140211085014.4ef32b56@endymion.delvare>
	<CAOMwXhMhKdp420+SPTih+C3fAgTmrpJgPnGBxsfPO3pEhESGTA@mail.gmail.com>
	<20140211085053.GD32042@lee--X1>
	<CAOMwXhMzaymrV4qF+jR5rPo-ve_YV5-GpRSwVvGC83CCaUg0Yg@mail.gmail.com>
Date: Tue, 11 Feb 2014 11:09:19 +0000
X-Google-Sender-Auth: ZKoREmsxFnL1O0Kkm41kIaA2Fr8
Message-ID: <CAOMwXhMDJN9e+QRSww8KWiVsb0++CEF-VmzgESuECWfRAn8fSQ@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 10:22 AM, Laszlo Papp <lpapp@kde.org> wrote:
> On Tue, Feb 11, 2014 at 8:50 AM, Lee Jones <lee.jones@linaro.org> wrote:
>>> >> On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
>>> >> > Additionally, dashes are explicitly forbidden in hwmon
>>> >> > device names.
>>> >>
>>> >> Also, where is that documented?
>>> >
>>> > In Documentation/hwmon/sysfs-interface:
>>> >
>>> > *********************
>>> > * Global attributes *
>>> > *********************
>>> >
>>> > name            The chip name.
>>> >                 This should be a short, lowercase string, not containing
>>> >                 spaces nor dashes, representing the chip name. This is
>>> >                 the only mandatory attribute.
>>> >                 I2C devices get this attribute created automatically.
>>> >                 RO
>>>
>>> Time to revisit this decision....
>>>
>>> So, based on the fact that children device names usually contain
>>> dashes, I do not understand why hwmon would be any special in this
>>> regard. It is possible that the hwmon developers have not faced much
>>> MFD situation before, and so, this was not considered to be handled
>>> like in other subsystems.
>>>
>>> I am proposing to change this "rule"...  Any objection?
>>
>> Prior to proposing such an invasive change which is highly likely to
>> come up against heavy opposition, why don't you try to work _with_ the
>> current ruling and the Maintainers to see what others have done to
>> solve the problem.  I highly doubt you are the first/only developer who
>> has had this issue.
>>
>> Do:
>>   `git grep "\-hwmon"`
>>
>> ... and have a good look around for an accepted solution.
>
> Well, this did not bring up relevant results, at least for my
> understanding, but I will send a new patch with the
> devm_hwmon_device_register_
> with_groups() stuff based on my little understanding without further help.

https://lkml.org/lkml/2014/2/11/155

but I do not know how to enable the different devices conditionally.
What is the best practice for this in the kernel? (We can continue it
in there)
