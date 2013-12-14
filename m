Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3LNAwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:52:18 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36541 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3LNAwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:52:16 -0500
From: "Chen.Yu" <chyyuu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: levex@linux.com, fanwlexca@gmail.com, mans@mansr.com,
        "Chen.Yu" <chyyuu@gmail.com>
Subject: [PATCH] scsi: integer overflow in megadev_ioctl()
Date: Sat, 14 Dec 2013 08:51:53 +0800
Message-Id: <1386982313-30054-1-git-send-email-chyyuu@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen.Yu" <chyyuu@gmail.com>

There is a potential integer overflow in megadev_ioctl() if
userspace passes in a large u32 variable uioc.adapno.
The int variable adapno would < 0, leading to an error
array access for hdb_soft_state[adapno], or an error
copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,..).
The simple fix is to  the simpler fix is to change the type
of 'adapno' to u32, which is the type of uioc.adapno to u32.

Signed-off-by: Yu Chen <chyyuu@gmail.com>
---
 drivers/scsi/megaraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 816db12..724c5a5 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -3038,7 +3038,7 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	adapter_t	*adapter;
 	nitioctl_t	uioc;
-	int		adapno;
+	u32		adapno;
 	int		rval;
 	mega_passthru	__user *upthru;	/* user address for passthru */
 	mega_passthru	*pthru;		/* copy user passthru here */
-- 
1.8.3.2

