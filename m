Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbaKRO0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:26:33 -0500
Received: from [140.232.255.14] ([140.232.255.14]:56477 "EHLO mail.abrij.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbaKRO0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:26:31 -0500
Date: Tue, 18 Nov 2014 09:26:29 -0500
From: bri <bri@abrij.org>
To: Frank Praznik <frank.praznik@gmail.com>
Cc: Antonio Ospite <ao2@ao2.it>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, open@abrij.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 001/001] hid-sony.c: add sysfs provisioning
Message-ID: <20141118142629.GA343@abrij.org>
References: <20141116181846.GA31516@abrij.org>
 <20141117133518.ee306b3b35a0e0566a255b14@ao2.it>
 <546A4EF7.903@gmail.com>
 <20141118000005.GA32256@abrij.org>
 <546ABB51.4010905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546ABB51.4010905@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 10:21:53PM -0500, Frank Praznik wrote:
> Hi Brian,
> 
> On 11/17/2014 19:00, bri wrote:
> >
> >>Yeah, the device ID in the driver is only for tracking devices internally
> >>and setting sane default LED values.  It has no meaning outside of the
> >>module.  Like Antonio said, if you want the system number for a controller
> >>you are better off just getting it from the joystick device.
> >Would you be amenable to a patch that removes the IDA entirely and just sets
> >the LEDs to all solid-on?  Since the LEDs are available through sysfs,
> >udev rule could probably be made to set the LEDs in the absence of bluez
> >or a higher level controller manager, and then it becomes the distro's
> >responsibility.
> >
> 
> What would be the benefit of doing this?  Nothing is stopping higher level
> services from setting the LEDs right now.  The driver just sets sane
> defaults for systems that don't have anything else to set the 'real' values.
> Other controllers like Wiimotes and Xbox gamepads do the same thing.  It
> doesn't get in the way of services like BlueZ setting them once
> initialization is complete.
> 
> Leaving it completely up to the distro just means that there will be
> situations where there is nothing to set the default values which makes for
> a bad user experience.

It would eliminate 50 to 100 lines of code just for that tiny purpose,
which userspace can and probably should take care of, given the disparity
with the eventual values.  I'm honestly a bit confused of the criteria in use
here, as I thought it was mostly deciding between the usefulness of features
versus maintainability.  In my mind if I weight a master_bdaddr sysfs file
and the code to support it versus this feature, I don't see where this one
wins out.

But whatever.  I made this for my own use, and offered it up, and if the
community does not want it I am free to keep using what I made, so I'm happy
either way.

