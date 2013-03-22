Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422737Ab3CVRjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422642Ab3CVRja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:39:30 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] HID: multitouch: support of hybrid finger/pen devices
Date: Fri, 22 Mar 2013 18:38:27 +0100
Message-Id: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

this is the second iteration of the support of dual sensors (pen + touch)
devices.

There has not been a lot of changes since v1:
- use " |= " instead of " = r || " in patch 1
- introduce a factorization of input_configured() in patch 2 (which makes more sense
IMO)
- patch 4 is new, but the change is quite small (again, tested on my database)
- patch 6 has been reworked, though it's not clear if it's better
- patch 7 has been reworked, the set_bit occurs now in input_configured()

Cheers,
Benjamin

Benjamin Tissoires (7):
  HID: input: don't register unmapped input devices
  HID: multitouch: breaks out touch handling in specific functions
  HID: multitouch: do not map usage from non used reports
  HID: multitouch: change touch sensor detection in
    mt_input_configured()
  HID: multitouch: add handling for pen in dual-sensors device
  HID: multitouch: append " Pen" to the name of the stylus input
  HID: multitouch: force BTN_STYLUS for pen devices

 drivers/hid/hid-input.c      |  77 +++++++++++++++
 drivers/hid/hid-multitouch.c | 216 ++++++++++++++++++++++++++++++++++---------
 include/linux/hid.h          |   1 +
 3 files changed, 251 insertions(+), 43 deletions(-)

-- 
1.8.1.4

