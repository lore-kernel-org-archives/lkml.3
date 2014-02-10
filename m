Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaBJR7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:59:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbaBJR7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:03 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] HID: low-level transport cleanup, round 2
Date: Mon, 10 Feb 2014 12:58:45 -0500
Message-Id: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is the second part of the low-level HID transport cleanup.
The series goes on top of the previous one I sent last week.

Some highlights:
- remove hid_output_raw_report from struct hid_device
- uniformization of all transport driver by having only 2 mandatory
communication functions to implement: .raw_request and .output_report

Cheers,
Benjamin

Benjamin Tissoires (14):
  HID: uHID: remove duplicated code
  HID: uHID: implement .raw_request
  HID: core: implement generic .request()
  HID: i2c-hid: implement ll_driver transport-layer callbacks
  HID: i2c-hid: use generic .request() implementation
  HID: usbhid: change return error of usbhid_output_report
  HID: input: hid-input remove hid_output_raw_report call
  HID: logitech-dj: remove hid_output_raw_report call
  HID: replace hid_output_raw_report with hid_hw_raw_request for feature
    requests
  HID: wiimote: replace hid_output_raw_report with hid_hw_output_report
    for output requests
  HID: sony: remove hid_output_raw_report calls
  HID: hidraw: replace hid_output_raw_report() calls by appropriates
    ones
  HID: remove hid_output_raw_report
  HID: core: check parameters when sending/receiving data from the
    device

 drivers/hid/hid-core.c         | 45 +++++++++++++++++++++++-
 drivers/hid/hid-input.c        | 10 ++++--
 drivers/hid/hid-lg.c           |  8 ++---
 drivers/hid/hid-logitech-dj.c  | 21 ++++-------
 drivers/hid/hid-magicmouse.c   |  4 +--
 drivers/hid/hid-sony.c         | 79 +++++++++++++++++++++++++++++-------------
 drivers/hid/hid-thingm.c       |  4 +--
 drivers/hid/hid-wacom.c        | 26 ++++++++------
 drivers/hid/hid-wiimote-core.c |  4 +--
 drivers/hid/hidraw.c           | 22 +++++++++---
 drivers/hid/i2c-hid/i2c-hid.c  | 70 ++++++++++++++++++++-----------------
 drivers/hid/uhid.c             | 37 +++++++++-----------
 drivers/hid/usbhid/hid-core.c  | 14 +-------
 include/linux/hid.h            | 30 ++++++----------
 net/bluetooth/hidp/core.c      | 14 --------
 15 files changed, 218 insertions(+), 170 deletions(-)

-- 
1.8.3.1

