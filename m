Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaJHXbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:31:48 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:38216 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaJHXbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:31:39 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, jkosina@suse.cz, luto@amacapital.net, hpa@zytor.com,
        jwboyer@fedoraproject.org, linux-doc@vger.kernel.org,
        cebbert.lkml@gmail.com, torvalds@linuxfoundation.org,
        Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH] Only build Documentation/ when not cross-compiling
Date: Wed,  8 Oct 2014 19:31:31 -0400
Message-Id: <1412811091-26702-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't build Documentation targets when cross-compiling.
They are only for build testing, and use the host headers and compiler
which can cause cross-compiles to fail.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a285900..1beeb84 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1610,7 +1610,7 @@ config PROVIDE_OHCI1394_DMA_INIT
 
 config BUILD_DOCSRC
 	bool "Build targets in Documentation/ tree"
-	depends on HEADERS_CHECK
+	depends on HEADERS_CHECK && CROSS_COMPILE=""
 	help
 	  This option attempts to build objects from the source files in the
 	  kernel Documentation/ tree.
-- 
2.1.2

