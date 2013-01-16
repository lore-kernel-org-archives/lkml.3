Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3APAwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:52:53 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35858 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab3APAwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:52:51 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 02/17] mmzone: add various zone_*() helper functions.
Date: Tue, 15 Jan 2013 16:24:39 -0800
Message-Id: <1358295894-24167-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358295894-24167-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011600-5406-0000-0000-0000043D0B1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

Add zone_is_initialized(), zone_is_empty(), zone_spans_pfn(), and
zone_end_pfn().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 73b64a3..696cb7c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -543,6 +543,26 @@ static inline int zone_is_oom_locked(const struct zone *zone)
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
 }
 
+static inline unsigned zone_end_pfn(const struct zone *zone)
+{
+	return zone->zone_start_pfn + zone->spanned_pages;
+}
+
+static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
+{
+	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
+}
+
+static inline bool zone_is_initialized(struct zone *zone)
+{
+	return !!zone->wait_table;
+}
+
+static inline bool zone_is_empty(struct zone *zone)
+{
+	return zone->spanned_pages == 0;
+}
+
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
  * go. A value of 12 for DEF_PRIORITY implies that we will scan 1/4096th of the
-- 
1.8.0.3

