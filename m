Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3DMTuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 15:50:06 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53203 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3DMTuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 15:50:05 -0400
From: Tommi Rantala <tt.rantala@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com,
        Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] perf: treat attr.config as u64 in perf_swevent_init()
Date: Sat, 13 Apr 2013 22:49:14 +0300
Message-Id: <1365882554-30259-1-git-send-email-tt.rantala@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trinity discovered that we fail to check all 64 bits of attr.config
passed by user space, resulting to out-of-bounds access of the
perf_swevent_enabled array in sw_perf_event_destroy().

Introduced in commit b0a873ebb ("perf: Register PMU implementations").

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 59412d0..fff6420 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5330,7 +5330,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
-- 
1.8.1.4

