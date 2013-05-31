Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3EaIsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:48:30 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43928 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3EaIsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:17 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 05/16] perf, persistent: Return resonable error code
Date: Fri, 31 May 2013 10:47:25 +0200
Message-Id: <1369990056-10310-6-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Returning -ENODEV if no file descriptor is found. An error code of -1
(-EPERM) is misleading in this case.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 6612eb77..190aa75 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -165,7 +165,7 @@ int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
 		if (desc->attr->config == attr->config)
 			return __alloc_persistent_event_fd(desc);
 
-	return -1;
+	return -ENODEV;
 }
 
 
-- 
1.8.1.1

