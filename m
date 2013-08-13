Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3HMO6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984Ab3HMO62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:58:28 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexander Holler <holler@ahsoftware.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] HID: Win 8 multitouch panels detection in core
Date: Tue, 13 Aug 2013 16:58:06 +0200
Message-Id: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This series is the following of the patch "HID: multitouch: do not init
reports for multitouch devices" which I sent on the 12th of July.

The goal is just to not call a GET_REPORT on input reports to imitate
what Win 8 is doing with the touch panels. However, to have an accurate
detection of Win 8 panels and to not introduce regressions, we need
to adapt the pre-scanning of hid devices.

The first patch drops the custom parsing and relies on the well tested
parser that we have in hid-core. This cleans up the pre-scanning and
allows us to scan the features in addition to the input reports and the
collections.

The second patch uses the pre-scanning method to detect Win 8 multitouch
panels. This allows a simplification in hid-multitouch because those
panels will now use the general path instead of having special quirks
attached during the parsing.

The third patch introduce the actual quirk which would allow us not to
have to maintain a growing list of quirks.

Cheers,
Benjamin

Benjamin Tissoires (3):
  HID: Use existing parser for pre-scanning the report descriptors
  HID: detect Win 8 multitouch devices in core
  HID: do not init input reports for Win 8 multitouch devices

 drivers/hid/hid-core.c        | 143 +++++++++++++++++++++++++++++++-----------
 drivers/hid/hid-multitouch.c  |  36 +++++++----
 drivers/hid/usbhid/hid-core.c |  11 +++-
 include/linux/hid.h           |   7 +++
 4 files changed, 143 insertions(+), 54 deletions(-)

-- 
1.8.3.1

