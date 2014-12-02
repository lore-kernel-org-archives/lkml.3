Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbaLBFww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:52:52 -0500
Received: from ozlabs.org ([103.22.144.67]:42569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaLBFwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:52:24 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: shuahkh@osg.samsung.com, Andrew Morton <akpm@osdl.org>,
        gorcunov@openvz.org, Arnd Bergmann <arnd@arndb.de>, cov@codeaurora.org
Subject: [PATCH 2/3] selftests/kcmp: Don't include kernel headers
Date: Tue,  2 Dec 2014 16:52:07 +1100
Message-Id: <1417499528-23377-2-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417499528-23377-1-git-send-email-mpe@ellerman.id.au>
References: <1417499528-23377-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kcmp test mucks with the include path to bring in the kernel
headers, and x86 headers too for reasons that are not clear.

Now that kcmp.h is exported none of that should be necessary.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 tools/testing/selftests/kcmp/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 8aabd82db9e4..4f00c0524501 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -8,11 +8,7 @@ ifeq ($(ARCH),x86_64)
 	ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
-
-CFLAGS += -I../../../../arch/x86/include/generated/
-CFLAGS += -I../../../../include/
 CFLAGS += -I../../../../usr/include/
-CFLAGS += -I../../../../arch/x86/include/
 
 all:
 ifeq ($(ARCH),x86)
-- 
1.9.1

