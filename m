Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3EaIvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:51:09 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57949 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3EaIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:15 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 04/16] perf, persistent: Print error code on failure when adding events
Date: Fri, 31 May 2013 10:47:24 +0200
Message-Id: <1369990056-10310-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Improve error reporting.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 1e6c03a..6612eb77 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -123,15 +123,15 @@ int perf_add_persistent_event(struct perf_event_attr *attr, unsigned nr_pages)
 
 	for_each_possible_cpu(i) {
 		event = add_persistent_event_on_cpu(i, attr, nr_pages);
-		if (IS_ERR(event)) {
-			pr_err("%s: Error adding persistent event on cpu %d\n",
-				__func__, i);
+		if (IS_ERR(event))
 			goto unwind;
-		}
 	}
 	return 0;
 
 unwind:
+	pr_err("%s: Error adding persistent event on cpu %d: %ld\n",
+		__func__, i, PTR_ERR(event));
+
 	while (--i >= 0)
 		del_persistent_event(i, attr);
 
-- 
1.8.1.1

