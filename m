Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3AYLT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:19:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3AYLTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:19:25 -0500
Date: Fri, 25 Jan 2013 03:19:02 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-49e4ba54592435cbd150aea8f5ae6b776fc687f9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        mingo@redhat.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1356030701-16284-8-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-8-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kmem:
  use ARRAY_SIZE instead of reinventing it
Git-Commit-ID: 49e4ba54592435cbd150aea8f5ae6b776fc687f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:19:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49e4ba54592435cbd150aea8f5ae6b776fc687f9
Gitweb:     http://git.kernel.org/tip/49e4ba54592435cbd150aea8f5ae6b776fc687f9
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:16 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:15 -0300

perf kmem: use ARRAY_SIZE instead of reinventing it

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1356030701-16284-8-git-send-email-sasha.levin@oracle.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 9fddca7..c746108 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -609,8 +609,7 @@ static struct sort_dimension *avail_sorts[] = {
 	&pingpong_sort_dimension,
 };
 
-#define NUM_AVAIL_SORTS	\
-	(int)(sizeof(avail_sorts) / sizeof(struct sort_dimension *))
+#define NUM_AVAIL_SORTS	((int)ARRAY_SIZE(avail_sorts))
 
 static int sort_dimension__add(const char *tok, struct list_head *list)
 {
