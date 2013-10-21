Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3JUWns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:43:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37321 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3JUWnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:43:45 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        Peter Moody <pmoody@google.com>,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH v2 18/23] ima: add audit log support for larger hashes
Date: Mon, 21 Oct 2013 18:43:03 -0400
Message-Id: <1382395388-8108-19-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102122-8236-0000-0000-000002F7D212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different files might be signed based on different hash algorithms.
This patch prefixes the audit log measurement hash with the hash
algorithm.

Changelog:
- use generic HASH_ALGO defintions
- use ':' as delimiter between the hash algorithm and the digest
  (Roberto Sassu)

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index baa3481..f22725e 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -287,6 +287,12 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 	audit_log_format(ab, "file=");
 	audit_log_untrustedstring(ab, filename);
 	audit_log_format(ab, " hash=");
+	if (iint->ima_hash->algo != HASH_ALGO_SHA1 &&
+	    iint->ima_hash->algo != HASH_ALGO_MD5) {
+		audit_log_untrustedstring(ab,
+					  hash_algo_name[iint->ima_hash->algo]);
+		audit_log_format(ab, ":");
+	}
 	audit_log_untrustedstring(ab, hash);
 
 	audit_log_task_info(ab, current);
-- 
1.8.1.4

