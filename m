Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3LBTTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:19:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3LBTS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@prifuk.cz>,
        Simon Wood <simon@mungewell.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 183/212] HID:hid-lg4ff: Initialize device properties before we touch autocentering.
Date: Mon,  2 Dec 2013 11:16:14 -0800
Message-Id: <20131202191308.999613931@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wood <simon@mungewell.org>

commit 114a55cf9dd1576e7ac56189832cd4d7dc56c218 upstream.

Re-arrange code slightly to ensure that device properties are configured
before calling auto-center command.

Reported-by: Michal Malý <madcatxster@prifuk.cz>
Signed-off-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lg4ff.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

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


