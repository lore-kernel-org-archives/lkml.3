Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaAUEMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 23:12:50 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34187 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaAUEMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 23:12:41 -0500
Date: Mon, 20 Jan 2014 20:12:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] input/uinput: add UI_GET_SYSNAME ioctl to retrieve
 the sysfs path
Message-ID: <20140121041237.GA7709@core.coreip.homeip.net>
References: <1389985971-541-1-git-send-email-benjamin.tissoires@redhat.com>
 <20140120215313.GB4270@core.coreip.homeip.net>
 <CAN+gG=EPXLR5H_h0UgaMOmAbwAivxCohtg3Gocws5fJucz4+eg@mail.gmail.com>
 <20140120225651.GA30049@yabbi.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120225651.GA30049@yabbi.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 08:56:51AM +1000, Peter Hutterer wrote:
> On Mon, Jan 20, 2014 at 05:17:08PM -0500, Benjamin Tissoires wrote:
> > On Mon, Jan 20, 2014 at 4:53 PM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > > Hi Benjamin,
> > >
> > > On Fri, Jan 17, 2014 at 02:12:51PM -0500, Benjamin Tissoires wrote:
> > >> Evemu [1] uses uinput to replay devices traces it has recorded. However,
> > >> the way evemu uses uinput is slightly different from how uinput is
> > >> supposed to be used.
> > >> Evemu relies on libevdev, which creates the device node through uinput.
> > >> It then injects events through the input device node directly (and it
> > >> completely skips the uinput node).
> > >>
> > >> Currently, libevdev relies on an heuristic to guess which input node was
> > >> created. The problem is that is heuristic is subjected to races between
> > >> different uinput devices or even with physical devices. Having a way
> > >> to retrieve the sysfs path allows us to find the event node without
> > >> having to rely on this heuristic.
> > >
> > > I have been thinking about it and I think that providing tight coupling
> > > between uinput and resulting event device is wrong thing to do. We do
> > > allow sending input events through uinput interface and I think evemu
> > > should be using it, instead of going halfway through uinput and halfway
> > > though evdev. Replaying though uinput would actually be more correct as
> > > it would involve the same code paths throgugh input core as with using
> > > real devices (see input_event() vs. input_inject_event() that is used by
> > > input handlers).
> > >
> > 
> > Yes, I am perfectly aware of the fact that evemu is not using uinput
> > in the way it is intended to be.
> > I agree that it should be using the uinput node to inject events but
> > this means that only the process which has created the virtual device
> > can access it. It seems weird, I know, but the typical use of evemu is
> > the following:
> > - in a first terminal: $> sudo evemu-device mydevice.desc
> > - In a second: $> sudo evemu-play /dev/input/event12 < mydevice.events
> > 
> > It looks weird here, but it allows to inject different events
> > recording for the same virtual device node. 
> 
> it also allows replaying an event through the device it was recorded on.
> it's not always necessary or desirable to create a uinput device, sometimes
> replaying it through the actual device is better to reproduce a certain bug.

I was not saying that we should remove ability to inject events through
evdev nodes, so I am not sure why you are bringing your last point, but
form your and Benjamin's other mails I can see why going through evdev
(that has a separate device node) might be beneficial.

Benjamin, please clean up the issues brought up by David and I should be
able to apply the patch.

Thanks.

-- 
Dmitry
