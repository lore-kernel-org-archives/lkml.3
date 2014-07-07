Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaGGODW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:03:22 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51582 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaGGODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:03:21 -0400
Date: Mon, 7 Jul 2014 19:33:14 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] cpupowerutils: Correct use of ! and &
Message-ID: <20140707140314.GA4148@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit ae91d60ba88ef0bdb1b5e9b2363bd52fc45d2af7, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
This is not tested and clearly changes the semantics, so it is only
something to consider.
 tools/power/cpupower/utils/idle_monitor/mperf_monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
index 5650ab5..90a8c4f 100644
--- a/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
+++ b/tools/power/cpupower/utils/idle_monitor/mperf_monitor.c
@@ -237,7 +237,7 @@ static int init_maxfreq_mode(void)
 	unsigned long long hwcr;
 	unsigned long min;
 
-	if (!cpupower_cpu_info.caps & CPUPOWER_CAP_INV_TSC)
+	if (!(cpupower_cpu_info.caps & CPUPOWER_CAP_INV_TSC))
 		goto use_sysfs;
 
 	if (cpupower_cpu_info.vendor == X86_VENDOR_AMD) {
-- 
1.9.1

