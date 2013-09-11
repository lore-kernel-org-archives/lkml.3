Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3IKT5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab3IKT5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:57:12 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/10] HID: validate report details
Date: Wed, 11 Sep 2013 21:56:49 +0200
Message-Id: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here is the v3 of the CVE fixes.

I have tested the multitouch and logitech-dj part, and the lenovo-tpkbd has been
tested in the bug referenced in patch 10.

Cheers,
Benjamin

Changes since v2:
- fix lenovo-tpkbd report validation
- fix lenovo-tpkbd not releasing the device when the report was not valid
- use generic tests found in previous hid-multitouch patches, so that this will
  not happen again
- fix input_report index retrieving in hid-multitouch

Original message from Kees (v2):

These patches introduce a validation function for HID devices that do
direct report value accesses, solving a number of heap smashing flaws.

This version changes to using an field-index-based checker for the new
"hid_validate_values()" which requires callers to loop across fields if
they use more than one field.

Benjamin Tissoires (3):
  HID: validate feature and input report details
  HID: multitouch: validate indexes details
  HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails

Kees Cook (7):
  HID: provide a helper for validating hid reports
  HID: zeroplus: validate output report details
  HID: sony: validate HID output report details
  HID: steelseries: validate output report details
  HID: LG: validate HID output report details
  HID: lenovo-tpkbd: validate output report details
  HID: logitech-dj: validate output report details

 drivers/hid/hid-core.c         | 74 +++++++++++++++++++++++++++++++++++++-----
 drivers/hid/hid-input.c        | 11 ++++++-
 drivers/hid/hid-lenovo-tpkbd.c | 25 ++++++++++----
 drivers/hid/hid-lg2ff.c        | 19 ++---------
 drivers/hid/hid-lg3ff.c        | 29 ++++-------------
 drivers/hid/hid-lg4ff.c        | 20 +-----------
 drivers/hid/hid-lgff.c         | 17 ++--------
 drivers/hid/hid-logitech-dj.c  | 10 ++++--
 drivers/hid/hid-multitouch.c   | 26 ++++++++-------
 drivers/hid/hid-sony.c         |  4 +++
 drivers/hid/hid-steelseries.c  |  5 +++
 drivers/hid/hid-zpff.c         | 18 +++-------
 include/linux/hid.h            |  4 +++
 13 files changed, 146 insertions(+), 116 deletions(-)

-- 
1.8.3.1

