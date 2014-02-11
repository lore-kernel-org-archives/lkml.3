Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaBKITK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:19:10 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63278 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaBKITG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:19:06 -0500
MIME-Version: 1.0
In-Reply-To: <20140211085014.4ef32b56@endymion.delvare>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
	<20140210160842.GB26997@lee--X1>
	<20140210173811.04ba5964@endymion.delvare>
	<CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
	<20140211085014.4ef32b56@endymion.delvare>
Date: Tue, 11 Feb 2014 08:19:01 +0000
X-Google-Sender-Auth: DOfMlZzURzm4GL1FjfZuclYtkdY
Message-ID: <CAOMwXhOiK_V4vHru3bmXHW5E0cdb6t4DDoWrSA=BmBxW0WcrzA@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 7:50 AM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Laszlo,
>
> On Tue, 11 Feb 2014 03:13:37 +0000, Laszlo Papp wrote:
>> On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
>> > Additionally, dashes are explicitly forbidden in hwmon
>> > device names.
>>
>> Also, where is that documented?
>
> In Documentation/hwmon/sysfs-interface:
>
> *********************
> * Global attributes *
> *********************
>
> name            The chip name.
>                 This should be a short, lowercase string, not containing
>                 spaces nor dashes, representing the chip name. This is
>                 the only mandatory attribute.
>                 I2C devices get this attribute created automatically.
>                 RO
>
>> I do not think you can make such a decision, and you will realize that
>> once you begin to think a bit out of the box and look around. See how
>> other children are managed for MFD devices. "driver-subsystem" is a
>> pretty common a schema. I do not really see any point in forbidding
>> dashes currently. Please do elaborate about the reasons, and the fact
>> that why it is undocuemented.
>
> It is documented since August 2007 [1], and stop with this tone,
> please. The more you talk, the less I want to help you. Guenter already
> gave up on you, I might as well do the same.

My reply is reflecting the frustration coming from the wasted man
months caused by the miscommunication. I cannot step over it easily I
am afraid. Please assume good faith though... I was writing this in
the hope of this situation never ever happening again, so everyone
feels better in the future.

If I can also drop in my two cents, I would like to note that I also
feel bad about the no sign of regret.

> I did not "make" the decision, it is a limitation implied by the way
> libsensors creates unique and persistent identifiers for hwmon devices.
> These identifiers are of the form ${name}-${bus}-${address}, where
> ${bus} can (but doesn't have to) be of the form ${type}-${number}. If
> ${name} contains a dash then parsing the identifier becomes ambiguous,
> as you can no longer easily tell where ${name} ends and where ${bus}
> begins.
>
>> Also, I currently do not understand what you are suggesting: just
>> leave this technically unreasonable situation as is for compatibility
>> reasons? There is no better support in place for appending further
>> alternative names?
>
> There's nothing unreasonable about the situation. Yes, compatibility
> matters, it matters a lot even, and we do our best to guarantee that
> users can move to a more recent kernel without breaking anything that
> was previously working. I certainly hope other open source project
> maintainers and developers do the same.

My post was not actually about compatibility... It was about the fact
that there was no alternative way presented what should be done. That
is, not in an understandable way for me at least.

In any case, please consider rejecting "global names" for MFD chips in
the future for hwmon. This is my personal two cents.

> I already explained (but apparently you were to busy yelling at Guenter
> and myself to notice) that the hwmon device name (which is the one we
> can't change) can now be dissociated from the i2c (or platform) device
> name, thanks to Guenter's excellent work. This is exactly the solution
> to your problem, so there's no need sound dramatic.

Sorry, but I wished to raise the maintainer issue regardless how you
take them. I can assure you that I have done it only with good faith,
so the same mistake never ever happens again.

That being said, I really do not understand what you are writing, so I
guess I would need more details to proceed. Please give a more
thorough explanation that newcomers can also understand. Currently, it
is unclear to me what you are trying to write.

I already asked in the beginning of this thread if it is possible to
add the alternative ids to the list instead of renaming them. I do not
seem to have gotten replies to that.

>> In any case, at the very least, I hope the lesson is learnt for the
>> future from this past mistake. If a chip is MFD'ish, a subdevice
>> driver should not ever be added with such an id.
>
> You can't always anticipate this kind of thing. If you wait until
> you're certain your design (and code) is perfect and will never need
> to be changed, then you'll never release any piece of software. That
> code you just wrote and submitted, and you believe is perfect, guess
> what? Next year someone will call it crap and blame it on you for not
> putting enough thinking into it.

I personally think you are underestimating the issue here. As far as I
can tell, the datasheet is pretty short for this chip, and someone
reading it through surely gets the idea this chip is not at all about
just hwmon. I am not saying people do not do mistakes, but I am
encouraging you to learn the lesson with good intention so that this
can be avoided in the future.

Perhaps the datasheet was not read completely, and the feature was
added haskily... I do not know, but currently I cannot imagine it
otherwise.

> There was little reason to believe that the max6650 driver would become
> a MFD driver at the time is was written (10 years ago [2].) The concept
> of MFD driver did not even exist then. We have several hwmon drivers
> implementing side features (such as watchdog) without using the MFD
> framework. I still believe using the MFD framework to support the
> MAX6650 and MAX6651 is overkill, BTW, so even today I wouldn't
> anticipate it. Which does _not_ mean I'll reject the attempt to do so,
> contrary to what you repeatedly claimed in various posts of this
> discussion.
>
> You sent one patch, I reviewed it, found it was broken, and explained
> why. In great details, I believe. Did you actually read my review? Did
> you understand it?

No, I have not understand it, sorry. Could you please elaborate more?

> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/Documentation/hwmon/sysfs-interface?id=176544dc55b0a912a2e1bacb9f48ccbd4aabd55f
> [2] http://www.lm-sensors.org/browser/lm-sensors/trunk/kernel/chips/max6650.c?rev=1987
>
> --
> Jean Delvare
> Suse L3 Support
