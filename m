Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaFDV1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:27:18 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34111 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaFDV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:27:16 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Randy Dunlap <rdunlap@infradead.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Stefan Weil <sw@weilnetz.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: laptops: hpfall.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:28:10 +0200
Message-Id: <1401917290-2689-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 Documentation/laptops/hpfall.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/laptops/hpfall.c b/Documentation/laptops/hpfall.c
index b85dbba..6708432 100644
--- a/Documentation/laptops/hpfall.c
+++ b/Documentation/laptops/hpfall.c
@@ -28,6 +28,7 @@ int set_unload_heads_path(char *device)
 	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
 		return -EINVAL;
 	strncpy(devname, device + 5, sizeof(devname));
+	devname[sizeof(devname) - 1] = '\0';
 
 	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
 				"/sys/block/%s/device/unload_heads", devname);
-- 
1.7.10.4

