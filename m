Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117AbaGPORu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:17:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56759 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965074AbaGPORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:17:46 -0400
Date: Wed, 16 Jul 2014 10:17:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Patrik Fimml <patrikf@chromium.org>
cc: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Torokhov <dtor@google.com>, Benson Leung <bleung@google.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
In-Reply-To: <20140716013206.GA13409@google.com>
Message-ID: <Pine.LNX.4.44L0.1407161006260.1028-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Patrik Fimml wrote:

> (Re-sending with correct mailing list addresses.)
> 
> Hi,
> 
> When the lid of a laptop is closed, certain devices can no longer
> provide interesting input or will even produce bogus input, such as:
> 
> - input devices: touchscreen, touchpad, keyboard

Just to be clear: The laptop's internal keyboard can't be used, but
external keyboards can.  The same goes for touchscreens and touchpads.

> - sensors: ambient light sensor, accelerometer, magnetometer

Why can't the accelerometer or magnetometer be used when the lid is 
closed?

> - a video camera mounted on the lid
> - display backlight

I can think of one possible use for a video camera mounted inside the
lid.  It's the modern analog of the age-old question: Does the
refrigerator light go out when the door is closed?  Using the video
camera, users will be able to check whether the display backlight goes
out when the lid is closed.  :-)

> Various workarounds cover some of these cases, and we have some ugly
> hacks in ChromeOS to make things work. It would be nice if a userspace
> power management daemon could listen to the lid-close event, and then
> have a way to temporarily power off these devices, potentially through
> sysfs.

Isn't it common for laptops to go into system suspend when the lid is 
closed?

> I've been discussing this with Dmitry and Benson (cc'd), and we've been
> wondering whether we could come up with a generic solution that could
> benefit multiple device classes.
> 
> There's some overlap with runtime PM here. The action to be taken in
> such a situation would probably be similar to a runtime suspend. The
> match is not perfect though, since devices with more than two power
> states might want to enter different states depending on the situation.
> 
> It's somewhat difficult to get the semantics right, since handles to
> such devices might still be open. It might be easier to implement
> behavior specific to device classes. On the other hand, it would be nice
> to have a uniform way of shutting devices down, and not introduce
> another possible path for a device to enter a power-saving state.

What's the difference between shutting a device down and entering a 
power-saving state?  That is, why shouldn't the first be considered an 
example of the second?

The general design of Linux's runtime PM is that the PM core tells
drivers when their devices are no longer being used, and it's up to the
driver to select an appropriate low-power state.  That philosophy
doesn't fit well with the problem you want to solve, because you want
to turn off devices even when they _are_ still in use.

A separate sysfs interface might work out better.

Alan Stern

