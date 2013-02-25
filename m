Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab3BYEnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 23:43:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41298 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759895Ab3BYEmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 23:42:52 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] ima: "remove enforce checking duplication" merge fix
Date: Sun, 24 Feb 2013 23:42:36 -0500
Message-Id: <1361767357-8465-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1361767357-8465-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1361767357-8465-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022504-5806-0000-0000-0000200FD0AF
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

