Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3L3Lfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:35:50 -0500
Received: from qemu.weilnetz.de ([37.221.198.45]:34790 "EHLO
	v2201305906712890.yourvserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517Ab3L3Lft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:35:49 -0500
From: Stefan Weil <sw@weilnetz.de>
To: trivial@kernel.org
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Weil <sw@weilnetz.de>
Subject: [PATCH] Documentation: Fix size parameter for snprintf (reported by cppcheck)
Date: Mon, 30 Dec 2013 12:35:43 +0100
Message-Id: <1388403343-20132-1-git-send-email-sw@weilnetz.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck reports this error:

Documentation/laptops/hpfall.c:33]: (error)
 Dangerous usage of 'devname' (strncpy doesn't always 0-terminate it)

The terminating '\0' is needed for the global char array unload_heads_path,
so never write the last array entry (which is initially '\0').

Signed-off-by: Stefan Weil <sw@weilnetz.de>
---

This is only code in the documentation, nevertheless even there a correction
might help other users.

Cheers and happy new year

Stefan Weil

 Documentation/laptops/hpfall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/laptops/hpfall.c b/Documentation/laptops/hpfall.c
index a4a8fc5..b85dbba 100644
--- a/Documentation/laptops/hpfall.c
+++ b/Documentation/laptops/hpfall.c
@@ -29,7 +29,7 @@ int set_unload_heads_path(char *device)
 		return -EINVAL;
 	strncpy(devname, device + 5, sizeof(devname));
 
-	snprintf(unload_heads_path, sizeof(unload_heads_path),
+	snprintf(unload_heads_path, sizeof(unload_heads_path) - 1,
 				"/sys/block/%s/device/unload_heads", devname);
 	return 0;
 }
-- 
1.7.10.4

