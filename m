Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbbA0Bni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:43:38 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53360 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbbA0Bnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:43:33 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 2/7] perf: add PMU_EVENT_ATTR_STRING() helper
Date: Mon, 26 Jan 2015 17:43:05 -0800
Message-Id: <1422322990-9030-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012701-0029-0000-0000-000001CF70C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Helper for constructing static struct perf_pmu_events_attr s.

Changelog[v7]:
	[Jiri Olsa] Initialize 'id' field in perf_pmu_events_attr also.

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/perf_event.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 58f59bd..1d36314 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -906,6 +906,13 @@ static struct perf_pmu_events_attr _var = {				\
 	.id   =  _id,							\
 };
 
+#define PMU_EVENT_ATTR_STRING(_name, _var, _str)			    \
+static struct perf_pmu_events_attr _var = {				    \
+	.attr		= __ATTR(_name, 0444, perf_event_sysfs_show, NULL), \
+	.id		= 0,						    \
+	.event_str	= _str,						    \
+};
+
 #define PMU_FORMAT_ATTR(_name, _format)					\
 static ssize_t								\
 _name##_show(struct device *dev,					\
-- 
1.8.3.1

