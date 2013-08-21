Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3HUPkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab3HUPkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:40:41 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] HID: Win 8 multitouch panels detection in core
Date: Wed, 21 Aug 2013 17:40:17 +0200
Message-Id: <1377099620-23947-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is the v2 of the rework of the pre-scanning of the hid report descriptors.
This allows us to be able to detect Win 8 multitouch panels.
I tried to take into account all of the previous reviews, and I think the patch
series is in a better shape now.

Alexander, Srinivas, could you please review/test patches 1/3 and 2/3 as they
will both impact hid_sensor_hub detection now. From the report descriptors
Alexander sent, I would say that it will work now, but it's always better to
have different testers :)

Cheers,
Benjamin

Changes in v2:
- moved "flags" processing in patch 2/3
- do not introduce parser->flags, but use hid->group as a temporary flag placeholder
- hid_scan_report() is less verbose when errors are found in the descriptor
- hid_scan_report() is tolerant to parsing errors
- fixed usage_page handling in hid_scan_collection(), which fixes sensors detection
- amended commit messages
- #define and #undef HID_FLAG_* in hid-core.c instead of hid.h

Benjamin Tissoires (3):
  HID: Use hid_parser for pre-scanning the report descriptors
  HID: detect Win 8 multitouch devices in core
  HID: do not init input reports for Win 8 multitouch devices

 drivers/hid/hid-core.c        | 143 ++++++++++++++++++++++++++++++------------
 drivers/hid/hid-multitouch.c  |  36 +++++++----
 drivers/hid/usbhid/hid-core.c |  11 +++-
 include/linux/hid.h           |   2 +
 4 files changed, 137 insertions(+), 55 deletions(-)

-- 
1.8.3.1

