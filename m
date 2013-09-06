Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3IFWv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:51:29 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62043 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3IFWv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:51:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130906215910.GA356@x4>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
	<CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
	<20130906215910.GA356@x4>
Date: Sat, 7 Sep 2013 00:51:27 +0200
Message-ID: <CANq1E4Q4mxKVJJEPNSb9kvUoMXc3KoAnxjnKd0Vx+hoGaeN=kg@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: David Herrmann <dh.herrmann@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Sep 6, 2013 at 11:59 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2013.09.06 at 23:50 +0200, David Herrmann wrote:
>> Hi
>>
>> On Fri, Sep 6, 2013 at 10:20 PM, Markus Trippelsdorf
>> <markus@trippelsdorf.de> wrote:
>> > On 2013.09.06 at 14:00 +0200, Jiri Kosina wrote:
>> >>
>> >> David Herrmann (12):
>> > ...
>> >>       HID: wiimote: add support for Guitar-Hero drums
>> >
>> >  commit 61e00655e9cb82e034eb72b95a51072e718d14a7
>> >  Author: David Herrmann <dh.herrmann@gmail.com>
>> >  Date:   Mon Aug 26 19:14:46 2013 +0200
>> >
>> >      Input: introduce BTN/ABS bits for drums and guitars
>> >
>> > The commit above breaks my Logitech mouse. The mouse cursor just sits in
>> > the middle of the screen and doesn't react to movements. dmesg is
>> > normal, but Xorg.0.log says:
>>
>> Ok, the issue is the kernel assumes ABS_MAX to be a power-of-2 minus 1
>> (used as mask). That wasn't really obvious to me. Attached is a patch
>> which should fix that. Could you apply it on top of linus/master and
>> give it a try?
>
> Your patch fixes the issue. Thanks.

Thanks a lot for reporting+testing!

I am still not sure how to solve the EVIOCSABS thingy. Problem is,
it's defined as:
  #define EVIOCSABS(_abs) ...0xc0 + (_abs)...
But if (_abs > 0x3f) this will be bigger than 0xff. Unfortunately, the
upper part of the ioctl is defined as 'E' which is 0x45 in hex and
thus sets the LSB. That means we cannot extend the _IOC_TYPE field to
the upper region (which would cause endian-issues, anyway). I guess
we're screwed here and need to revert that...

Dmitry, any comment on this? Or am I missing something?

Regards
David
