Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbaIILCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:02:34 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:49083 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbaIILCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:02:30 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] kbuild: use $(Q) for sub-make target
Date: Tue,  9 Sep 2014 20:02:23 +0900
Message-Id: <1410260544-22657-3-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 066b7ed9558087a7957a1128f27d7a3462ff117f
(kbuild: Do not print the build directory with make -s),
"Q" is defined above the sub-make target.

This commit takes advantage of that and replaces
"$(if $(KBUILD_VERBOSE:1=),@)" with "$(Q)".

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index c1bd5a4..105919a 100644
--- a/Makefile
+++ b/Makefile
@@ -171,8 +171,7 @@ $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 	@:
 
 sub-make: FORCE
-	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
-	KBUILD_SRC=$(CURDIR) \
+	$(Q)$(MAKE) -C $(KBUILD_OUTPUT) KBUILD_SRC=$(CURDIR) \
 	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
 	$(filter-out _all sub-make,$(MAKECMDGOALS))
 
-- 
1.9.1

