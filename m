Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab3IGRM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 13:12:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51604 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3IGRM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 13:12:57 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CANq1E4ROgWt2oZt9BVgt4uzmHDfTy6DBzTswHvH=ziVRkjfXvg@mail.gmail.com>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz> <20130906202022.GA353@x4> <CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com> <CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com> <506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com> <CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com> <20130907032240.GA1256@core.coreip.homeip.net> <CANq1E4Q85ewwKs7VoooZVapC7-Cvy6-Xp4rGL1-1Ee7w1EcT6w@mail.gmail.com> <CAN+gG=Ge2dKvNvT=cY-QFiV=LMV7rddMs9APCb0v68yMGns1Ew@mail.gmail.com> <CANq1E4TqJME-aFaMgCUO6XGUpCcz6ms9KDL2uhdxnx3rz6nN0w@mail.gmail.com> <522AEFE9.30402@gmail.com> <CANq1E4ROgWt2oZt9BVgt4uzmHDfTy6DBzTswHvH=ziVRkjfXvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT] HID for 3.12 merge window
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sat, 07 Sep 2013 10:12:36 -0700
To: David Herrmann <dh.herrmann@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Message-ID: <131b9a98-59d8-47e8-83df-e59aff14c285@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Herrmann <dh.herrmann@gmail.com> wrote:
>Hi
>
>On Sat, Sep 7, 2013 at 11:20 AM, Benjamin Tissoires
><benjamin.tissoires@gmail.com> wrote:
>>
>>
>> On 07/09/13 10:57, David Herrmann wrote:
>>> Hi
>>>
>>> On Sat, Sep 7, 2013 at 10:24 AM, Benjamin Tissoires
>>>> I'm not particularly in favor of adding semantic between ABS_MISC
>and
>>>> ABS_MT_SLOT. We already did that once with the ABS_MT_* stuff, and
>the
>>>> problem comes from devices showing several axes, not really mapped
>>>> (like joysticks). These axes are all mapped to ABS_MISC, but the
>input
>>>> core function map them to ABS_MISC+N. This way some joysticks show
>>>> multitouch axes and are treated as such, whereas the axis are just
>>>> regular absolute axes. (not sure I am clear enough... :( )
>>>>
>>>> Currently, nothing is done in X or in Wayland to detect these false
>>>> multitouch devices with a large number of absolute axes. But if we
>>>> keep a hole between ABS_MISC and ABS_MT_SLOT, we could add an
>>>> heuristic like:
>>>> "if all the axes between ABS_MISC and ABS_MT_SLOT are available,
>then
>>>> ABS_MT_SLOT does not mean multitouch, but ABS_MISC+6."
>>>
>>> So Xorg just took control over the unused ABS_* slots? Hmm, then I
>>> have no other idea than reverting the 3 patches.
>>> Sadly, that also means there's no way for us to easily extend the
>>> ABS_* bits. If someone has an idea, let me know. But for now I'll
>just
>>> put the drums/guitar patches on hold.
>>>
>>
>> Well, I would say the "problem" lies in hid-input.c, line 919:
>>>>>>>>>>>>>>>>>>>>
>>         while (usage->code <= max && test_and_set_bit(usage->code,
>bit))
>>                 usage->code = find_next_zero_bit(bit, max + 1,
>usage->code);
>>>>>>>>>>>>>>>>>>>>
>>
>> So if you try to map several times ABS_MISC or any other axis, then
>you are mapping ABS_MISC+N.
>>
>> Anyway, the only problematic axis is ABS_MISC, as it is a default
>fallback. IMO, we can extend the ABS_* definitions after ABS_MT_TOOL_Y,
>like the original patch you proposed without having to deal with the
>above problem (though this will report the patch series to v3.13).
>> To prevent future mistakes, we should just define ABS_MISC0 (0x29) to
>ABS_MISC5 (0x2e) to fill the hole.
>
>As mentioned earlier in this thread, ABS_* is limited to 0x3f, so we
>have only 2 more free slots after ABS_MT_TOOL_Y.
>We will figure something out for 3.13.
>
>I will also prepare a patch for ABS_MISC0-MISC5.
>

Regardless of whether we settle on using lower bits or bite the bullet and extend number of axis I think it's time for EVIOCGABS2 that would take axis in its argument instead of encoding it in ioctl number - that idea wasn't that good.


Thanks.

-- 
Dmitry
