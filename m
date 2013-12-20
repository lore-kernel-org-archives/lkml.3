Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3LTHzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:55:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3LTHy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:54:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9296746"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/7] perf tools: Set event->header.misc to PERF_RECORD_MISC_GUEST_USER if machine is guest.
Date: Fri, 20 Dec 2013 15:52:58 -0500
Message-Id: <e6f8ff6505d2db8a4b21bff8e448bb9be0bcff35.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:23,
	Serialize complete at 2013/12/20 15:54:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we synthesize the mmap events of user space, if machine is guest, we should
set the event->header.misc to PERF_RECORD_MISC_GUEST_USER, rather than
PERF_RECORD_MISC_USER.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index c75046f..2d90ed8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -220,7 +220,10 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 		 */
-		event->header.misc = PERF_RECORD_MISC_USER;
+		if (machine__is_host(machine))
+			event->header.misc = PERF_RECORD_MISC_USER;
+		else
+			event->header.misc = PERF_RECORD_MISC_GUEST_USER;
 
 		if (prot[2] != 'x') {
 			if (!mmap_data || prot[0] != 'r')
-- 
1.8.2.1

