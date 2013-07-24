Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3GXOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab3GXOxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:53:13 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3.11-rc2] HID: sony: fix HID mapping for PS3 sixaxis controller
Date: Wed, 24 Jul 2013 16:53:07 +0200
Message-Id: <1374677587-8194-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f04d51404f51 (HID: driver for PS2/3 Buzz controllers) introduced
an input_mapping() callback, but set the return value to -1 to all devices
except the Buzz controllers. The result of this is that the Sixaxis input
device is not populated, making it useless.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Hi Jiri,

I have since yesterday a Sixaxis controller on my desk, and I noticed that it
was broken in v3.11.

Cheers,
Benjamin

 drivers/hid/hid-sony.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index ecbc749..87fbe29 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -369,7 +369,8 @@ static int sony_mapping(struct hid_device *hdev, struct hid_input *hi,
 	if (sc->quirks & PS3REMOTE)
 		return ps3remote_mapping(hdev, hi, field, usage, bit, max);
 
-	return -1;
+	/* Let hid-core decide for the others */
+	return 0;
 }
 
 /*
-- 
1.8.3.1

