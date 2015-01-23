Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbbAWRcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:32:09 -0500
Received: from a8-21.smtp-out.amazonses.com ([54.240.8.21]:34182 "EHLO
	a8-21.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbbAWRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:31:59 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2015 12:31:59 EST
From: Jim Keir <jimkeir@oracledbadirect.com>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz
Cc: Jim Keir <jimkeir@oracledbadirect.com>
Subject: [PATCH 2/2] Fix force effect modifications for the Microsoft Sidewinder Force Feedback Pro 2 joystick
Date: Fri, 23 Jan 2015 17:21:13 +0000
Message-ID: <0000014b17cfde4d-df42e887-9524-4f07-a46b-5d81f01fc687-000000@email.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422033640-4104-1-git-send-email-jimkeir@oracledbadirect.com>
References: <1422033640-4104-1-git-send-email-jimkeir@oracledbadirect.com>
X-SES-Outgoing: 2015.01.23-54.240.8.21
Feedback-ID: us-east-1.amlta2VpckBvcmFjbGVkYmFkaXJlY3QuY29t:AmazonSES
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
Hi,

Changes from previous patches: 
- All changes removed from higher-level files
- Extra debug line removed

Signed-off-by: Jim Keir <jimkeir@oracledbadirect.com> 

 drivers/hid/usbhid/hid-pidff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 0b531c6..1b3fa70 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -568,6 +568,12 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 	int type_id;
 	int error;
 
+	pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
+	if (old && effect) {
+		pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] =
+			pidff->pid_id[effect->id];
+	}
+
 	switch (effect->type) {
 	case FF_CONSTANT:
 		if (!old) {
-- 
1.9.1

