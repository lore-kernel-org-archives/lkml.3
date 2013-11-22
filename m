Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3KVOSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:18:38 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:33389 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3KVOSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:18:37 -0500
Date: Fri, 22 Nov 2013 15:18:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mimi Zohar <zohar@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ima: add missing "inline" to integrity_init_keyring()
Message-ID: <20131122141831.GD4208@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112214-8372-0000-0000-000007DA9CA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing "inline" statement to prevent couple of compiler warnings:

In file included from security/integrity/integrity_audit.c:16:0:
security/integrity/integrity.h:149:12: warning: 'integrity_init_keyring'
  defined but not used [-Wunused-function]

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 security/integrity/integrity.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index b9e7c133734a..c3d48dc4d6cf 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -146,7 +146,7 @@ static inline int asymmetric_verify(struct key *keyring, const char *sig,
 	return -EOPNOTSUPP;
 }
 
-static int integrity_init_keyring(const unsigned int id)
+static inline int integrity_init_keyring(const unsigned int id)
 {
 	return 0;
 }
-- 
1.8.3.4

