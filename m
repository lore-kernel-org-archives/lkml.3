Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaC1UZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:25:35 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43215 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaC1UZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:25:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140328160924.GB22658@core.coreip.homeip.net>
References: <1394207364-4235-1-git-send-email-benjamin.tissoires@redhat.com>
	<20140328082949.GJ22093@core.coreip.homeip.net>
	<20140328160924.GB22658@core.coreip.homeip.net>
Date: Fri, 28 Mar 2014 16:25:30 -0400
Message-ID: <CAN+gG=FruH=Z7gS5LHBB0gu78wUQzOX4sM26fkiCp94T4p0LRw@mail.gmail.com>
Subject: Re: [PATCH] Input: synaptics add manual min/max quirk
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christopher Heiny <cheiny@synaptics.com>,
        Andrew Duggan <aduggan@synaptics.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Stephen Chandler Paul <thatslyude@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 12:09 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Mar 28, 2014 at 01:29:50AM -0700, Dmitry Torokhov wrote:
>> On Fri, Mar 07, 2014 at 10:49:24AM -0500, Benjamin Tissoires wrote:
>> > The new Lenovo Haswell series (-40's) contains a new Synaptics touchpad.
>> > However, these new Synaptics devices report bad axis ranges.
>> > Under Windows, it is not a problem because the Windows driver uses RMI4
>> > over SMBus to talk to the device. Under Linux, we are using the PS/2
>> > fallback interface and it occurs the reported ranges are wrong.
>> >
>> > Of course, it would be too easy to have only one range for the whole
>> > series, each touchpad seems to be calibrated in a different way.
>> >
>> > We can not use SMBus to get the actual range because I suspect the firmware
>> > will switch into the SMBus mode and stop talking through PS/2 (this is the
>> > case for hybrid HID over I2C / PS/2 Synaptics touchpads).
>> >
>> > So as a temporary solution (until RMI4 land into upstream), start a new
>> > list of quirks with the min/max manually set.
>> >
>> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> > CC: stable@vger.kernel.org
>>
>>
>> Applied, thank you.
>
> That was giving compiler errors when configured without synaptics
> support so I had fiddle with the patch a bit. I'll take full
> responsibility for any breakage ;)
>

Thanks for fixing it. Tested and approved by myself, so no breakage to
report here :)

BTW, I have to send out also the min/max for the new X1 Carbon and the
Yoga (not the 2)... I am wondering how to make sure the kernel will
discriminate the Yoga from the Yoga 2 now :/

I'll come back as soon as I can.

Cheers,
Benjamin
