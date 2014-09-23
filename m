Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaIWCe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:34:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:37451 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbaIWCeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:34:24 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 04/45] HID: fix a couple of off-by-ones
Date: Tue, 23 Sep 2014 10:31:06 +0800
Message-Id: <1411439507-30391-4-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 4ab25786c87eb20857bbb715c3ae34ec8fd6a214 upstream.

There are a few very theoretical off-by-one bugs in report descriptor size
checking when performing a pre-parsing fixup. Fix those.

Reported-by: Ben Hawkes <hawkes@google.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/hid/hid-cherry.c   |    2 +-
 drivers/hid/hid-kye.c      |    2 +-
 drivers/hid/hid-lg.c       |    4 ++--
 drivers/hid/hid-monterey.c |    2 +-
 drivers/hid/hid-petalynx.c |    2 +-
 drivers/hid/hid-sunplus.c  |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index 888ece6..f870bb3 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -29,7 +29,7 @@
 static __u8 *ch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 17 && rdesc[11] == 0x3c && rdesc[12] == 0x02) {
+	if (*rsize >= 18 && rdesc[11] == 0x3c && rdesc[12] == 0x02) {
 		hid_info(hdev, "fixing up Cherry Cymotion report descriptor\n");
 		rdesc[11] = rdesc[16] = 0xff;
 		rdesc[12] = rdesc[17] = 0x03;
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index b4f0d82..d7118f8 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -282,7 +282,7 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 *   - change the button usage range to 4-7 for the extra
 		 *     buttons
 		 */
-		if (*rsize >= 74 &&
+		if (*rsize >= 75 &&
 			rdesc[61] == 0x05 && rdesc[62] == 0x08 &&
 			rdesc[63] == 0x19 && rdesc[64] == 0x08 &&
 			rdesc[65] == 0x29 && rdesc[66] == 0x0f &&
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index e7a7bd1..cb01e67 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -111,7 +111,7 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
-	if ((quirks & LG_RDESC) && *rsize >= 90 && rdesc[83] == 0x26 &&
+	if ((quirks & LG_RDESC) && *rsize >= 91 && rdesc[83] == 0x26 &&
 			rdesc[84] == 0x8c && rdesc[85] == 0x02) {
 		hid_info(hdev,
 			 "fixing up Logitech keyboard report descriptor\n");
@@ -120,7 +120,7 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	}
 	if ((quirks & LG_RDESC_REL_ABS) && *rsize >= 50 &&
 			rdesc[32] == 0x81 && rdesc[33] == 0x06 &&
-			rdesc[49] == 0x81 && rdesc[50] == 0x06) {
+			rdesc[49] == 0x81 && rdesc[51] == 0x06) {
 		hid_info(hdev,
 			 "fixing up rel/abs in Logitech report descriptor\n");
 		rdesc[33] = rdesc[50] = 0x02;
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index dedf757..eb0271e 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -25,7 +25,7 @@
 static __u8 *mr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 30 && rdesc[29] == 0x05 && rdesc[30] == 0x09) {
+	if (*rsize >= 31 && rdesc[29] == 0x05 && rdesc[30] == 0x09) {
 		hid_info(hdev, "fixing up button/consumer in HID report descriptor\n");
 		rdesc[30] = 0x0c;
 	}
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index f1ea3ff..99f317a 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -26,7 +26,7 @@
 static __u8 *pl_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 60 && rdesc[39] == 0x2a && rdesc[40] == 0xf5 &&
+	if (*rsize >= 62 && rdesc[39] == 0x2a && rdesc[40] == 0xf5 &&
 			rdesc[41] == 0x00 && rdesc[59] == 0x26 &&
 			rdesc[60] == 0xf9 && rdesc[61] == 0x00) {
 		hid_info(hdev, "fixing up Petalynx Maxter Remote report descriptor\n");
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index d484a00..3d6ae7b 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -25,7 +25,7 @@
 static __u8 *sp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 107 && rdesc[104] == 0x26 && rdesc[105] == 0x80 &&
+	if (*rsize >= 112 && rdesc[104] == 0x26 && rdesc[105] == 0x80 &&
 			rdesc[106] == 0x03) {
 		hid_info(hdev, "fixing up Sunplus Wireless Desktop report descriptor\n");
 		rdesc[105] = rdesc[110] = 0x03;
-- 
1.7.9.5

