Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3LBC2f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:28:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24707 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab3LBC2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:28:34 -0500
X-IronPort-AV: E=Sophos;i="4.93,807,1378828800"; 
   d="scan'208";a="9167651"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: peter@hurleysoftware.com, acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH V2] perf Makefile: Correct the message in feature-libnuma checking.
Date: Mon, 2 Dec 2013 10:26:48 -0500
Message-Id: <1385998008-6851-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <529C9DFD.6040707@cn.fujitsu.com>
References: <529C9DFD.6040707@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/02 10:28:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/02 10:28:27,
	Serialize complete at 2013/12/02 10:28:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The package required for numa is named numactl-devel in Fedora or RHEL,
and libnuma-devel in OpenSuSE, and libnuma-dev in Ubuntu. This patch
corrects the package name in warning message in feature-libnuma checking.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 Changes since v1
        - Add libnuma-dev for Ubuntu.

 tools/perf/config/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 80ea6d8..acd3684 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -537,7 +537,7 @@ endif
 
 ifndef NO_LIBNUMA
   ifeq ($(feature-libnuma), 0)
-    msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev);
+    msg := $(warning No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev);
     NO_LIBNUMA := 1
   else
     CFLAGS += -DHAVE_LIBNUMA_SUPPORT
-- 
1.8.2.1

