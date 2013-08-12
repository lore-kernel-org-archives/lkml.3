Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3HLKYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:24:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48186 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3HLKYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:24:36 -0400
Date: Mon, 12 Aug 2013 03:23:42 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d50bf78ff69297d3f60aa778c272acc8e5f59a19@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, hch@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, hch@infradead.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1375766056-19377-2-git-send-email-namhyung@kernel.org>
References: <1375766056-19377-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk:
  Fix segmentation fault on perf_hpp__for_each_format loop
Git-Commit-ID: d50bf78ff69297d3f60aa778c272acc8e5f59a19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:23:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d50bf78ff69297d3f60aa778c272acc8e5f59a19
Gitweb:     http://git.kernel.org/tip/d50bf78ff69297d3f60aa778c272acc8e5f59a19
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 6 Aug 2013 14:14:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:39 -0300

perf ui/gtk: Fix segmentation fault on perf_hpp__for_each_format loop

The commit 2b8bfa6bb8a7 ("perf tools: Centralize default columns init in
perf_hpp__init") moves initialization of common overhead column to
perf_hpp__init() but forgot about the gtk code.

So the gtk code added the same column to the list twice causing infinite
loop when iterating it by perf_hpp__for_each_format loop.  When I run
perf report --gtk, I can see following messages indefinitely.

  (perf:11687): Gtk-CRITICAL **: IA__gtk_main_quit: assertion 'main_loops != NULL' failed
  perf: Segmentation fault

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1375766056-19377-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index cb2ed198..2ca66cc 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -109,8 +109,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
-
 	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
