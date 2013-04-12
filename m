Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3DLBLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:11:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48573 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3DLBLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:11:33 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] mm/vmstat: add note on safety of drain_zonestat
Date: Thu, 11 Apr 2013 18:10:58 -0700
Message-Id: <1365729058-29514-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-9360-0000-0000-000011B4F662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 mm/vmstat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index e1d8ed1..2b93877 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -495,6 +495,10 @@ void refresh_cpu_vm_stats(int cpu)
 			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
 
+/*
+ * this is only called if !populated_zone(zone), which implies no other users of
+ * pset->vm_stat_diff[] exsist.
+ */
 void drain_zonestat(struct zone *zone, struct per_cpu_pageset *pset)
 {
 	int i;
-- 
1.8.2.1

