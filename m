Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3LPP1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:27:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3LPP1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:38 -0500
Date: Mon, 16 Dec 2013 07:27:24 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-8d00be815c05ed0f0202f606bab4e54f98fd3b30@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1386736538-23525-1-git-send-email-dsahern@gmail.com>
References: <1386736538-23525-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix inverted error verification bug in thread__fork
Git-Commit-ID: 8d00be815c05ed0f0202f606bab4e54f98fd3b30
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:27:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d00be815c05ed0f0202f606bab4e54f98fd3b30
Gitweb:     http://git.kernel.org/tip/8d00be815c05ed0f0202f606bab4e54f98fd3b30
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 10 Dec 2013 21:35:38 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

perf tools: Fix inverted error verification bug in thread__fork

Commit 1902efe7f for the new comm infra added the wrong check for return
code on thread__set_comm. err == 0 is normal, so don't return at that
point unless err != 0.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1386736538-23525-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 49eaf1d..e394861 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -126,7 +126,7 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 		if (!comm)
 			return -ENOMEM;
 		err = thread__set_comm(thread, comm, timestamp);
-		if (!err)
+		if (err)
 			return err;
 		thread->comm_set = true;
 	}
