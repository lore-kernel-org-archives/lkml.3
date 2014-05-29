Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaE2EAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:00:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53456 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298AbaE2D6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:38 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 17/27] perf tools: Do not auto-remove Children column if --fields given
Date: Thu, 29 May 2014 12:58:20 +0900
Message-Id: <1401335910-16832-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the configuration perf inserts/removes the Children
column in the output automatically.  But it might not be what user
wants if [s]he give --fields option explicitly.

Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 8ca638754acc..498adb23c02e 100644
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
-- 
1.9.2

