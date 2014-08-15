Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaHOGTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:19:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:58235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaHOGTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,867,1400050800"; 
   d="scan'208";a="468999907"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: zohar@linux.vnet.ibm.com, safford@us.ibm.com
Cc: dhowells@redhat.com, james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] keys, encrypted: add forgotten newline characters
Date: Fri, 15 Aug 2014 09:18:56 +0300
Message-Id: <1408083536-8578-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was debugging patches that I'm working for trusted keys.

I have a test case where I seal an encrypted key with a trusted
key. Piping of the encrypted key failed but I couldn't see any
error message from  the encrypted subsystem. Then I tried my
test a second time and error message was visible in klog.

The root cause was the forgotten newline characters. This patch
fixes the issue.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 security/keys/encrypted-keys/encrypted.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 5fe443d..406f6cb 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -447,10 +447,10 @@ static struct key *request_master_key(struct encrypted_key_payload *epayload,
 		int ret = PTR_ERR(mkey);
 
 		if (ret == -ENOTSUPP)
-			pr_info("encrypted_key: key %s not supported",
+			pr_info("encrypted_key: key %s not supported\n",
 				epayload->master_desc);
 		else
-			pr_info("encrypted_key: key %s not found",
+			pr_info("encrypted_key: key %s not found\n",
 				epayload->master_desc);
 		goto out;
 	}
-- 
1.9.1

