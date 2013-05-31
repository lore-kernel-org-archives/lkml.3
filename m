Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3EaIwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:52:21 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:36513 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3EaIsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:11 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 02/16] perf, persistent: Fix attr size
Date: Fri, 31 May 2013 10:47:22 +0200
Message-Id: <1369990056-10310-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Fixing wrongly determined attribute size.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 5335644..9075164 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -149,7 +149,7 @@ int perf_add_persistent_event_by_id(int id)
 	attr->persistent	= 1;
 	attr->config		= id;
 	attr->type		= PERF_TYPE_TRACEPOINT;
-	attr->size		= sizeof(attr);
+	attr->size		= sizeof(*attr);
 
 	return perf_add_persistent_event(attr, 4);
 }
-- 
1.8.1.1

