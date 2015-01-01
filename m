Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbbAAQpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:45:25 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37104 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbAAQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:45:24 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: lasat: sysctl.c:  Remove unused function
Date: Thu,  1 Jan 2015 17:48:23 +0100
Message-Id: <1420130903-29616-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function proc_dolasatint() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/lasat/sysctl.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/mips/lasat/sysctl.c b/arch/mips/lasat/sysctl.c
index 3b7f65c..9d65f1e 100644
--- a/arch/mips/lasat/sysctl.c
+++ b/arch/mips/lasat/sysctl.c
@@ -53,21 +53,6 @@ int proc_dolasatstring(struct ctl_table *table, int write,
 	return 0;
 }
 
-/* proc function to write EEPROM after changing int entry */
-int proc_dolasatint(struct ctl_table *table, int write,
-		       void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int r;
-
-	r = proc_dointvec(table, write, buffer, lenp, ppos);
-	if ((!write) || r)
-		return r;
-
-	lasat_write_eeprom_info();
-
-	return 0;
-}
-
 #ifdef CONFIG_DS1603
 static int rtctmp;
 
-- 
1.7.10.4

