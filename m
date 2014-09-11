Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaIKM6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:58:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51566 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ben Hawkes" <hawkes@google.com>,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        "Jiri Kosina" <jkosina@suse.cz>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.559364587@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 083/131] HID: fix a couple of off-by-ones
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 4ab25786c87eb20857bbb715c3ae34ec8fd6a214 upstream.

There are a few very theoretical off-by-one bugs in report descriptor size
checking when performing a pre-parsing fixup. Fix those.

Reported-by: Ben Hawkes <hawkes@google.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-cherry.c   | 2 +-
 drivers/hid/hid-kye.c      | 2 +-
 drivers/hid/hid-lg.c       | 4 ++--
 drivers/hid/hid-monterey.c | 2 +-
 drivers/hid/hid-petalynx.c | 2 +-
 drivers/hid/hid-sunplus.c  | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

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
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -26,7 +26,7 @@
 static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize >= 74 &&
+	if (*rsize >= 75 &&
 		rdesc[61] == 0x05 && rdesc[62] == 0x08 &&
 		rdesc[63] == 0x19 && rdesc[64] == 0x08 &&
 		rdesc[65] == 0x29 && rdesc[66] == 0x0f &&
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -111,14 +111,14 @@ static __u8 *lg_report_fixup(struct hid_
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
-	if ((quirks & LG_RDESC) && *rsize >= 90 && rdesc[83] == 0x26 &&
+	if ((quirks & LG_RDESC) && *rsize >= 91 && rdesc[83] == 0x26 &&
 			rdesc[84] == 0x8c && rdesc[85] == 0x02) {
 		hid_info(hdev,
 			 "fixing up Logitech keyboard report descriptor\n");
 		rdesc[84] = rdesc[89] = 0x4d;
 		rdesc[85] = rdesc[90] = 0x10;
 	}
-	if ((quirks & LG_RDESC_REL_ABS) && *rsize >= 50 &&
+	if ((quirks & LG_RDESC_REL_ABS) && *rsize >= 51 &&
 			rdesc[32] == 0x81 && rdesc[33] == 0x06 &&
 			rdesc[49] == 0x81 && rdesc[50] == 0x06) {
 		hid_info(hdev,
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

