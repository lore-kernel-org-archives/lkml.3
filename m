Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab3BZEN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:13:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4411 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758352Ab3BZENz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:13:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,737,1355068800"; 
   d="scan'208";a="6768933"
From: liguang <lig.fnst@cn.fujitsu.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org, jolsa@redhat.com,
        penberg@kernel.org, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] perf: correct a build error
Date: Tue, 26 Feb 2013 12:12:53 +0800
Message-Id: <1361851974-25307-2-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:13:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:13:03,
	Serialize complete at 2013/02/26 12:13:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

builtin-annotate.c: In function 'hists__find_annotations':
builtin-annotate.c:161:4: error: duplicate case value
builtin-annotate.c:154:4: error: previously used here

it happened when no newt installed

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 tools/perf/util/hist.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3862468..b4436e9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -208,8 +208,8 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 	return 0;
 }
 
-#define K_LEFT -1
-#define K_RIGHT -2
+#define K_LEFT -2
+#define K_RIGHT -3
 #endif
 
 #ifdef GTK2_SUPPORT
-- 
1.7.2.5

