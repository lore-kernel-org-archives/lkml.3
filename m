Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab3DHQ34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:29:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934779Ab3DHQ3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:29:53 -0400
Date: Mon, 8 Apr 2013 08:29:24 -0700
From: tip-bot for Chen Gang <tipbot@zytor.com>
Message-ID: <tip-c97847d2f0eb77c806e650e04d9bbcf79fa05730@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        gang.chen@asianux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, gang.chen@asianux.com, tglx@linutronix.de
In-Reply-To: <51623E0B.7070101@asianux.com>
References: <51623E0B.7070101@asianux.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix strncpy() use, always make sure it'
 s NUL terminated
Git-Commit-ID: c97847d2f0eb77c806e650e04d9bbcf79fa05730
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 08:29:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c97847d2f0eb77c806e650e04d9bbcf79fa05730
Gitweb:     http://git.kernel.org/tip/c97847d2f0eb77c806e650e04d9bbcf79fa05730
Author:     Chen Gang <gang.chen@asianux.com>
AuthorDate: Mon, 8 Apr 2013 11:48:27 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 13:26:55 +0200

perf: Fix strncpy() use, always make sure it's NUL terminated

For NUL terminated string, always make sure that there's '\0' at the end.

In our case we need a return value, so still use strncpy() and
fix up the tail explicitly.

(strlcpy() returns the size, not the pointer)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: a.p.zijlstra@chello.nl <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org <paulus@samba.org>
Cc: acme@ghostprotocols.net <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/51623E0B.7070101@asianux.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 59412d0..7f0d67e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4737,7 +4737,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	} else {
 		if (arch_vma_name(mmap_event->vma)) {
 			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
-				       sizeof(tmp));
+				       sizeof(tmp) - 1);
+			tmp[sizeof(tmp) - 1] = '\0';
 			goto got_name;
 		}
 
