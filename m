Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaHAI3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:29:41 -0400
Received: from bart.luffy.cx ([78.47.78.131]:56180 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbaHAI3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:29:39 -0400
From: Vincent Bernat <vincent@bernat.im>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Vincent Bernat <vincent@bernat.im>
Subject: [PATCH] staging: visorchipset: fix sparse warnings about static declaration
Date: Fri,  1 Aug 2014 10:29:30 +0200
Message-Id: <1406881770-13808-1-git-send-email-vincent@bernat.im>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions were prototyped as static but the actual definition
wasn't. While this is valid (the function is static because the two
declarations don't conflict and the first one is static), this makes
sparse unhappy and cause confusion of normal people too.

Signed-off-by: Vincent Bernat <vincent@bernat.im>
---
 .../unisys/visorchipset/visorchipset_main.c        | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index 156a72fdabd9..c40ff24a30b9 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -339,8 +339,9 @@ static void controlvm_respond_physdev_changestate(CONTROLVM_MESSAGE_HEADER *
 						  msgHdr, int response,
 						  ULTRA_SEGMENT_STATE state);
 
-ssize_t toolaction_show(struct device *dev, struct device_attribute *attr,
-		char *buf)
+static ssize_t toolaction_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
 {
 	u8 toolAction;
 
@@ -350,8 +351,9 @@ ssize_t toolaction_show(struct device *dev, struct device_attribute *attr,
 	return scnprintf(buf, PAGE_SIZE, "%u\n", toolAction);
 }
 
-ssize_t toolaction_store(struct device *dev, struct device_attribute *attr,
-		const char *buf, size_t count)
+static ssize_t toolaction_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
 {
 	u8 toolAction;
 	int ret;
@@ -369,8 +371,9 @@ ssize_t toolaction_store(struct device *dev, struct device_attribute *attr,
 		return count;
 }
 
-ssize_t boottotool_show(struct device *dev, struct device_attribute *attr,
-		char *buf)
+static ssize_t boottotool_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
 {
 	ULTRA_EFI_SPAR_INDICATION efiSparIndication;
 
@@ -382,8 +385,9 @@ ssize_t boottotool_show(struct device *dev, struct device_attribute *attr,
 			efiSparIndication.BootToTool);
 }
 
-ssize_t boottotool_store(struct device *dev, struct device_attribute *attr,
-		const char *buf, size_t count)
+static ssize_t boottotool_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
 {
 	int val, ret;
 	ULTRA_EFI_SPAR_INDICATION efiSparIndication;
@@ -1932,7 +1936,7 @@ handle_command(CONTROLVM_MESSAGE inmsg, HOSTADDRESS channel_addr)
 	return TRUE;
 }
 
-HOSTADDRESS controlvm_get_channel_address(void)
+static HOSTADDRESS controlvm_get_channel_address(void)
 {
 	U64 addr = 0;
 	U32 size = 0;
-- 
2.0.1

