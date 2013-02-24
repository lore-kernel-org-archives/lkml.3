Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab3BXP03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 10:26:29 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55319 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab3BXP01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 10:26:27 -0500
Message-ID: <1361719575.2908.58.camel@falcor1.watson.ibm.com>
Subject: [PATCH 1/2] ima: "remove enforce checking duplication" merge fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module <linux-security-module@vger.kernel.org>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 24 Feb 2013 10:26:15 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022415-5806-0000-0000-0000200D6BF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "750943a ima: remove enforce checking duplication" combined
the 'in IMA policy' and 'enforcing file integrity' checks.  For
the non-file, kernel module verification, a specific check for
'enforcing file integrity' was not added.  This patch adds the
check.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 5127afc..5b14a09 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -284,7 +284,8 @@ int ima_module_check(struct file *file)
 {
 	if (!file) {
 #ifndef CONFIG_MODULE_SIG_FORCE
-		if (ima_appraise & IMA_APPRAISE_MODULES)
+		if ((ima_appraise & IMA_APPRAISE_MODULES) &&
+		    (ima_appraise & IMA_APPRAISE_ENFORCE))
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 #endif
 		return 0;	/* We rely on module signature checking */
-- 
1.8.1.rc3



