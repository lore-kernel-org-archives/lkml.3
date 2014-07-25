Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbaGYNap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:30:45 -0400
Received: from si-002-i57.relay.mailchannels.net ([184.154.112.231]:8019 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868AbaGYNan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:30:43 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Message-ID: <1406295035.2664.43.camel@fedora-lan>
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver,
 series 2
From: Przemo Firszt <przemo@firszt.eu>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Fri, 25 Jul 2014 14:30:35 +0100
In-Reply-To: <20140725125820.GA12268@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
	 <1406292140.2664.17.camel@fedora-lan>
	 <20140725125820.GA12268@mail.corp.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-AuthUser: przemo@firszt.eu
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2014-07-25, pią o godzinie 08:58 -0400, Benjamin Tissoires pisze:
> Hi Przemo,
Hi Benjamin,
> On Jul 25 2014 or thereabouts, Przemo Firszt wrote:
> > Dnia 2014-07-24, czw o godzinie 14:13 -0400, Benjamin Tissoires pisze:
> > [..]
> > > Hi Przemo,
> > Hi Benjamin,
> > > Normally, this series contains all the bits of hid-wacom (except the custom
> > > LED/OLED API). Please tell me if I am missing anything and if you like the
> > > change.
> > 
> > I can't cleanly apply your set yet to test it, so:
> 
> Hmm, you need to apply the first series I sent on July 15th, on top of
> Dmitry's next branch.
> 
> http://www.spinics.net/lists/linux-input/msg32385.html
> 
OK, thnaks!
> > Acked-by: Przemo Firszt <przemo@firszt.eu>
> 
> Thanks!
> 
> > 
> > What's your plan about LED/OLED API? 
> 
> I thought I would only preserve the current, wider used, LED/OLED API and
> just drop the one in hid-wacom. This way, g-s-d will access both
> bluetooth and USB the same way.
> 
> My decision was mostly guided because the support of BT in g-s-d was
> only added recently (3.12 and backported to gnome 3.10 IIRC). And as
> soon as these patches hit Dmitry's tree, I'll send the g-s-d patches to
> fix all that.

If I understand you correctly we cannot have the same entry point in
sysfs for OLEDs unless we can tell userspace somehow if the tablet is
conected over USB or over bluetooth. The hardware of Intuos4 Wireless
over bluetooth allows only 1-bit images. The same hardware over USB
allows 4-bit images. Formatting of the images is also completely
different and it's not "plain". Check [1] for usb and exisitng
hid-wacom.c/wacom_scramble function for bluetooth.

If we want to make it consistent single entry on kernel level we
probably have to implement image conversion in the kernel. The user land
would always use 4-bit, plain formatted images and kernel driver would
convert them to 4-bit, wacom usb format or 1-bit wacom bluetooth format
depending on how the tablet is connected.

The downside of this approach is that the user land wouldn't have 100%
control over 1-bit images for bluetooth as kernel would have to create
them from 4-bit images.

[1] https://lkml.org/lkml/2012/9/9/80
-- 
Kind regards,
Przemo Firszt


