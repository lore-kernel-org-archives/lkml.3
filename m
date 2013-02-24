Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab3BXWP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:15:58 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58190 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364Ab3BXWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:15:57 -0500
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        borntraeger@de.ibm.com, jang@linux.vnet.ibm.com,
        linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syamsidhardh@gmail.com
Subject: [PATCH] s390/dis: Fix invalid array size
Date: Mon, 25 Feb 2013 03:45:45 +0530
Message-Id: <1361744145-28112-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using sizeof operator for an array given as function argument,
which is incorrect.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 arch/s390/kernel/dis.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index c50665f..3ad5e95 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -1711,10 +1711,10 @@ int insn_to_mnemonic(unsigned char *instruction, char buf[8])
 	if (!insn)
 		return -ENOENT;
 	if (insn->name[0] == '\0')
-		snprintf(buf, sizeof(buf), "%s",
+		snprintf(buf, 8, "%s",
 			 long_insn_name[(int) insn->name[1]]);
 	else
-		snprintf(buf, sizeof(buf), "%.5s", insn->name);
+		snprintf(buf, 8, "%.5s", insn->name);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(insn_to_mnemonic);
-- 
1.7.9.5

