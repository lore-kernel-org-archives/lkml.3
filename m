Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3ASAxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:53:34 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:38097 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3ASAxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:53:33 -0500
From: Cong Ding <dinggnu@gmail.com>
To: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] include/keys/system_keyring.h: fix building error
Date: Sat, 19 Jan 2013 01:53:33 +0100
Message-Id: <1358556813-12518-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I am doing "make randconfig", it causes the following building error if
CONFIG_SYSTEM_TRUSTED_KEYRING is not defined and CONFIG_MODULE_SIG is defined.

kernel/module_signing.c: In function ‘request_asymmetric_key’:
kernel/module_signing.c:161:36: error: ‘system_trusted_keyring’ undeclared
(first use in this function)
kernel/module_signing.c:161:36: note: each undeclared identifier is reported
only once for each function it appears in

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 include/keys/system_keyring.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index 8dabc39..d66c92d 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -12,7 +12,7 @@
 #ifndef _KEYS_SYSTEM_KEYRING_H
 #define _KEYS_SYSTEM_KEYRING_H
 
-#ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
+#if defined(CONFIG_SYSTEM_TRUSTED_KEYRING) || defined(CONFIG_MODULE_SIG)
 
 #include <linux/key.h>
 
-- 
1.7.10.4

