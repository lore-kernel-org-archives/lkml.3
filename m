Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898AbaBDVc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:32:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451AbaBDVMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 3.13 096/140] ima: change the default hash algorithm to SHA1 in ima_eventdigest_ng_init()
Date: Tue,  4 Feb 2014 13:11:23 -0800
Message-Id: <20140204211039.718740234@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@polito.it>

commit c502c78ba7fb5b9cef71e2bd70f12c38ef26e5ab upstream.

Replace HASH_ALGO__LAST with HASH_ALGO_SHA1 as the initial value of
the hash algorithm so that the prefix 'sha1:' is added to violation
digests.

Fix commit:
  4d7aeee ima: define new template ima-ng and template fields d-ng and n-ng

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_template_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -255,7 +255,7 @@ int ima_eventdigest_ng_init(struct integ
 			    struct evm_ima_xattr_data *xattr_value,
 			    int xattr_len, struct ima_field_data *field_data)
 {
-	u8 *cur_digest = NULL, hash_algo = HASH_ALGO__LAST;
+	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
 	u32 cur_digestsize = 0;
 
 	/* If iint is NULL, we are recording a violation. */


