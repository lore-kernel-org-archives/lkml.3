Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3AXSuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:50:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab3AXSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:50:49 -0500
Date: Thu, 24 Jan 2013 10:50:18 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-fa283ada1606e687641dc2b157d66ef0f9c9aa8a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1354110769-2998-5-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Remove displacement from struct hist_entry_diff
Git-Commit-ID: fa283ada1606e687641dc2b157d66ef0f9c9aa8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:50:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa283ada1606e687641dc2b157d66ef0f9c9aa8a
Gitweb:     http://git.kernel.org/tip/fa283ada1606e687641dc2b157d66ef0f9c9aa8a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 28 Nov 2012 14:52:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:06 -0300

perf diff: Remove displacement from struct hist_entry_diff

Removing displacement from struct hist_entry_diff, because it's not
used. Displacement is not used for sorting, so there's no reason to
pre-calculate it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1354110769-2998-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 91ae274..a1c0d56 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -55,9 +55,6 @@ struct he_stat {
 struct hist_entry_diff {
 	bool	computed;
 
-	/* PERF_HPP__DISPL */
-	int	displacement;
-
 	/* PERF_HPP__DELTA */
 	double	period_ratio_delta;
 
