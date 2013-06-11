Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3FKQpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:45:11 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58783 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab3FKQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:43:07 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v2 10/14] perf, persistent: Avoid adding identical events
Date: Tue, 11 Jun 2013 18:42:36 +0200
Message-Id: <1370968960-22527-11-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Check if an event already exists before adding it.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/persistent.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 586cea5..4fcd071 100644
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

