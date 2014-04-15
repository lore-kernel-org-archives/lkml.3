Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaDORa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:30:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDORa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:30:56 -0400
Date: Tue, 15 Apr 2014 10:30:30 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-ae450a7d054cd1fe8d003a085858ca5b90cc74d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <53465E3E.8070201@intel.com>
References: <53465E3E.8070201@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix double free in perf test 21 (
 code-reading.c)
Git-Commit-ID: ae450a7d054cd1fe8d003a085858ca5b90cc74d9
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

Commit-ID:  ae450a7d054cd1fe8d003a085858ca5b90cc74d9
Gitweb:     http://git.kernel.org/tip/ae450a7d054cd1fe8d003a085858ca5b90cc74d9
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 10 Apr 2014 12:02:54 +0300
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Tue, 15 Apr 2014 13:57:14 +0200

perf tools: Fix double free in perf test 21 (code-reading.c)

perf_evlist__delete() deletes attached cpu and thread maps
but the test is still using them, so remove them from the
evlist before deleting it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/53465E3E.8070201@intel.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/tests/code-reading.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 653a8fe..bfb1869 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -504,6 +504,7 @@ static int do_test_code_reading(bool try_kcore)
 		if (ret < 0) {
 			if (!excl_kernel) {
 				excl_kernel = true;
+				perf_evlist__set_maps(evlist, NULL, NULL);
 				perf_evlist__delete(evlist);
 				evlist = NULL;
 				continue;
