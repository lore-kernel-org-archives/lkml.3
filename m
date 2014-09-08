Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaIHO6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:58:09 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:49015 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaIHO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:58:03 -0400
From: Morgan Phillips <winter2718@gmail.com>
To: brijohn@gmail.com
Cc: hdegoede@redhat.com, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Morgan Phillips <winter2718@gmail.com>
Subject: [PATCH v2] [media]: sn9c20x.c: fix checkpatch error: that open brace { should be on the previous line
Date: Mon,  8 Sep 2014 09:55:58 -0500
Message-Id: <1410188158-6560-1-git-send-email-winter2718@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410179542-3272-1-git-send-email-winter2718@gmail.com>
References: <1410179542-3272-1-git-send-email-winter2718@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change array initialization format to fix style error.
	from:
		u8 foo[] =
			{1, 2, 3};
	to:
		u8 foo[] = {
			1, 2, 3
		};

Signed-off-by: Morgan Phillips <winter2718@gmail.com>
---
 Changes since v2:
   * adds a more verbose commit message

 drivers/media/usb/gspca/sn9c20x.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 41a9a89..95467f0 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1787,8 +1787,9 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 	int i;
 	u8 value;
-	u8 i2c_init[9] =
-		{0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03};
+	u8 i2c_init[9] = {
+		0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03
+	};
 
 	for (i = 0; i < ARRAY_SIZE(bridge_init); i++) {
 		value = bridge_init[i][1];
@@ -2242,8 +2243,9 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int avg_lum, is_jpeg;
-	static const u8 frame_header[] =
-		{0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96};
+	static const u8 frame_header[] = {
+		0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96
+	};
 
 	is_jpeg = (sd->fmt & 0x03) == 0;
 	if (len >= 64 && memcmp(data, frame_header, 6) == 0) {
-- 
1.9.1

