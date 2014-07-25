Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbaGYM6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:58:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760232AbaGYM6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:58:43 -0400
Date: Fri, 25 Jul 2014 08:58:20 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver, series
 2
Message-ID: <20140725125820.GA12268@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
 <1406292140.2664.17.camel@fedora-lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406292140.2664.17.camel@fedora-lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Przemo,

On Jul 25 2014 or thereabouts, Przemo Firszt wrote:
> Dnia 2014-07-24, czw o godzinie 14:13 -0400, Benjamin Tissoires pisze:
> [..]
> > Hi Przemo,
> Hi Benjamin,
> > Normally, this series contains all the bits of hid-wacom (except the custom
> > LED/OLED API). Please tell me if I am missing anything and if you like the
> > change.
> 
> I can't cleanly apply your set yet to test it, so:

Hmm, you need to apply the first series I sent on July 15th, on top of
Dmitry's next branch.

http://www.spinics.net/lists/linux-input/msg32385.html

> 
> Acked-by: Przemo Firszt <przemo@firszt.eu>

Thanks!

> 
> What's your plan about LED/OLED API? 

I thought I would only preserve the current, wider used, LED/OLED API and
just drop the one in hid-wacom. This way, g-s-d will access both
bluetooth and USB the same way.

My decision was mostly guided because the support of BT in g-s-d was
only added recently (3.12 and backported to gnome 3.10 IIRC). And as
soon as these patches hit Dmitry's tree, I'll send the g-s-d patches to
fix all that.

Cheers,
Benjamin

> 
> > Benjamin Tissoires (9):
> >   Input - wacom: put a flag when the led are initialized
> >   Input - wacom: enhance Wireless Receiver battery reporting
> >   Input - wacom: use a uniq name for the battery device
> >   Input - wacom: register an ac power supply for wireless devices
> >   Input - wacom: prepare the driver to include BT devices
> >   Input - wacom: handle Graphire BT tablets in wacom.ko
> >   Input - wacom: handle Intuos 4 BT in wacom.ko
> >   Input - wacom: add copyright note and bump version to 2.0
> >   HID: remove hid-wacom Bluetooth driver
> > 
> > Jason Gerecke (1):
> >   Input - wacom: Support up to 2048 pressure levels with ISDv4
> > 
> >  drivers/hid/Kconfig     |  10 +-
> >  drivers/hid/Makefile    |   3 +-
> >  drivers/hid/hid-core.c  |   2 -
> >  drivers/hid/hid-wacom.c | 973 ------------------------------------------------
> >  drivers/hid/wacom.h     |  11 +
> >  drivers/hid/wacom_sys.c | 217 ++++++++++-
> >  drivers/hid/wacom_wac.c | 195 +++++++++-
> >  drivers/hid/wacom_wac.h |  10 +
> >  8 files changed, 415 insertions(+), 1006 deletions(-)
> >  delete mode 100644 drivers/hid/hid-wacom.c
> > 
> 
> -- 
> Kind regards,
> Przemo Firszt
> 
> 
