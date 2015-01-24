Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbbAXKqN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:46:13 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:57613 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbbAXKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:46:11 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH v2] modsign: use shred to overwrite the private key before deleting it
Date: Sat, 24 Jan 2015 11:45:27 +0100
Message-Id: <1422096327-4483-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <54C2F4F8.20809@draigBrady.com>
References: <54C2F4F8.20809@draigBrady.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for the more paranoid people, also it's
questionable what paranoid nowadays means.

It uses shred, in the hope it will somedays learn how to shred stuff on
FLASH based devices securely too, once that has become possible.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7ad66de..733421b 100644
--- a/Makefile
+++ b/Makefile
@@ -1132,7 +1132,7 @@ ifeq ($(CONFIG_MODULE_SIG_THROW_AWAY), y)
 	@echo "###"
 	@echo "### Deleting key used to sign modules."
 	@echo "###"
-	@rm ./signing_key.priv
+	@shred -n1 -u ./signing_key.priv
 	@rm ./signing_key.x509
 endif
 
-- 
2.1.0

