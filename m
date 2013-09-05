Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607Ab3IEJPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:15:05 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:56769 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763266Ab3IEJPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:15:01 -0400
X-Greylist: delayed 2364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2013 05:15:01 EDT
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-perf-users@vger.kernel.org,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH] perf tools: Clarify error when running "perf lock record"
Date: Thu,  5 Sep 2013 09:32:16 +0100
Message-Id: <1378369936-26473-1-git-send-email-rodrigo@sdfg.com.ar>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you have the config options enabled in your kernel, you still need to be root
to run perf lock. And is kind of misleading when you have that options enabled
and the error says that they might not be.

So, this patch just adds to the error that it should be run as root. Although we
can probably check if it's running as root or not, adding it to the error
message is really simple and should be enough.

Signed-off-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
---
Please keep me in Cc: since I'm not subscribed
---
 tools/perf/builtin-lock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 76543a4..f07b318 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -886,8 +886,8 @@ static int __cmd_record(int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(lock_tracepoints); i++) {
 		if (!is_valid_tracepoint(lock_tracepoints[i].name)) {
 				pr_err("tracepoint %s is not enabled. "
-				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled?\n",
-				       lock_tracepoints[i].name);
+				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled "
+				       "and running as root?\n", lock_tracepoints[i].name);
 				return 1;
 		}
 	}
-- 
1.7.10.4

