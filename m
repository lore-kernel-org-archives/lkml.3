Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab3LBUtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:49:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54054 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3LBUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:49:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/12] perf tools: Correct the message in feature-libnuma checking.
Date: Mon,  2 Dec 2013 17:49:07 -0300
Message-Id: <1386017349-24486-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

The package required for numa is named numactl-devel in Fedora or RHEL,
and libnuma-devel in OpenSuSE, and libnuma-dev in Ubuntu.

This patch corrects the package name in warning message in
feature-libnuma checking.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Acked-by: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Link: http://lkml.kernel.org/r/1385998008-6851-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f7d11a811c74..36e66ac40abc 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -533,7 +533,7 @@ endif
 
 ifndef NO_LIBNUMA
   ifeq ($(feature-libnuma), 0)
-    msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
+    msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev);
     NO_LIBNUMA := 1
   else
     CFLAGS += -DHAVE_LIBNUMA_SUPPORT
-- 
1.8.1.4

