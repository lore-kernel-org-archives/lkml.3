Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3LLFM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:12:27 -0500
Received: from ozlabs.org ([203.10.76.45]:48168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3LLFMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:12:25 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: acme@ghostprotocols.net
Cc: <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        mingo@redhat.com
Subject: [PATCH] tools/perf: Fix cross compilation
Date: Thu, 12 Dec 2013 16:12:14 +1100
Message-Id: <1386825134-11567-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b6aa997 "Add feature check core code" added feature checking
logic in config/feature-checks/Makefile but didn't use the CROSS_COMPILE
value.

Fix it by prefixing $(CC), as is done in Makefile.perf.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/perf/config/feature-checks/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index bc86462..f3946db 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -28,7 +28,7 @@ FILES=					\
 	test-stackprotector-all		\
 	test-timerfd
 
-CC := $(CC) -MD
+CC := $(CROSS_COMPILE)$(CC) -MD
 
 all: $(FILES)
 
-- 
1.8.3.2

