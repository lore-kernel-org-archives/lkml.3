Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3LQPtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:49:21 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:33311 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3LQPtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:49:18 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 0/4] Input: ABS2 and friends
Date: Tue, 17 Dec 2013 16:48:50 +0100
Message-Id: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This implements the recently discussed ABS2 API. It's working fine on my machine
with libevdev. Comments welcome!

* Patch #1 fixes some uinput shortcomings and prepares uinput for ABS2
* Patch #2 adds ABS2
* Patch #3 is just a small comment-fix for #4
* Patch #4 adds some new example ABS values in the new range

Note that I have patches pending which make use of the new ABS values, but I'd
like to get this reduced series in first.

Thanks
David

David Herrmann (4):
  Input: uinput: add full absinfo support
  Input: introduce ABS_MAX2/CNT2 and friends
  Input: remove ambigious gamepad comment
  Input: add motion-tracking ABS_* bits and docs

 Documentation/input/gamepad.txt          |   9 +-
 Documentation/input/motion-tracking.txt  | 149 +++++++++++++++++++++++++++++++
 drivers/hid/hid-debug.c                  |   2 +-
 drivers/hid/hid-input.c                  |   2 +-
 drivers/input/evdev.c                    |  95 +++++++++++++++++++-
 drivers/input/input.c                    |  14 +--
 drivers/input/keyboard/goldfish_events.c |   6 +-
 drivers/input/keyboard/hil_kbd.c         |   2 +-
 drivers/input/misc/uinput.c              | 146 ++++++++++++++++++++++--------
 include/linux/hid.h                      |   2 +-
 include/linux/input.h                    |   6 +-
 include/linux/mod_devicetable.h          |   2 +-
 include/uapi/linux/input.h               |  49 +++++++++-
 include/uapi/linux/uinput.h              |   9 ++
 14 files changed, 431 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/input/motion-tracking.txt

-- 
1.8.5.1

