Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab3IGRbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 13:31:07 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:53482 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IGRbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 13:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFye+TFiXPeJhB9fJjUcMR6LynjsZU+sjckKk2YoYOZDnw@mail.gmail.com>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
	<CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
	<CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
	<506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
	<CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com>
	<20130907032240.GA1256@core.coreip.homeip.net>
	<CANq1E4Q85ewwKs7VoooZVapC7-Cvy6-Xp4rGL1-1Ee7w1EcT6w@mail.gmail.com>
	<CA+55aFye+TFiXPeJhB9fJjUcMR6LynjsZU+sjckKk2YoYOZDnw@mail.gmail.com>
Date: Sat, 7 Sep 2013 19:31:02 +0200
Message-ID: <CANq1E4Qag351rbnDb7M+tu2OJ5WWk6n2hzhatVukjrFyw8BL9g@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: David Herrmann <dh.herrmann@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

On Sat, Sep 7, 2013 at 6:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Sep 7, 2013 at 12:31 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>>
>> The bug only occurs for multi-touch devices (their ABS_* bits are
>>>0x1f), that's why I didn't see it happening during my tests..
>
> It definitely affects keyboards too. That's how I noticed it. That is
> with the logitech "universal" receiver, though, so maybe that counts
> as a potential multi-touch device..

I have been quite wrong with that statement, yepp. xorg-evdev fetches
the whole device-information. So if a keyboard provides an affected
ABS_* bit, it'll break, too. My ancient hardware didn't use any of the
higher ABS bits, though.
I'm sorry for the troubles caused. ABS_MAX must be at most 0x3f. So
please, go ahead and revert the 3 mentioned patches.

Thanks
David
