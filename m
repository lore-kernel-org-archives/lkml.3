Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaLJN2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:28:21 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:57463 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaLJN2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:28:20 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] perf kvm stat live: mark events as (x86 only) in help output
Date: Wed, 10 Dec 2014 14:28:10 +0100
Message-Id: <1418218090-20718-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121013-0021-0000-0000-000002166D40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

The mmio and ioport events are useful only on x86.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/builtin-kvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b65eb050..612e8f9 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1268,7 +1268,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		OPT_UINTEGER('d', "display", &kvm->display_time,
 			"time in seconds between display updates"),
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
-			"event for reporting: vmexit, mmio, ioport"),
+			"event for reporting: "
+			"vmexit, mmio (x86 only), ioport (x86 only)"),
 		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
 			"vcpu id to report"),
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
-- 
1.9.3

