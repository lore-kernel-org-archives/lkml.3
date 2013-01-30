Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3A3OrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:47:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57839 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3A3OrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/21] perf header: Fix memory leak for the "Not caching a kptr_restrict'ed /proc/kallsyms" case
Date: Wed, 30 Jan 2013 11:47:01 -0300
Message-Id: <1359557222-17547-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

cppcheck reported:
[util/header.c:316]: (error) Memory leak: filename
[util/header.c:316]: (error) Memory leak: linkname

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/9377388.0eFDp53iW6@storm
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e17a8fe..7b24cf3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -313,7 +313,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (is_kallsyms) {
 		if (symbol_conf.kptr_restrict) {
 			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
-			return 0;
+			err = 0;
+			goto out_free;
 		}
 		realname = (char *) name;
 	} else
-- 
1.8.1.1.361.gec3ae6e

