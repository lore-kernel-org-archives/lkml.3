Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaGNW4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:56:39 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56662 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbaGNW4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:56:37 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br
Cc: matthew.garrett@nebula.com, Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] drivers/platform/x86/thinkpad_acpi.c: don't test unsigned int for negativity
Date: Tue, 15 Jul 2014 01:56:21 +0300
Message-Id: <1405378581-12146-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80231
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index d82f196..4d59b09 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6144,7 +6144,7 @@ static int brightness_set(unsigned int value)
 {
 	int res;
 
-	if (value > bright_maxlvl || value < 0)
+	if (value > bright_maxlvl)
 		return -EINVAL;
 
 	vdbg_printk(TPACPI_DBG_BRGHT,
-- 
1.8.5.5

