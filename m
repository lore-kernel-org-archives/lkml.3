Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbaFYFvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:51:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaFYFvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:51:48 -0400
Date: Tue, 24 Jun 2014 22:51:28 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-b094c99e8e284cff839400a3b61fda1fa53962fc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1402942467-10671-5-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-5-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench sched-messaging: Plug memleak
Git-Commit-ID: b094c99e8e284cff839400a3b61fda1fa53962fc
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

Commit-ID:  b094c99e8e284cff839400a3b61fda1fa53962fc
Gitweb:     http://git.kernel.org/tip/b094c99e8e284cff839400a3b61fda1fa53962fc
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Mon, 16 Jun 2014 11:14:22 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Jun 2014 16:13:15 -0300

perf bench sched-messaging: Plug memleak

Explicitly free the thread array ('pth_tab').

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/1402942467-10671-5-git-send-email-davidlohr@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/sched-messaging.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index cc1190a..fc4fe91 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -332,5 +332,7 @@ int bench_sched_messaging(int argc, const char **argv,
 		break;
 	}
 
+	free(pth_tab);
+
 	return 0;
 }
