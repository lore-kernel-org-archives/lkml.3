Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3GGUnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 16:43:35 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45374 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3GGUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 16:43:32 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf: Free memory allocated in parse_events_fixup
Date: Sun,  7 Jul 2013 14:43:27 -0600
Message-Id: <1373229807-6118-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

578d9c6 added a memory allocation that is not freed. Do that when
the scanner is done.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2c460ed..707368f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -846,7 +846,9 @@ static int parse_events_fixup(int ret, const char *str, void *data,
 	free(o);
 	if (!s)
 		return -ENOMEM;
-	return parse_events__scanner(s, data, start_token);
+	ret = parse_events__scanner(s, data, start_token);
+	free(s);
+	return ret;
 }
 
 static int parse_events__scanner(const char *str, void *data, int start_token)
-- 
1.7.10.1

