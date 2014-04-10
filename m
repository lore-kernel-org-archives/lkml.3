Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbaDJQx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:53:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51012 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaDJQx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:53:27 -0400
From: Richard Yao <ryao@gentoo.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>
Subject: [PATCH] perf machine: Search for modules in %s/lib/modules/%s
Date: Thu, 10 Apr 2014 12:52:59 -0400
Message-Id: <1397148779-9169-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modules installed outside of the kernel's build system should go into
"%s/lib/modules/%s/extra", but at present, perf will only look at them
when they are in "%s/lib/modules/%s/kernel". Lets encourage good
citizenship by relaxing this requirement to "%s/lib/modules/%s". This
way open source modules that are out-of-tree have no incentive to start
populating a directory reserved for in-kernle modules and I can stop hex
editing my system's perf binary when profiling OSS out-of-tree modules.

Signed-off-by: Richard Yao <ryao@gentoo.org>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a53cd0b..116842e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -786,7 +786,7 @@ static int machine__set_modules_path(struct machine *machine)
 	if (!version)
 		return -1;
 
-	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
+	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s",
 		 machine->root_dir, version);
 	free(version);
 
-- 
1.8.3.2

