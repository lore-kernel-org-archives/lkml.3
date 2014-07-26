Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaGZOmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:42:37 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:38475 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaGZOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:42:36 -0400
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v6 3/4] HID: lenovo: Don't call function in condition, show error codes
Date: Sat, 26 Jul 2014 15:42:27 +0100
Message-Id: <1406385747-2444-1-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406154648-14000-4-git-send-email-jm@lentin.co.uk>
References: <1406154648-14000-4-git-send-email-jm@lentin.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
 drivers/hid/hid-lenovo.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index a56b9e7..f96bf09 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -350,6 +350,7 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
 	size_t name_sz = strlen(dev_name(dev)) + 16;
 	char *name_mute, *name_micmute;
 	int i;
+	int ret;
 
 	/*
 	 * Only register extra settings against subdevice where input_mapping
@@ -368,10 +369,9 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
 	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 3, 0, 2))
 		return -ENODEV;
 
-	if (sysfs_create_group(&hdev->dev.kobj,
-				&lenovo_attr_group_tpkbd)) {
-		hid_warn(hdev, "Could not create sysfs group\n");
-	}
+	ret = sysfs_create_group(&hdev->dev.kobj, &lenovo_attr_group_tpkbd);
+	if (ret)
+		hid_warn(hdev, "Could not create sysfs group: %d\n", ret);
 
 	data_pointer = devm_kzalloc(&hdev->dev,
 				    sizeof(struct lenovo_drvdata_tpkbd),
-- 
2.0.0

