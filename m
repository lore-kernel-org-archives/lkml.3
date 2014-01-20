Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaATWPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:15:06 -0500
Received: from leo.clearchain.com ([199.73.29.74]:39753 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaATWPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:15:03 -0500
Date: Tue, 21 Jan 2014 08:18:21 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] input/uinput: add UI_GET_SYSNAME ioctl to retrieve
 the sysfs path
Message-ID: <20140120221821.GA6763@yabbi.local>
References: <1389985971-541-1-git-send-email-benjamin.tissoires@redhat.com>
 <20140120215313.GB4270@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120215313.GB4270@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.7 (mail.clearchain.com [127.0.0.1]); Tue, 21 Jan 2014 08:44:58 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 01:53:13PM -0800, Dmitry Torokhov wrote:
> Hi Benjamin,
> 
> On Fri, Jan 17, 2014 at 02:12:51PM -0500, Benjamin Tissoires wrote:
> > Evemu [1] uses uinput to replay devices traces it has recorded. However,
> > the way evemu uses uinput is slightly different from how uinput is
> > supposed to be used.
> > Evemu relies on libevdev, which creates the device node through uinput.
> > It then injects events through the input device node directly (and it
> > completely skips the uinput node).
> > 
> > Currently, libevdev relies on an heuristic to guess which input node was
> > created. The problem is that is heuristic is subjected to races between
> > different uinput devices or even with physical devices. Having a way
> > to retrieve the sysfs path allows us to find the event node without
> > having to rely on this heuristic.
> 
> I have been thinking about it and I think that providing tight coupling
> between uinput and resulting event device is wrong thing to do. We do
> allow sending input events through uinput interface and I think evemu
> should be using it, instead of going halfway through uinput and halfway
> though evdev. Replaying though uinput would actually be more correct as
> it would involve the same code paths throgugh input core as with using
> real devices (see input_event() vs. input_inject_event() that is used by
> input handlers).

this isn't just about evemu. I've got a fair number of tests that create a
uinput device and then pass the device node to the next level. for example,
you may want to create a synaptics touchpad through uinput and then test the
xorg driver against it. I can't pass the uinput fd to the xorg driver, it
only takes a device node. in fact, virtually all the interactions I have
with uinput is of that form - create a device, hook something up to the
device and then do stuff. it's not the writing side that I need this ioctl
for, it's making sure whatever is _reading_ from it is hooked up to the
right device.

Cheers,
   Peter

