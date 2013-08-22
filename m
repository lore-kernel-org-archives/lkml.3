Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab3HVMvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3HVMve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:51:34 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] HID: Win 8 multitouch panels detection in core
Date: Thu, 22 Aug 2013 14:51:06 +0200
Message-Id: <1377175869-5336-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is the v3 of this patch series.

Srinivas, I still did not added your tested-by as I made minors modifications of
the patches 1 and 2. Now only the patch 1 will impact sensor_hub, and patch 2
will not impact this. Maybe just wait for Henrik to put his "Reviewed-by" before
giving one last test.

Cheers,
Benjamin

Changes in v3:
- remove one remnant duplicate message
- amended commit messages
- re-add initializer of hid->group (set to HID_GROUP_GENERIC)
- removed ugly #define #undef :)
- add back scan_flags in hid_parser
- simpler post processing of Win 8 certified multitouch panels

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

 drivers/hid/hid-core.c        | 118 ++++++++++++++++++++++++++++--------------
 drivers/hid/hid-multitouch.c  |  36 ++++++++-----
 drivers/hid/usbhid/hid-core.c |  11 ++--
 include/linux/hid.h           |   5 ++
 4 files changed, 116 insertions(+), 54 deletions(-)

-- 
1.8.3.1

