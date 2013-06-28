Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3F1KwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:52:04 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:46540 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3F1KwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:52:02 -0400
MIME-Version: 1.0
In-Reply-To: <3109bea2ac0947fd544042e51bcb75ad.squirrel@faumail.uni-erlangen.de>
References: <1372182701-12256-1-git-send-email-michael.banken@mathe.stud.uni-erlangen.de>
	<51CAF4C9.20407@redhat.com>
	<3109bea2ac0947fd544042e51bcb75ad.squirrel@faumail.uni-erlangen.de>
Date: Fri, 28 Jun 2013 12:52:00 +0200
Message-ID: <CANq1E4QpZ773Kz=vgAYLV+dkbFG6XgFzGLteCzoQSDcL7c3+Lg@mail.gmail.com>
Subject: Re: [PATCH] Added a check for NULL pointer in hid_add_device
From: David Herrmann <dh.herrmann@gmail.com>
To: michael.banken@mathe.stud.uni-erlangen.de
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        erazor_de@users.sourceforge.net, Jiri Kosina <jkosina@suse.cz>,
        lorenz@badgers.com, linux-kernel@i4.informatik.uni-erlangen.de,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jun 26, 2013 at 5:45 PM,
<michael.banken@mathe.stud.uni-erlangen.de> wrote:
> Hi,
>
> The idea was to make the creation of an empty hid device while inside the
> kernel easier. This problem came up, when I was writing a kernel module
> driver for a usb temperature sensor. The sensors were supposed to be
> recognized in lm-sensors, which does not recognize usb devices. The
> solution in this case was to create an empty hid device to hook it up to
> sysfs.
> In some older implementations of this driver the solution to this problem
> was creating an empty hid device to hook it up to sysfs.
> These older implementations of the driver are not working anymore, unless
> built with the change I am suggesting, because in the current version
> their method of creating the hid device causes a NULL pointer dereference
> at the point where I added the check.

So you create an empty HID device to achieve what? I really cannot
follow, sorry. If you want lm_sensors to pick up your sensors, why not
patch lm_sensors to do so?

> The reason, why I believe this change to be completely harmless is that in
> the case where there actually is a NULL pointer the function would
> dereference it anyway immediately after the line where I added the check.
> The only problem that to my understanding could possibly arise is delaying
> the inevitable oops for a little while.

All other parts of the HID layer assume ll_driver to be NULL. It works
for you, because you avoid any ll_driver interaction so these parts of
the HID core that work with it will never get called. However, that's
not how it is supposed to work.

Could you describe why you cannot hook up your device as USB device
directly? Does lm_sensors only scan HID bus devices, not USB bus
devices or what is the exact reason?

> best regards,
> Michael

Cheers
David
