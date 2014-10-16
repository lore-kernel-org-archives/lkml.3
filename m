Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaJPFXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:23:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33511 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaJPFXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:23:42 -0400
Date: Wed, 15 Oct 2014 22:23:22 -0700
From: tip-bot for Yasser Shalabi <tipbot@zytor.com>
Message-ID: <tip-b2e19a934a36b2b4affcde9c170c0f01afabe50a@git.kernel.org>
Cc: mingo@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        yassershalabi@gmail.com, paulus@samba.org, mingo@kernel.org,
        hpa@zytor.com, acme@redhat.com
Reply-To: hpa@zytor.com, acme@redhat.com, paulus@samba.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, yassershalabi@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        tglx@linutronix.de
In-Reply-To: <1412437077-13109-1-git-send-email-yassershalabi@gmail.com>
References: <1412437077-13109-1-git-send-email-yassershalabi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Fix for double free in tools/
 perf stat
Git-Commit-ID: b2e19a934a36b2b4affcde9c170c0f01afabe50a
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

Commit-ID:  b2e19a934a36b2b4affcde9c170c0f01afabe50a
Gitweb:     http://git.kernel.org/tip/b2e19a934a36b2b4affcde9c170c0f01afabe50a
Author:     Yasser Shalabi <yassershalabi@gmail.com>
AuthorDate: Sat, 4 Oct 2014 11:37:57 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 16:16:53 -0300

perf evlist: Fix for double free in tools/perf stat

Fix for double free bug in tools/perf due to dangling thread_map pointer
in perf_evlist struct.

Code path excercised when perf stat -C switch is used but not set and is
followed by another switch.

Example:

  perf stat -C -e.

Signed-off-by: Yasser Shalabi <yassershalabi@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412437077-13109-1-git-send-email-yassershalabi@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b4b54d8..3c9e77d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1003,6 +1003,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 
 out_delete_threads:
 	thread_map__delete(evlist->threads);
+	evlist->threads = NULL;
 	return -1;
 }
 
