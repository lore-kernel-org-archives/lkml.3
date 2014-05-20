Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaETJtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:49:14 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61013 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaETJtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:49:11 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org, dsahern@gmail.com,
        Michael Lentine <mlentine@google.com>
Subject: [PATCH v2 1/2] perf tools: add cat as fallback pager
Date: Tue, 20 May 2014 11:48:49 +0200
Message-Id: <1400579330-5043-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400579330-5043-1-git-send-email-eranian@google.com>
References: <1400579330-5043-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Lentine <mlentine@google.com>

This patch adds a fallback to cat for the pager. This is useful
on environmnents, such as Android, where less does not exist.
It is better to default to cat than to abort.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Michael Lentine <mlentine@google.com>
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
1.9.1.423.g4596e3a

