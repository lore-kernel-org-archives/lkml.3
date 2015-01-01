Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbbAAPki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:40:38 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:59076 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbAAPkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:40:36 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: cris: arch-v32: mach-a3: arbiter.c:  Remove unused function
Date: Thu,  1 Jan 2015 16:43:36 +0100
Message-Id: <1420127016-28254-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function crisv32_arbiter_deallocate_bandwidth() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/cris/arch-v32/mach-a3/arbiter.c |   30 ------------------------------
 arch/cris/arch-v32/mach-fs/arbiter.c |   26 --------------------------
 2 files changed, 56 deletions(-)

diff --git a/arch/cris/arch-v32/mach-a3/arbiter.c b/arch/cris/arch-v32/mach-a3/arbiter.c
index ab5c421..89931a5 100644
--- a/arch/cris/arch-v32/mach-a3/arbiter.c
+++ b/arch/cris/arch-v32/mach-a3/arbiter.c
@@ -329,36 +329,6 @@ int crisv32_arbiter_allocate_bandwidth(int client, int region,
 	return 0;
 }
 
-/*
- * Main entry for bandwidth deallocation.
- *
- * Strictly speaking, for a somewhat constant set of clients where
- * each client gets a constant bandwidth and is just enabled or
- * disabled (somewhat dynamically), no action is necessary here to
- * avoid starvation for non-zero-allocation clients, as the allocated
- * slots will just be unused. However, handing out those unused slots
- * to active clients avoids needless latency if the "fixed scheme"
- * would give unclaimed slots to an eager low-index client.
- */
-
-void crisv32_arbiter_deallocate_bandwidth(int client, int region)
-{
-	int i;
-	int total_assigned = 0;
-	int arbiter = 0;
-
-	if (client & 0xffff0000)
-		arbiter = 1;
-
-	arbiters[arbiter].requested_slots[region][client] = 0;
-	arbiters[arbiter].active_clients[region][client] = 0;
-
-	for (i = 0; i < arbiters[arbiter].nbr_clients; i++)
-		total_assigned += arbiters[arbiter].requested_slots[region][i];
-
-	crisv32_arbiter_config(arbiter, region, NBR_OF_SLOTS - total_assigned);
-}
-
 int crisv32_arbiter_watch(unsigned long start, unsigned long size,
 			  unsigned long clients, unsigned long accesses,
 			  watch_callback *cb)
diff --git a/arch/cris/arch-v32/mach-fs/arbiter.c b/arch/cris/arch-v32/mach-fs/arbiter.c
index c97f4d8..79f7f25 100644
--- a/arch/cris/arch-v32/mach-fs/arbiter.c
+++ b/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -234,32 +234,6 @@ int crisv32_arbiter_allocate_bandwidth(int client, int region,
 	return 0;
 }
 
-/*
- * Main entry for bandwidth deallocation.
- *
- * Strictly speaking, for a somewhat constant set of clients where
- * each client gets a constant bandwidth and is just enabled or
- * disabled (somewhat dynamically), no action is necessary here to
- * avoid starvation for non-zero-allocation clients, as the allocated
- * slots will just be unused. However, handing out those unused slots
- * to active clients avoids needless latency if the "fixed scheme"
- * would give unclaimed slots to an eager low-index client.
- */
-
-void crisv32_arbiter_deallocate_bandwidth(int client, int region)
-{
-	int i;
-	int total_assigned = 0;
-
-	requested_slots[region][client] = 0;
-	active_clients[region][client] = 0;
-
-	for (i = 0; i < NBR_OF_CLIENTS; i++)
-		total_assigned += requested_slots[region][i];
-
-	crisv32_arbiter_config(region, NBR_OF_SLOTS - total_assigned);
-}
-
 int crisv32_arbiter_watch(unsigned long start, unsigned long size,
 			  unsigned long clients, unsigned long accesses,
 			  watch_callback *cb)
-- 
1.7.10.4

