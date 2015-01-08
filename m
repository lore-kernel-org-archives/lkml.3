Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbbAHWyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:54:04 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:25579 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932434AbbAHWxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:53:46 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 08 Jan 2015 15:21:14 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH] HID: rmi: Use hid_report_len to compute the size of reports
Date: Thu, 8 Jan 2015 14:51:36 -0800
Message-ID: <1420757496-3955-3-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420757496-3955-1-git-send-email-aduggan@synaptics.com>
References: <1420757496-3955-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that hid_report_len is in hid.h we can use this function instead of
duplicating the code which computes it.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index b08774a..49d4fe4 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -1025,7 +1025,7 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto start;
 	}
 
-	data->input_report_size = (input_report->size >> 3) + 1 /* report id */;
+	data->input_report_size = hid_report_len(input_report);
 
 	if (!rmi_check_valid_report_id(hdev, HID_OUTPUT_REPORT,
 	    RMI_WRITE_REPORT_ID, &output_report)) {
@@ -1034,8 +1034,7 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto start;
 	}
 
-	data->output_report_size = (output_report->size >> 3)
-					+ 1 /* report id */;
+	data->output_report_size = hid_report_len(output_report);
 
 	data->device_flags |= RMI_DEVICE;
 	alloc_size = data->output_report_size + data->input_report_size;
-- 
2.1.0

