Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3LSMCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:02:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3LSMAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 204/208] HID: kye: Fix missing break in kye_report_fixup()
Date: Thu, 19 Dec 2013 11:55:02 +0000
Message-Id: <1387454106-19326-205-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 0a5f99cfff2297f6c350b7f54878cbbf1b1253d5 upstream.

The change to support Genius Manticore Keyboard also changed behaviour
for Genius Gx Imperator Keyboard, as there is no break between the
cases.  This is presumably a mistake.

Reported by Coverity as CID 1134029.

Fixes: 4a2c94c9b6c0 ('HID: kye: Add report fixup for Genius Manticore Keyboard')
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-kye.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index 35a4f9c..d645caa 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -341,6 +341,7 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
 					"Genius Gx Imperator Keyboard");
+		break;
 	case USB_DEVICE_ID_GENIUS_MANTICORE:
 		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
 					"Genius Manticore Keyboard");
-- 
1.8.3.2

