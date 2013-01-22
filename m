Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3AVA3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:29:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:20893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3AVA3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:29:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,510,1355126400"; 
   d="scan'208";a="250457397"
From: Sathish Kuppuswamy <sathish.kuppuswamy@intel.com>
To: linux-kernel@vger.kernel.org, len.brown@intel.com
Cc: josh.triplett@intel.com, Sathish Kuppuswamy <sathish.kuppuswamy@intel.com>
Subject: turbostat:add support for DESTDIR in make install
Date: Mon, 21 Jan 2013 16:28:17 -0800
Message-Id: <1358814497-8112-1-git-send-email-sathish.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding DESTDIR makes it easier for distributions to create and build packages of turbostat 
as normal user. It also provides space for choosing target directory to deploy the packages

Signed-off-by: Sathish Kuppuswamy <sathish.kuppuswamy@intel.com>
---
 tools/power/x86/turbostat/Makefile |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index fd8e1f1..d5eedfb 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -3,6 +3,8 @@ turbostat : turbostat.c
 clean :
 	rm -f turbostat
 
-install :
-	install turbostat /usr/bin/turbostat
-	install turbostat.8 /usr/share/man/man8
+install : 
+	mkdir -p ${DESTDIR}/usr/bin
+	mkdir -p ${DESTDIR}/usr/share/man/man8
+	install turbostat ${DESTDIR}/usr/bin/turbostat
+	install turbostat.8 ${DESTDIR}/usr/share/man/man8
-- 
1.7.9.5

