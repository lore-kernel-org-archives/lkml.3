Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934Ab3DDUdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:33:09 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51047 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764835Ab3DDUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:32:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Subject: [PATCH 5/5] HID: hid-lenovo-tpkbd, remove doubled hid_get_drvdata
Date: Thu,  4 Apr 2013 22:32:12 +0200
Message-Id: <1365107532-32721-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
References: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pointer_press_speed_show, we do
    data_pointer = hid_get_drvdata(hdev);
twice in a row. Remove one of those.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org
---
 drivers/hid/hid-lenovo-tpkbd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index a0535fd..07837f5 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -228,8 +228,6 @@ static ssize_t pointer_press_speed_show(struct device *dev,
 	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct tpkbd_data_pointer *data_pointer = hid_get_drvdata(hdev);
 
-	data_pointer = hid_get_drvdata(hdev);
-
 	return snprintf(buf, PAGE_SIZE, "%u\n",
 		data_pointer->press_speed);
 }
-- 
1.8.2


