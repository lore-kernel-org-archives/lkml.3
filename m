Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbbAWV5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:57:45 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:36909 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbbAWV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:57:43 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] modsign: overwrite keys with zero before deleting them
Date: Fri, 23 Jan 2015 22:57:01 +0100
Message-Id: <1422050221-28345-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1421976009-9819-1-git-send-email-holler@ahsoftware.de>
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for the more paranoid people, also it's
questionable what paranoid nowadays means.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 7ad66de..590ff53 100644
--- a/Makefile
+++ b/Makefile
@@ -1132,7 +1132,9 @@ ifeq ($(CONFIG_MODULE_SIG_THROW_AWAY), y)
 	@echo "###"
 	@echo "### Deleting key used to sign modules."
 	@echo "###"
+	@dd status=none if=/dev/zero of=./signing_key.priv bs=4096 count=1
 	@rm ./signing_key.priv
+	@dd status=none if=/dev/zero of=./signing_key.x509 bs=4096 count=1
 	@rm ./signing_key.x509
 endif
 
-- 
2.0.5

