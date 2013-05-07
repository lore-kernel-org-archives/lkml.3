Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab3EGNkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3EGNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tommi Rantala <tt.rantala@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, davej@redhat.com,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 013/118] perf: Treat attr.config as u64 in perf_swevent_init()
Date: Tue,  7 May 2013 14:37:39 +0100
Message-Id: <1367933964-1564-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommi Rantala <tt.rantala@gmail.com>

commit 8176cced706b5e5d15887584150764894e94e02f upstream.

Trinity discovered that we fail to check all 64 bits of
attr.config passed by user space, resulting to out-of-bounds
access of the perf_swevent_enabled array in
sw_perf_event_destroy().

Introduced in commit b0a873ebb ("perf: Register PMU
implementations").

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: davej@redhat.com
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1365882554-30259-1-git-send-email-tt.rantala@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 11409af..0181cbd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5129,7 +5129,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
-- 
1.8.1.2

