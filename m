Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936402Ab3DQRjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab3DQRjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:39:15 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 0/4] HID: debugfs rework
Date: Wed, 17 Apr 2013 19:38:12 +0200
Message-Id: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

This is a small rework of the HID debugfs.
I encountered a problem with multitouch devices: they have too much usages to
fit into the fixed size output buffer of 512.
So I digg a little, and end up with those 4 patches.

Cheers,
Benjamin

Benjamin Tissoires (4):
  HID: debug: break out hid_dump_report() into hid-debug
  HID: core: break out hid_find_max_report() in hid-core
  HID: debug: empty output queue on read
  HID: debug: allocate the output buffer with an estimate

 drivers/hid/hid-core.c        | 84 +++++++++++++++++++++++++++++-----------
 drivers/hid/hid-debug.c       | 89 +++++++++++++++++++++++++++++++++----------
 drivers/hid/i2c-hid/i2c-hid.c | 15 ++------
 drivers/hid/usbhid/hid-core.c | 16 --------
 include/linux/hid-debug.h     |  7 +++-
 include/linux/hid.h           |  5 +++
 6 files changed, 143 insertions(+), 73 deletions(-)

-- 
1.8.1.4

