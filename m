Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaJDQiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 12:38:13 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44457 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJDQiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 12:38:12 -0400
From: Yasser Shalabi <yassershalabi@gmail.com>
To: acme@kernel.org
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl, Yasser Shalabi <yassershalabi@gmail.com>
Subject: [PATCH] perf: fix for double free in tools/perf stat
Date: Sat,  4 Oct 2014 11:37:57 -0400
Message-Id: <1412437077-13109-1-git-send-email-yassershalabi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for double free bug in tools/perf due to dangling thread_map pointer in perf_evlist struct.
Code path excercised when perf stat -C switch is used but not set and is followed by another switch.
Example: perf stat -C -e. 
Signed-off-by: Yasser Shalabi <yassershalabi@gmail.com>

---
 tools/perf/util/evlist.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 814e954..09af633 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -845,6 +845,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 
 out_delete_threads:
 	thread_map__delete(evlist->threads);
+	evlist->threads = 0;
 	return -1;
 }
 
-- 
1.7.10.4

