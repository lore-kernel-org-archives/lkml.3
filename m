Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaC1Xrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 19:47:42 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47898
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaC1Xrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 19:47:41 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jkosina@suse.cz, benjamin.tissoires@redhat.com,
        dh.herrmann@gmail.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hid: hid-hyperv: Implement a stub  raw_request() entry point
Date: Fri, 28 Mar 2014 17:41:27 -0700
Message-Id: <1396053687-21421-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3c86726cfe38952f0366f86acfbbb025813ec1c2
Author: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Thu Feb 20 15:24:49 2014 -0500

    HID: make .raw_request mandatory

    SET_REPORT and GET_REPORT are mandatory in the HID specification.
    Make the corresponding API in hid-core mandatory too, which removes the
    need to test against it in some various places.

    Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
    Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Made .raw_request mandatory and broke the Hyper-V mouse driver. This patch
fixes the problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hid/hid-hyperv.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index c24908f..89a9234 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -460,12 +460,22 @@ static void mousevsc_hid_stop(struct hid_device *hid)
 {
 }
 
+static int mousevsc_hid_raw_request(struct hid_device *hid,
+				    unsigned char report_num,
+				    __u8 buf, size_t len,
+				    unsigned char rtype,
+				    int reqtype)
+{
+	return 0;
+}
+
 static struct hid_ll_driver mousevsc_ll_driver = {
 	.parse = mousevsc_hid_parse,
 	.open = mousevsc_hid_open,
 	.close = mousevsc_hid_close,
 	.start = mousevsc_hid_start,
 	.stop = mousevsc_hid_stop,
+	.raw_request = mousevsc_hid_raw_request,
 };
 
 static struct hid_driver mousevsc_hid_driver;
-- 
1.7.4.1

