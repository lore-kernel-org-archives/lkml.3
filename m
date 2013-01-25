Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3AYXUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:20:16 -0500
Received: from mout.gmx.net ([212.227.15.19]:64810 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3AYXUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:20:13 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19DcItGRklDDEW6x+3mic1ciYl4bEm+xolhUDvu9x
	NmT763ocJjwixq
From: Peter Huewe <peterhuewe@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Volokh Konstantin <volokh84@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>, David Howells <dhowells@redhat.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/media/go7007: Use kmemdup rather than duplicating its implementation
Date: Sat, 26 Jan 2013 00:23:30 +0100
Message-Id: <1359156210-4482-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with coccicheck.
The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/media/go7007/go7007-driver.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index ece2dd1..0e299f0 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -108,14 +108,13 @@ static int go7007_load_encoder(struct go7007 *go)
 		return -1;
 	}
 	fw_len = fw_entry->size - 16;
-	bounce = kmalloc(fw_len, GFP_KERNEL);
+	bounce = kmemdup(fw_entry->data + 16, fw_len, GFP_KERNEL);
 	if (bounce == NULL) {
 		v4l2_err(go, "unable to allocate %d bytes for "
 				"firmware transfer\n", fw_len);
 		release_firmware(fw_entry);
 		return -1;
 	}
-	memcpy(bounce, fw_entry->data + 16, fw_len);
 	release_firmware(fw_entry);
 	if (go7007_interface_reset(go) < 0 ||
 			go7007_send_firmware(go, bounce, fw_len) < 0 ||
-- 
1.7.8.6

