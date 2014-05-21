Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaEUNNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaEUNNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:23 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michael Lentine <mlentine@google.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 21/22] perf tools: Add cat as fallback pager
Date: Wed, 21 May 2014 15:12:43 +0200
Message-Id: <1400677964-25160-22-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Lentine <mlentine@google.com>

This patch adds a fallback to cat for the pager. This is useful
on environments, such as Android, where less does not exist.
It is better to default to cat than to abort.

Signed-off-by: Michael Lentine <mlentine@google.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1400579330-5043-2-git-send-email-eranian@google.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/pager.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 3322b84..31ee02d 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -57,13 +57,13 @@ void setup_pager(void)
 	}
 	if (!pager)
 		pager = getenv("PAGER");
-	if (!pager) {
-		if (!access("/usr/bin/pager", X_OK))
-			pager = "/usr/bin/pager";
-	}
+	if (!(pager || access("/usr/bin/pager", X_OK)))
+		pager = "/usr/bin/pager";
+	if (!(pager || access("/usr/bin/less", X_OK)))
+		pager = "/usr/bin/less";
 	if (!pager)
-		pager = "less";
-	else if (!*pager || !strcmp(pager, "cat"))
+		pager = "cat";
+	if (!*pager || !strcmp(pager, "cat"))
 		return;
 
 	spawned_pager = 1; /* means we are emitting to terminal */
-- 
1.8.3.1

