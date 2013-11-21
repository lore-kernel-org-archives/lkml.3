Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3KUOnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:43:08 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52974 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:43:04 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf diff: don't compute Delta if he->dummy
Date: Thu, 21 Nov 2013 20:03:44 +0530
Message-Id: <1385044427-13995-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2..79e0448 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -792,6 +792,9 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 
 	switch (idx) {
 	case PERF_HPP_DIFF__DELTA:
+		if (he->dummy)
+			break;
+
 		if (pair->diff.computed)
 			diff = pair->diff.period_ratio_delta;
 		else
-- 
1.8.5.rc0.5.g70ebc73.dirty

