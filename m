Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3LSQX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:23:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab3LSQXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:23:22 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Edel Maks <edelmaks@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Change in handling different input device in hid-multitouch
Date: Thu, 19 Dec 2013 11:23:08 -0500
Message-Id: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

well, I have been reported a brand new device, which, as always presents a new
way of dealing with multitouch and mouse and soever.
The new fancy stuff is capable to report mouse and touch, whereas by default,
we consider mouse as garbage.

if you want to get an idea of the device:
http://www.pearl.de/a-PX2569-1002.shtml

So, we need to add a quirk for it, as usual, but I also cleaned up the way we
treat the different input devices within the driver. I expect some bikesheding
here, so I fire this right now until it's too late for 3.14 or 3.15 :)

Cheers,
Benjamin

Benjamin Tissoires (3):
  HID: multitouch: switch to a callback system for handling events
  HID: multitouch: introduce mt_protocol_generic
  HID: multitouch: add support of other generic collections in hid-mt

 drivers/hid/hid-ids.h        |   3 +
 drivers/hid/hid-multitouch.c | 205 +++++++++++++++++++++++++++++++++----------
 include/linux/hid.h          |   3 +
 3 files changed, 166 insertions(+), 45 deletions(-)

-- 
1.8.3.1

