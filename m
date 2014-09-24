Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaIXTa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:30:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58658 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbaIXT17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:27:59 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 05/10] perf: add PMU_EVENT_ATTR_STRING() helper
Date: Wed, 24 Sep 2014 12:27:19 -0700
Message-Id: <1411586844-21381-6-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092419-7182-0000-0000-0000008A51B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Helper for constructing static struct perf_pmu_events_attr s.

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index da442a0..4840c7f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -903,6 +903,13 @@ static struct perf_pmu_events_attr _var = {				\
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
1.8.3.1

