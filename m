Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936278Ab3DHVlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:41:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:30265 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761587Ab3DHVlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,433,1363158000"; 
   d="scan'208";a="319346117"
From: David Cohen <david.a.cohen@intel.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@intel.com>
Subject: [PATCH] MODSIGN: do not send garbage to stderr when enabling modules signature
Date: Mon,  8 Apr 2013 14:43:56 -0700
Message-Id: <1365457436-5753-1-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

openssl may send garbage to stderr when generating X.509 key pair for
modules signature regardless there was an error or not. It makes more
difficult to create scripts based on kernel error/warning messages.
This patch makes sure openssl logs go to default stdout.

Signed-off-by: David Cohen <david.a.cohen@intel.com>
---
 kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index bbde5f1..5a51e6c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -175,7 +175,7 @@ signing_key.priv signing_key.x509: x509.genkey
 	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 \
 		-batch -x509 -config x509.genkey \
 		-outform DER -out signing_key.x509 \
-		-keyout signing_key.priv
+		-keyout signing_key.priv 2>&1
 	@echo "###"
 	@echo "### Key pair generated."
 	@echo "###"
-- 
1.7.10.4

