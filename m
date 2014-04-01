Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaDALTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:19:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaDALTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Wood <simon@mungewell.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 144/144] HID:hid-lg4ff: Initialize device properties before we touch autocentering.
Date: Tue,  1 Apr 2014 12:15:48 +0100
Message-Id: <1396350948-29910-145-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wood <simon@mungewell.org>

commit 114a55cf9dd1576e7ac56189832cd4d7dc56c218 upstream.

Re-arrange code slightly to ensure that device properties are configured
before calling auto-center command.

Reported-by: Michal Malý <madcatxster@prifuk.cz>
Signed-off-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-lg4ff.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 49f6cc0..3518053 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -574,17 +574,6 @@ int lg4ff_init(struct hid_device *hid)
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
@@ -605,6 +594,17 @@ int lg4ff_init(struct hid_device *hid)
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
1.9.1

