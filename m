Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab3IHDUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56018 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754669Ab3IHDSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Ingo Molnar" <mingo@kernel.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.266251945@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [071/121] perf/arm: Fix armpmu_map_hw_event()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit b88a2595b6d8aedbd275c07dfa784657b4f757eb upstream.

Fix constraint check in armpmu_map_hw_event().

Reported-and-tested-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/perf_event.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -116,7 +116,12 @@ armpmu_map_cache_event(const unsigned (*
 static int
 armpmu_map_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
 {
-	int mapping = (*event_map)[config];
+	int mapping;
+
+	if (config >= PERF_COUNT_HW_MAX)
+		return -ENOENT;
+
+	mapping = (*event_map)[config];
 	return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
 }
 

