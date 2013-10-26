Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3JZUWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:22:23 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4021 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JZUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:22:17 -0400
Message-ID: <2099a1da904181598455905c79a7921d.squirrel@webmail.xs4all.nl>
In-Reply-To: <201310262204.33674@pali>
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com>
    <525D5A77.4050704@xs4all.nl> <201310172131.05106@pali>
    <201310262204.33674@pali>
Date: Sat, 26 Oct 2013 22:22:09 +0200
Subject: Re: [PATCH] media: Add BCM2048 radio driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: Pali =?iso-8859-1?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        "Eero Nurkkala" <ext-eero.nurkkala@nokia.com>,
        "Nils Faerber" <nils.faerber@kernelconcepts.de>,
        "Joni Lapilainen" <joni.lapilainen@gmail.com>
User-Agent: SquirrelMail/1.4.18
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hans, so can it be added to drivers/staging/media tree?

Yes, that is an option. It's up to you to decide what you want. Note that
if no cleanup work is done on the staging driver for a long time, then it
can be removed again.

Regards,

    Hans

>
> On Thursday 17 October 2013 21:31:04 Pali Rohár wrote:
>> Hello,
>>
>> so what do you suggest? Add it to staging for now (or not)?
>>
>> On Tuesday 15 October 2013 17:08:39 Hans Verkuil wrote:
>> > Hi Pali,
>> >
>> > Thanks for the patch, but I am afraid it will need some work
>> > to make this acceptable for inclusion into the kernel.
>> >
>> > The main thing you need to do is to implement all the
>> > controls using the control framework (see
>> > Documentation/video4linux/v4l2-controls.txt). Most drivers
>> > are by now converted to the control framework, so you will
>> > find many examples of how to do this in drivers/media/radio.
>> >
>> > The sysfs stuff should be replaced by controls as well. A
>> > lot of the RDS support is now available as controls
>> > (although there may well be some missing features, but that
>> > is easy enough to add). Since the RDS data is actually
>> > read() from the device I am not sure whether the RDS
>> > properties/controls should be there at all.
>> >
>> > Finally this driver should probably be split up into two
>> > parts: one v4l2_subdev-based core driver and one platform
>> > driver. See e.g. radio-si4713/si4713-i2c.c as a good
>> > example. But I would wait with that until the rest of the
>> > driver is cleaned up. Then I have a better idea of whether
>> > this is necessary or not.
>> >
>> > It's also very useful to run v4l2-compliance (available in
>> > the v4l-utils.git repo on git.linuxtv.org). That does lots
>> > of sanity checks.
>> >
>> > Another option is to add the driver as-is to
>> > drivers/staging/media, and clean it up bit by bit.
>> >
>> > Regards,
>> >
>> > 	Hans
>> >
>> > On 10/15/2013 04:26 PM, Pali Rohár wrote:
>> > > This adds support for the BCM2048 radio module found in
>> > > Nokia N900
>> > >
>> > > Signed-off-by: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
>> > > Signed-off-by: Nils Faerber
>> > > <nils.faerber@kernelconcepts.de> Signed-off-by: Joni
>> > > Lapilainen <joni.lapilainen@gmail.com> Signed-off-by:
>> > > Pali Rohár <pali.rohar@gmail.com>
>> > > ---
>> > >
>> > >  drivers/media/radio/Kconfig         |   10 +
>> > >  drivers/media/radio/Makefile        |    1 +
>> > >  drivers/media/radio/radio-bcm2048.c | 2744
>> > >  +++++++++++++++++++++++++++++++++++
>> > >  include/media/radio-bcm2048.h       |   30 +
>> > >  4 files changed, 2785 insertions(+)
>> > >  create mode 100644 drivers/media/radio/radio-bcm2048.c
>> > >  create mode 100644 include/media/radio-bcm2048.h
>
> --
> Pali Rohár
> pali.rohar@gmail.com
>


