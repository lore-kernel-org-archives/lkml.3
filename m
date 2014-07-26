Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaGZLz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 07:55:58 -0400
Received: from si-002-i49.relay.mailchannels.net ([184.154.112.223]:5347 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbaGZLz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 07:55:56 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Message-ID: <1406375748.2611.0.camel@fedora-lan>
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver,
 series 2
From: Przemo Firszt <przemo@firszt.eu>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Sat, 26 Jul 2014 12:55:48 +0100
In-Reply-To: <20140725231509.GA2279@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
	 <1406326412.4674.22.camel@fedora-lan>
	 <20140725231509.GA2279@mail.corp.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-AuthUser: przemo@firszt.eu
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dnia 2014-07-25, pią o godzinie 19:15 -0400, Benjamin Tissoires pisze:
> [..]
Hi Bejnamin,
> > I don't remember for sure, but I think the range of brightness might be different
> > over usb and over bluetooth.
> 
> Maybe you can try setting the sysfs file "buttons_luminance" with the
> value 8 to check if this will solve the bug.
No, that doesn't make any difference.
 
> The bug might also be linked to the slight difference while setting up
> the transfer of the image (WAC_CMD_ICON_START) with the value of buf[1]
> set to 1 in USB, while it was 0 on bluetooth.
> 
> The weird thing is that I remembered having set the OLED (though
> scrambled) with these patches applied. I guess the scrambling was due to
> the 4-bit vs 1-bit. But I definitively had some results.
I spotted something:
hid-wacom:c (before modifications)
#define WAC_CMD_ICON_TRANSFER       0x26

wacom_sys.c: (after modifications)
#define WAC_CMD_ICON_XFER       0x23

Changing it fixes the problem. Patches to follow soon.
-- 
Kind regards,
Przemo Firszt


