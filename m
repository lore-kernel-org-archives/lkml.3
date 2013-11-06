Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3KFTbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:31:11 -0500
Received: from host171.canaca.com ([67.55.55.225]:50303 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3KFTbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:31:09 -0500
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, Elias Vanderstuyft <elias.vds@gmail.com>,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>
Subject: [PATCH 4/5] HID:hid-lg4ff: Initialize device properties before we touch autocentering.
Date: Wed,  6 Nov 2013 12:30:43 -0700
Message-Id: <1383766244-2336-4-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383766244-2336-1-git-send-email-simon@mungewell.org>
References: <1383766244-2336-1-git-send-email-simon@mungewell.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-arrange code slightly to ensure that device properties are configured
before calling auto-center command.

Reported-by: Michal Malý <madcatxster@prifuk.cz>
Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg4ff.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 5d140b7..5492809 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -589,17 +589,6 @@ int lg4ff_init(struct hid_device *hid)
 	if (error)
 		return error;
 
-	/* Check if autocentering is available and
-	 * set the centering force to zero by default */
-	if (test_bit(FF_AUTOCENTER, dev->ffbit)) {
-		if (rev_maj == FFEX_REV_MAJ && rev_min == FFEX_REV_MIN)	/* Formula Force EX expects different autocentering command */
-			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_ffex;
-		else
-			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_default;
-
-		dev->ff->set_autocenter(dev, 0);
-	}
-
 	/* Get private driver data */
 	drv_data = hid_get_drvdata(hid);
 	if (!drv_data) {
@@ -620,6 +609,17 @@ int lg4ff_init(struct hid_device *hid)
 	entry->max_range = lg4ff_devices[i].max_range;
 	entry->set_range = lg4ff_devices[i].set_range;
 
+	/* Check if autocentering is available and
+	 * set the centering force to zero by default */
+	if (test_bit(FF_AUTOCENTER, dev->ffbit)) {
+		if (rev_maj == FFEX_REV_MAJ && rev_min == FFEX_REV_MIN)	/* Formula Force EX expects different autocentering command */
+			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_ffex;
+		else
+			dev->ff->set_autocenter = hid_lg4ff_set_autocenter_default;
+
+		dev->ff->set_autocenter(dev, 0);
+	}
+
 	/* Create sysfs interface */
 	error = device_create_file(&hid->dev, &dev_attr_range);
 	if (error)
-- 
1.8.1.2

