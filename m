Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaGBXdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:33:25 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:61001 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGBXdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 2 Jul 2014 16:33:21 -0700
Message-ID: <CANRwn3S9NwAET06sttcniN2391fY5+W-ZGAmvOqr1c_6AJ=J6g@mail.gmail.com>
Subject: Re: [PATCH 00/15] Input - Wacom: switch from an USB to a HID driver
From: Jason Gerecke <killertofu@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        linuxwacom-devel <linuxwacom-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 2:26 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Hi guys,
>
> this patch series is a cleanup for the Wacom USB driver.
>
> I started working on this topic when I saw patches floating around which
> implemented a report descriptor parser within the wacom.ko module.
> However, we already have a nice HID subsystem which is more generic than the
> HID implementation we can find in this USB driver.
> Further details of the benefits (code reduction, regression tests) are hopefully
> explained in the commit messages of the corresponding patches.
>
> Also, I am working on a way to handle the new Wacom tablets in a more generic
> way in the hid tree, so consider this patch series as a first step in this
> direction.
>
> This patch series transfers the wacom.ko driver from the input tree into the hid
> tree. I did not made the corresponding move of the files in the series hoping
> that we will find a way to achieve it if this step is validated.
>
> IMO, the smoothest path would be that Jiri takes care of the wacom driver
> in the input tree (and that we move into into the hid subfolder). This can be
> achieve if the current pending wacom patches are applied in the hid tree too.
>
> Another solution could be to keep the wacom changes in the input tree and put the
> hid changes in the hid tree by using separate commits. Once 3.17 is out, we can
> then change the module into the hid subfolder.
>
> I wanted to send this patch series right now so we can figure out how we will
> handle the transition.
>
> I am pretty confident the patch series does not break any existing device
> (except for the required user space changes which can be handled correctly if
> we tackle them right now). The USB commands are executed in the same way,
> and the protocol handling is also done in the same way.
>
> Anyway, the net difference in lines of code (-307) should be enough to be of
> interest.
>
> Note: This patch series requires the current pending wacom patches to be applied.
> I set up a tree with all the patch applied if anyone wants to give a try:
> https://github.com/bentiss/linux/commits/hid-wacom-legacy-3.16-rc3
>
> Cheers,
> Benjamin
>
> Benjamin Tissoires (15):
>   Input - wacom: include and use linux/hid.h
>   Input - wacom: switch from an USB driver to a HID driver
>   Input - wacom: use hid communication instead of plain usb
>   Input - wacom: use HID core to actually fetch the report descriptor
>   Input - wacom: compute the HID report size to get the actual packet
>     size
>   Input - wacom: install LED/OLED sysfs files in the HID device instead
>     of USB
>   Input - wacom: register the input devices on top of the HID one
>   Input - wacom: remove usb dependency for siblings devices
>   Input - wacom: register power device at the HID level
>   Input - wacom: use hid_info instead of plain dev_info
>   HID: uhid: add and set HID_TYPE_UHID for uhid devices
>   Input - wacom: use in-kernel HID parser
>   Input - wacom: use hidinput_calc_abs_res instead of duplicating its
>     code
>   Input - wacom: remove field pktlen declaration in the list of devices
>   Input - wacom: keep wacom_ids ordered
>
>  drivers/hid/hid-core.c           |  15 +-
>  drivers/hid/hid-wacom.c          |   2 +-
>  drivers/hid/uhid.c               |   2 +
>  drivers/input/tablet/wacom.h     |   7 +-
>  drivers/input/tablet/wacom_sys.c | 908 +++++++++++++--------------------------
>  drivers/input/tablet/wacom_wac.c | 647 ++++++++++++++--------------
>  drivers/input/tablet/wacom_wac.h |  10 +-
>  include/linux/hid.h              |   4 +-
>  8 files changed, 644 insertions(+), 951 deletions(-)
>
> --
> 2.0.0
>

*cracks knuckles*

Well, guess I better get to work poking and prodding at these and the
pad patches. A very quick review doesn't raise any significant flags,
though I do have a question or two that I might have for you in the
next few days (need to read through the code more carefully to be sure
I understand it correctly). My 24HDT is having some trouble
initializing with the patches applied, but I'll need some time to
track down the cause. Not sure how much I'll get done this week
(holiday weekend) but next week I should have some feedback.

Jason
---
Now instead of four in the eights place /
you’ve got three, ‘Cause you added one  /
(That is to say, eight) to the two,     /
But you can’t take seven from three,    /
So you look at the sixty-fours....
