Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaHTRM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:12:58 -0400
Received: from mail.cs.hut.fi ([130.233.192.7]:47621 "EHLO mail.cs.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaHTRM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:12:56 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2014 13:12:56 EDT
Date: Wed, 20 Aug 2014 20:03:26 +0300 (EEST)
From: Ari Sundholm <asundhol@cs.hut.fi>
X-X-Sender: asundhol@hutcs
To: platform-driver-x86@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] Revert "platform/x86/toshiba-apci.c possible bad if test?"
Message-ID: <alpine.GSO.2.00.1408201955290.8292@hutcs>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ari Sundholm <ari@tuxera.com>

This reverts commit bdc3ae7221213963f438faeaa69c8b4a2195f491.

Signed-off-by: Ari Sundholm <ari@tuxera.com>
---
 drivers/platform/x86/toshiba_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index e4da61b..b062d3d 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1258,7 +1258,7 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
 	int mode = -1;
 	int time = -1;
 
-	if (sscanf(buf, "%i", &mode) != 1  || (mode != 2 || mode != 1))
+	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
 		return -EINVAL;
 
 	/* Set the Keyboard Backlight Mode where:
-- 
1.9.1
