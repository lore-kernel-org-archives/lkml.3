Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaKTHi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:38:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbaKTHiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:38:22 -0500
Date: Wed, 19 Nov 2014 23:38:11 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-5550171b2a9f8df26ff483051d060db06376b26d@git.kernel.org>
Cc: mingo@kernel.org, jolsa@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@redhat.com,
        hpa@zytor.com
Reply-To: mingo@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@redhat.com, hpa@zytor.com
In-Reply-To: <1415844328-4884-4-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain: Use al.addr to set up call chain
Git-Commit-ID: 5550171b2a9f8df26ff483051d060db06376b26d
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

Commit-ID:  5550171b2a9f8df26ff483051d060db06376b26d
Gitweb:     http://git.kernel.org/tip/5550171b2a9f8df26ff483051d060db06376b26d
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 12 Nov 2014 18:05:21 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:47 -0300

perf callchain: Use al.addr to set up call chain

Use the relative address, this makes get_srcline work correctly in the
end.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-4-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 84390ee..d97309c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1406,7 +1406,7 @@ static int add_callchain_ip(struct thread *thread,
 		}
 	}
 
-	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
+	return callchain_cursor_append(&callchain_cursor, al.addr, al.map, al.sym);
 }
 
 struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
