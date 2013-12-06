Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3LFJ1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:27:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757294Ab3LFJ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:27:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,839,1378828800"; 
   d="scan'208";a="9205955"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] perf tools: Make perf kvm diff support --guestmount.
Date: Fri, 6 Dec 2013 17:25:52 -0500
Message-Id: <72857ed89642e0633f5e88f7e7abbc9645359e8e.1386368672.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com>
References: <5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 17:27:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 17:27:28,
	Serialize complete at 2013/12/06 17:27:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In manpage of perf-kvm, --guestmount is supported by diff command,
but it does not work well.

This patch change the extend the checking in buildid-diff from
guestkallsyms or guestmodules to perf_guest. Then this checking can
cover the all cases perf kvm is used for.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-diff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2..2a85cc9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1000,8 +1000,7 @@ static int data_init(int argc, const char **argv)
 			data__files_cnt = argc;
 			use_default = false;
 		}
-	} else if (symbol_conf.default_guest_vmlinux_name ||
-		   symbol_conf.default_guest_kallsyms) {
+	} else if (perf_guest) {
 		defaults[0] = "perf.data.host";
 		defaults[1] = "perf.data.guest";
 	}
-- 
1.8.2.1

