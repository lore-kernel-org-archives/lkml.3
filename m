Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaG0OjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 10:39:20 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62313 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaG0OjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 10:39:18 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Randy Dunlap <rdunlap@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Stefan Weil <sw@weilnetz.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: laptops: freefall.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 16:40:43 +0200
Message-Id: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 Documentation/laptops/freefall.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/laptops/freefall.c b/Documentation/laptops/freefall.c
index aab2ff0..113d004 100644
--- a/Documentation/laptops/freefall.c
+++ b/Documentation/laptops/freefall.c
@@ -33,8 +33,10 @@ static int set_unload_heads_path(char *device)
 
 	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
 		return -EINVAL;
-	strncpy(devname, device + 5, sizeof(devname) - 1);
-	strncpy(device_path, device, sizeof(device_path) - 1);
+	strncpy(devname, device + 5, sizeof(devname));
+	devname[sizeof(devname) - 1] = '\0';
+	strncpy(device_path, device, sizeof(device_path));
+	device_path[sizeof(device_path) - 1] = '\0';
 
 	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
 				"/sys/block/%s/device/unload_heads", devname);
-- 
1.7.10.4

