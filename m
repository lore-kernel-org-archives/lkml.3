Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3KODie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 22:38:34 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:38567 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab3KODi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 22:38:26 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf script: Print callchains and symbols if they exist
Date: Thu, 14 Nov 2013 20:38:22 -0700
Message-Id: <1384486702-6736-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of perf-script is to dump the events and information
in the file. H/W, S/W and raw events all dump callchains if they
are present; might as well make that the default for tracepoints
too.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-script.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index baf17989a216..6f96f8414047 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -99,7 +99,9 @@ static struct {
 
 		.fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
 				  PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
-				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
+				  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE |
+			      PERF_OUTPUT_IP | PERF_OUTPUT_SYM |
+				  PERF_OUTPUT_DSO,
 	},
 
 	[PERF_TYPE_RAW] = {
-- 
1.8.3.4 (Apple Git-47)

