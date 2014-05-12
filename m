Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbaELQn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:43:58 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.195]:9032 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758781AbaELQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:43:55 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-2.tower-45.messagelabs.com!1399913015!30856954!61
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH 5/7] staging: unisys: remove functions made redundant in uislib.c
Date: Mon, 12 May 2014 12:38:33 -0400
Message-ID: <1399912715-16142-6-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
References: <1399912715-16142-1-git-send-email-benjamin.romer@unisys.com>
X-OriginalArrivalTime: 12 May 2014 16:43:49.0592 (UTC) FILETIME=[59B26580:01CF6E01]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches to move proc files have made the functions
uislib_proc_read_writeonly() and stop_chipset() redundant. Remove them.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 drivers/staging/unisys/uislib/uislib.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index a77936a..3a54450 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -134,11 +134,6 @@ static const struct file_operations proc_info_vbus_fops = {
 	.release = single_release,
 };
 
-static ssize_t uislib_proc_read_writeonly(struct file *file,
-					  char __user *buffer,
-					  size_t count, loff_t *ppos);
-
-
 static ssize_t info_proc_read(struct file *file, char __user *buf,
 			      size_t len, loff_t *offset);
 static const struct file_operations proc_info_fops = {
@@ -859,27 +854,6 @@ init_chipset(CONTROLVM_MESSAGE *msg, char *buf)
 }
 
 static int
-stop_chipset(CONTROLVM_MESSAGE *msg, char *buf)
-{
-	/* Check that all buses and switches have been torn down and
-	 * destroyed.
-	 */
-	if (BusListHead) {
-		/* Buses still exist. */
-		LOGERR("CONTROLVM_CHIPSET_STOP: BusListHead is not NULL");
-		return CONTROLVM_RESP_ERROR_CHIPSET_STOP_FAILED_BUS;
-	}
-	if (BusListCount) {
-		/* BusListHead is NULL, but BusListCount != 0 */
-		LOGERR("CONTROLVM_CHIPSET_STOP: BusListCount != 0");
-		return CONTROLVM_RESP_ERROR_CHIPSET_STOP_FAILED_BUS;
-	}
-
-	/* Buses are shut down. */
-	return visorchipset_chipset_notready();
-}
-
-static int
 delete_bus_glue(U32 busNo)
 {
 	CONTROLVM_MESSAGE msg;
@@ -1410,13 +1384,6 @@ proc_info_vbus_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t
-uislib_proc_read_writeonly(struct file *file, char __user *buffer,
-	       size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
 static struct device_info *
 find_dev(U32 busNo, U32 devNo)
 {
-- 
1.9.1

