Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab3LDPlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:41:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab3LDPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:41:51 -0500
Date: Wed, 4 Dec 2013 07:41:31 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-6305edfc4079668ce02e360a6e5aeea88b9dd279@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peter@hurleysoftware.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, peter@hurleysoftware.com,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <1385998008-6851-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1385998008-6851-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Correct the message in feature-libnuma checking.
Git-Commit-ID: 6305edfc4079668ce02e360a6e5aeea88b9dd279
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 07:41:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6305edfc4079668ce02e360a6e5aeea88b9dd279
Gitweb:     http://git.kernel.org/tip/6305edfc4079668ce02e360a6e5aeea88b9dd279
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 2 Dec 2013 10:26:48 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Dec 2013 09:26:39 -0300

perf tools: Correct the message in feature-libnuma checking.

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
index f7d11a8..36e66ac 100644
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
