Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaGXSOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759763AbaGXSOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:14:37 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 01/10] Input - wacom: Support up to 2048 pressure levels with ISDv4
Date: Thu, 24 Jul 2014 14:13:56 -0400
Message-Id: <1406225645-32141-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

Signed-off-by: Jason Gerecke <killertofu@gmail.com>
Rebased in drivers/hid/
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

changes in v2:
- rebased in drivers/hid/

 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index d62e320..f30083f 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1086,7 +1086,7 @@ static int wacom_tpc_pen(struct wacom_wac *wacom)
 		input_report_key(input, BTN_STYLUS2, data[1] & 0x10);
 		input_report_abs(input, ABS_X, le16_to_cpup((__le16 *)&data[2]));
 		input_report_abs(input, ABS_Y, le16_to_cpup((__le16 *)&data[4]));
-		input_report_abs(input, ABS_PRESSURE, ((data[7] & 0x03) << 8) | data[6]);
+		input_report_abs(input, ABS_PRESSURE, ((data[7] & 0x07) << 8) | data[6]);
 		input_report_key(input, BTN_TOUCH, data[1] & 0x05);
 		input_report_key(input, wacom->tool[0], prox);
 		return 1;
-- 
2.0.1

