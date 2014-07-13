Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaGMHY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 03:24:56 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:48933 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaGMHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 03:24:33 -0400
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>,
        Hans de Goede <hdegoede@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v4 3/4] Style fixes
Date: Sun, 13 Jul 2014 08:24:21 +0100
Message-Id: <1405236262-8070-4-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
References: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
 drivers/hid/hid-lenovo.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index d11e337..a1a693c 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -349,7 +349,7 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
 	struct lenovo_drvdata_tpkbd *data_pointer;
 	size_t name_sz = strlen(dev_name(dev)) + 16;
 	char *name_mute, *name_micmute;
-	int i;
+	int i, ret;
 
 	/*
 	 * If this is the pointer half of the keyboard, input_mapping should
@@ -369,10 +369,9 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
 	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 3, 0, 2))
 		return -ENODEV;
 
-	if (sysfs_create_group(&hdev->dev.kobj,
-				&lenovo_attr_group_tpkbd)) {
+	ret = sysfs_create_group(&hdev->dev.kobj, &lenovo_attr_group_tpkbd);
+	if (ret)
 		hid_warn(hdev, "Could not create sysfs group\n");
-	}
 
 	data_pointer = devm_kzalloc(&hdev->dev,
 				    sizeof(struct lenovo_drvdata_tpkbd),
-- 
2.0.0

