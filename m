Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbaLKMvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:51:39 -0500
Received: from lekensteyn.nl ([178.21.112.251]:33538 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932862AbaLKMve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:51:34 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] HID: logitech-hidpp: fixes for error conditions
Date: Thu, 11 Dec 2014 13:51:16 +0100
Message-Id: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.1.3
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Here are four patches intended for the 3.19 stream and are based on
jikos/hid (for-next, v3.18-rc4-144-gd9372ee).

* The first is actually from Benjamin Tissoires, but modified to remove
  a now unneeded goto.
* The second one depends on the first (it could work without, but there
  will be a context mismatch).
* The third one can be applied independently of the others and is needed
  to avoid a possible buffer overread.
* The fourth and final patch fixes an unbalanced hid_device_io_start().

Tested by booting with three paired USB devices (QEMU + USB
passthrough), two of them are powered off and one M525 is active. evbug
registers mouse events.

Kind regards,
Peter

Peter Wu (4):
  HID: logitech-hidpp: do not return the name length
  HID: logitech-hidpp: check name retrieval return code
  HID: logitech-hidpp: add boundary check for name retrieval
  HID: logitech-hidpp: disable io in probe error path

 drivers/hid/hid-logitech-hidpp.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

-- 
2.1.3

