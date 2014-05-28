Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaE1A2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:28:48 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:40830 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaE1A23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:28:29 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Cody P Schafer <dev@codyps.com>
Subject: [PATCH 14/16] perf: add PMU_EVENT_ATTR_STRING() helper
Date: Tue, 27 May 2014 17:22:09 -0700
Message-Id: <1401236684-10579-15-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401236684-10579-1-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helper for constructing static struct perf_pmu_events_attr s.

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 include/linux/perf_event.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6c1d6dd..1313171 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -876,6 +876,13 @@ static struct perf_pmu_events_attr _var = {				\
 	.id   =  _id,							\
 };
 
+#define PMU_EVENT_ATTR_STRING(_name, _var, _value)			\
+static struct perf_pmu_events_attr _var = {				\
+	.attr = __ATTR(_name, 0444, perf_event_sysfs_show, NULL),	\
+	.event_str = _value,						\
+};
+
+
 #define PMU_FORMAT_ATTR(_name, _format)					\
 static ssize_t								\
 _name##_show(struct device *dev,					\
-- 
1.9.3

