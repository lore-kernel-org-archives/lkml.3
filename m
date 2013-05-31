Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3EaLcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:32:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3EaLcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:32:06 -0400
Date: Fri, 31 May 2013 04:31:54 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-89365e6c9ad4c0e090e4c6a4b67a3ce319381d89@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1366848182-30449-1-git-send-email-andi@firstfloor.org>
References: <1366848182-30449-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Handle JITed code in shared memory
Git-Commit-ID: 89365e6c9ad4c0e090e4c6a4b67a3ce319381d89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89365e6c9ad4c0e090e4c6a4b67a3ce319381d89
Gitweb:     http://git.kernel.org/tip/89365e6c9ad4c0e090e4c6a4b67a3ce319381d89
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 24 Apr 2013 17:03:02 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:58 +0300

perf tools: Handle JITed code in shared memory

Need to check for /dev/zero.

Most likely more strings are missing too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1366848182-30449-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 6fcb9de..8bcdf9e 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -21,6 +21,7 @@ const char *map_type__name[MAP__NR_TYPES] = {
 static inline int is_anon_memory(const char *filename)
 {
 	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/dev/zero (deleted)") ||
 	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
