Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbaGPBcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:32:20 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56331 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206AbaGPBcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:32:09 -0400
Date: Tue, 15 Jul 2014 18:32:06 -0700
From: Patrik Fimml <patrikf@chromium.org>
To: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dmitry Torokhov <dtor@google.com>, Benson Leung <bleung@google.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Power-managing devices that are not of interest at some point in time
Message-ID: <20140716013206.GA13409@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Re-sending with correct mailing list addresses.)

Hi,

When the lid of a laptop is closed, certain devices can no longer
provide interesting input or will even produce bogus input, such as:

- input devices: touchscreen, touchpad, keyboard
- sensors: ambient light sensor, accelerometer, magnetometer
- a video camera mounted on the lid
- display backlight

Various workarounds cover some of these cases, and we have some ugly
hacks in ChromeOS to make things work. It would be nice if a userspace
power management daemon could listen to the lid-close event, and then
have a way to temporarily power off these devices, potentially through
sysfs.

I've been discussing this with Dmitry and Benson (cc'd), and we've been
wondering whether we could come up with a generic solution that could
benefit multiple device classes.

There's some overlap with runtime PM here. The action to be taken in
such a situation would probably be similar to a runtime suspend. The
match is not perfect though, since devices with more than two power
states might want to enter different states depending on the situation.

It's somewhat difficult to get the semantics right, since handles to
such devices might still be open. It might be easier to implement
behavior specific to device classes. On the other hand, it would be nice
to have a uniform way of shutting devices down, and not introduce
another possible path for a device to enter a power-saving state.

Rafael, can you give us your opinion on this?

Kind regards,
Patrik
