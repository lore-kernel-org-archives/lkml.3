Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3AQW4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:56:46 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38029 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3AQWyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:15 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 3/9] mm: add zone_is_empty() and zone_is_initialized()
Date: Thu, 17 Jan 2013 14:52:55 -0800
Message-Id: <1358463181-17956-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011722-7182-0000-0000-00000487B128
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factoring out these 2 checks makes it more clear what we are actually
checking for.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d91d964..696cb7c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -553,6 +553,16 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
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

