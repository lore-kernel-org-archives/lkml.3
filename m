Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbaFCSfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:35:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933984AbaFCSe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:34:58 -0400
Date: Tue, 3 Jun 2014 11:34:42 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2bf1a12340bda1bf621f27b9892094a51b1297fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-18-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-18-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do not auto-remove Children column if --fields given
Git-Commit-ID: 2bf1a12340bda1bf621f27b9892094a51b1297fd
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

Commit-ID:  2bf1a12340bda1bf621f27b9892094a51b1297fd
Gitweb:     http://git.kernel.org/tip/2bf1a12340bda1bf621f27b9892094a51b1297fd
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 20 Mar 2014 09:10:29 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:05 +0200

perf tools: Do not auto-remove Children column if --fields given

Depending on the configuration perf inserts/removes the Children
column in the output automatically.  But it might not be what user
wants if [s]he give --fields option explicitly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-18-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 8ca6387..498adb2 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -513,6 +513,9 @@ void perf_hpp__column_disable(unsigned col)
 
 void perf_hpp__cancel_cumulate(void)
 {
+	if (field_order)
+		return;
+
 	perf_hpp__column_disable(PERF_HPP__OVERHEAD_ACC);
 	perf_hpp__format[PERF_HPP__OVERHEAD].header = hpp__header_overhead;
 }
