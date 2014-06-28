Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaF1Ngj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:36:39 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:45989 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbaF1Ngh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:36:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHABPErlNbsk2v/2dsb2JhbABagw2regUBAQEBAQEFAW0BmQKBCBd1hDEvI4EaN4hGAcVSF4VkiSEdhC0Fml2LP4g8ggCBRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: bonbons@linux-vserver.org, Fabian Frederick <fabf@skynet.be>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Subject: [PATCH 1/1] drivers/hid/hid-picolcd_debugfs.c: remove unnecessary NULL test before debugfs_remove
Date: Sat, 28 Jun 2014 15:35:03 +0200
Message-Id: <1403962503-8507-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: debugfs_remove(NULL) is safe this check is probably not required

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/hid/hid-picolcd_debugfs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
index 024cdf3..3c13af6 100644
--- a/drivers/hid/hid-picolcd_debugfs.c
+++ b/drivers/hid/hid-picolcd_debugfs.c
@@ -883,16 +883,13 @@ void picolcd_exit_devfs(struct picolcd_data *data)
 
 	dent = data->debug_reset;
 	data->debug_reset = NULL;
-	if (dent)
-		debugfs_remove(dent);
+	debugfs_remove(dent);
 	dent = data->debug_eeprom;
 	data->debug_eeprom = NULL;
-	if (dent)
-		debugfs_remove(dent);
+	debugfs_remove(dent);
 	dent = data->debug_flash;
 	data->debug_flash = NULL;
-	if (dent)
-		debugfs_remove(dent);
+	debugfs_remove(dent);
 	mutex_destroy(&data->mutex_flash);
 }
 
-- 
1.8.4.5

