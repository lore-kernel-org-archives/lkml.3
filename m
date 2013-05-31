Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3EaIuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:50:14 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39217 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3EaIs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:29 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 12/16] perf, persistent: Avoid adding identical events
Date: Fri, 31 May 2013 10:47:32 +0200
Message-Id: <1369990056-10310-13-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Check if an event already exists before adding it.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index ebef089..1e93b51 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -40,6 +40,12 @@ add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
 
 	mutex_lock(&per_cpu(pers_events_lock, cpu));
 
+	desc = get_persistent_event(cpu, attr);
+	if (desc) {
+		event = ERR_PTR(-EEXIST);
+		goto out;
+	}
+
 	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
 	if (!desc) {
 		event = ERR_PTR(-ENOMEM);
-- 
1.8.1.1

