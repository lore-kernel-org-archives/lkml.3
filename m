Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaAHWTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:19:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbaAHWTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:19:01 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] HID logitech DJ fixes and preps for enabling extended features
Date: Wed,  8 Jan 2014 17:18:44 -0500
Message-Id: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Well, this work is _not_ for 3.14 (except maybe patch 1), especially since it is 
missing the biggest part where we enable the capabilities of Logitech devices.

Long story short:
This work is based on the work I did back in Summer 2011. I worked at Logitech
for a few weeks to show up a demo of a driver for the Logitech Wireless Touchpad.
At that time, a first draft has been done, but due to a lack of resources, noone
upstreamed it.
Since then, the code marinated a little at Logitech and in the ChromeOS kernel
tree, but nobody tried to push it upstream. So here I am, trying to push this stuff
upstream.

I can not send the full series right now because I am lacking most of the
testing hardware (I mean I only have the oldest Wireless Touchpad).
Hopefully, I should receive some other soon, and I'll be able to send the second
part then.

Now, let me roughly explain the patches:
- patch 1 can be applied right now I think, but it's entirely up to you Jiri.
  This patch should fix the missing notifications with some USB 3.0 boards.
- patches 2 to 5 allows to forward in both direction the proprietary protocol
  used by Logitech (HID++ [1]) between the driver and the hardware.
- later patches will introduce a transport layer for HID++ and also a driver
  to support full multitouch on various Logitech touchpads.

Nestor, Andrew, feel free to add your "Signed-off-by" whereever you want, I lost
a little bit the track of who added what.

Cheers,
Benjamin

[1] HID++: Documentation is provided at
https://drive.google.com/a/logitech.com/?tab=mo#folders/0BxbRzx7vEV7eWmgwazJ3NUFfQ28

Benjamin Tisssoires (5):
  HID: logitech-dj: Fix USB 3.0 issue
  HID: core: do not scan reports if the group is already set
  HID: logitech-dj: rely on hid groups to separate receivers from dj
    devices
  HID: logitech-dj: forward incoming HID++ reports to the correct dj
    device
  HID: logitech-dj: add .request callback

 drivers/hid/hid-core.c        |   3 +-
 drivers/hid/hid-logitech-dj.c | 161 +++++++++++++++++++++++++++++++++---------
 drivers/hid/hid-logitech-dj.h |  16 ++---
 include/linux/hid.h           |   1 +
 4 files changed, 136 insertions(+), 45 deletions(-)

-- 
1.8.4.2

