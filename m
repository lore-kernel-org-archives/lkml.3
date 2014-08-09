Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaHIRHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:07:17 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55468 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaHIRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:07:15 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Input: wacom - Fix compiler warning if !CONFIG_PM
Date: Sat,  9 Aug 2014 19:07:03 +0200
Message-Id: <1407604023-7429-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM is not set:

drivers/hid/wacom_sys.c:1436: warning: ‘wacom_reset_resume’ defined but
not used

Protect the unused functions by #ifdef CONFIG_PM to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/hid/wacom_sys.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 3e388ec31da8..f0db7eca9023 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1416,6 +1416,7 @@ static void wacom_remove(struct hid_device *hdev)
 	kfree(wacom);
 }
 
+#ifdef CONFIG_PM
 static int wacom_resume(struct hid_device *hdev)
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
@@ -1436,6 +1437,7 @@ static int wacom_reset_resume(struct hid_device *hdev)
 {
 	return wacom_resume(hdev);
 }
+#endif /* CONFIG_PM */
 
 static struct hid_driver wacom_driver = {
 	.name =		"wacom",
-- 
1.9.1

