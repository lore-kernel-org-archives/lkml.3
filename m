Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3AaLEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:04:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36361 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3AaLEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:04:05 -0500
Date: Thu, 31 Jan 2013 03:03:48 -0800
From: tip-bot for Thomas Jarosch <thomas.jarosch@intra2net.com>
Message-ID: <tip-fdae6373910c10e27b8ae07e11e821b183d0bba5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, thomas.jarosch@intra2net.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, thomas.jarosch@intra2net.com, tglx@linutronix.de
In-Reply-To: <9377388.0eFDp53iW6@storm>
References: <9377388.0eFDp53iW6@storm>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Fix memory leak for the "
 Not caching a kptr_restrict'ed /proc/kallsyms" case
Git-Commit-ID: fdae6373910c10e27b8ae07e11e821b183d0bba5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:03:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fdae6373910c10e27b8ae07e11e821b183d0bba5
Gitweb:     http://git.kernel.org/tip/fdae6373910c10e27b8ae07e11e821b183d0bba5
Author:     Thomas Jarosch <thomas.jarosch@intra2net.com>
AuthorDate: Fri, 25 Jan 2013 11:21:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:40:18 -0300

perf header: Fix memory leak for the "Not caching a kptr_restrict'ed /proc/kallsyms" case

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
