Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3ASAys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:54:48 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:47343 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3ASAyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:54:46 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH next-20130118 1/2] KEYS: Fix build-error when SYSTEM_TRUSTED_KEYRING=n
Date: Sat, 19 Jan 2013 01:54:30 +0100
Message-Id: <1358556871-6651-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SYSTEM_TRUSTED_KEYRING=n my build fails like this:

kernel/module_signing.c: In function 'request_asymmetric_key':
kernel/module_signing.c:161:36: error: 'system_trusted_keyring' undeclared (first use in this function)
kernel/module_signing.c:161:36: note: each undeclared identifier is reported only once for each function it appears in

Fix this by replacing "select" with "depends on" KEYS Kconfig.

For more details follow the thread in [1].

[1] http://marc.info/?t=135854545000001&r=1&w=2

Tested against Linux-Next (next-20130118).

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index fb2959d..f7e1b32 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1607,7 +1607,7 @@ config BASE_SMALL
 
 config SYSTEM_TRUSTED_KEYRING
 	bool "Provide system-wide ring of trusted keys"
-	select KEYS
+	depends on KEYS
 	help
 	  Provide a system keyring to which trusted keys can be added.  Keys in
 	  the keyring are considered to be trusted.  Keys may be added at will
-- 
1.8.1.1

