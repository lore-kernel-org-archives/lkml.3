Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaDNOVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbaDNOSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:18:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Richard Yao <ryao@gentoo.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 16/17] perf machine: Search for modules in %s/lib/modules/%s
Date: Mon, 14 Apr 2014 16:17:40 +0200
Message-Id: <1397485061-17215-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Yao <ryao@gentoo.org>

Modules installed outside of the kernel's build system should go into
"%s/lib/modules/%s/extra", but at present, perf will only look at them
when they are in "%s/lib/modules/%s/kernel". Lets encourage good
citizenship by relaxing this requirement to "%s/lib/modules/%s". This
way open source modules that are out-of-tree have no incentive to start
populating a directory reserved for in-kernle modules and I can stop hex
editing my system's perf binary when profiling OSS out-of-tree modules.

Signed-off-by: Richard Yao <ryao@gentoo.org>
Acked-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/53482425.3090608@gmail.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.8.3.1

