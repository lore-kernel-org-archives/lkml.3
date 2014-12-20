Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaLTXHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 18:07:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38774 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaLTXHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 18:07:03 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Achim Leubner <achim_leubner@adaptec.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: gdth_proc.c:  Remove unused function
Date: Sun, 21 Dec 2014 00:09:48 +0100
Message-Id: <1419116988-13467-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function gdth_ioctl_check_bin() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/gdth_proc.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 9fb6326..efb9df5 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -598,24 +598,6 @@ static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, u64 paddr)
     }
 }
 
-#ifdef GDTH_IOCTL_PROC
-static int gdth_ioctl_check_bin(gdth_ha_str *ha, u16 size)
-{
-    unsigned long flags;
-    int ret_val;
-
-    spin_lock_irqsave(&ha->smp_lock, flags);
-
-    ret_val = FALSE;
-    if (ha->scratch_busy) {
-        if (((gdth_iord_str *)ha->pscratch)->size == (u32)size)
-            ret_val = TRUE;
-    }
-    spin_unlock_irqrestore(&ha->smp_lock, flags);
-    return ret_val;
-}
-#endif
-
 static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
     unsigned long flags;
-- 
1.7.10.4

