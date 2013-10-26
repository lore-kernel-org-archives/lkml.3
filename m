Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3JZU6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:58:05 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:53110 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3JZU6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:58:03 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: linux-kernel@vger.kernel.org
Cc: Krzysztof Mazur <krzysiek@podlesie.net>, Jason Baron <jbaron@akamai.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] DYNAMIC_DEBUG: use select DEBUG_FS instead of depends on
Date: Sat, 26 Oct 2013 22:58:13 +0200
Message-Id: <1382821093-2484-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.1.635.g55556a5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on options that are configured later makes them hard
to enable unless the user knows that he must go backwards.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 06344d9..d5c9247 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -48,7 +48,7 @@ config DYNAMIC_DEBUG
 	bool "Enable dynamic printk() support"
 	default n
 	depends on PRINTK
-	depends on DEBUG_FS
+	select DEBUG_FS
 	help
 
 	  Compiles debug level messages into the kernel, which would not
-- 
1.8.4.1.635.g55556a5

