Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3EFJH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:07:29 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45216 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3EFJH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:07:28 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, benh@kernel.crashing.org,
        khandual@linux.vnet.ibm.com
Subject: [PATCH] powerpc, perf: Fix processing conditions for invalid BHRB entries
Date: Mon,  6 May 2013 14:36:46 +0530
Message-Id: <1367831206-16331-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050609-9574-0000-0000-000007BB585C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some conditions during BHRB entry processing.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/core-book3s.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 09db68d..1de2756 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1481,25 +1481,25 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 			target = val & BHRB_TARGET;
 
 			/* Probable Missed entry: Not applicable for POWER8 */
-			if ((addr == 0) && (target == 0) && (pred == 1)) {
+			if ((addr == 0) && (!target) && pred) {
 				r_index++;
 				continue;
 			}
 
 			/* Real Missed entry: Power8 based missed entry */
-			if ((addr == 0) && (target == 1) && (pred == 1)) {
+			if ((addr == 0) && target && pred) {
 				r_index++;
 				continue;
 			}
 
 			/* Reserved condition: Not a valid entry  */
-			if ((addr == 0) && (target == 1) && (pred == 0)) {
+			if ((addr == 0) && target && (!pred)) {
 				r_index++;
 				continue;
 			}
 
 			/* Is a target address */
-			if (val & BHRB_TARGET) {
+			if (target) {
 				/* First address cannot be a target address */
 				if (r_index == 0) {
 					r_index++;
-- 
1.7.11.7

