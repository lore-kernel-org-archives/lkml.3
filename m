Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaLGUs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:48:26 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65529 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaLGUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:48:20 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Shuah Khan <shuahkh@osg.samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: testing: selftests: powerpc: pmu: ebb: ebb.c:  Remove unused function
Date: Sun,  7 Dec 2014 21:50:59 +0100
Message-Id: <1417985459-16501-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function event_bhrb_init() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/testing/selftests/powerpc/pmu/ebb/ebb.c |    5 -----
 tools/testing/selftests/powerpc/pmu/ebb/ebb.h |    1 -
 2 files changed, 6 deletions(-)

diff --git a/tools/testing/selftests/powerpc/pmu/ebb/ebb.c b/tools/testing/selftests/powerpc/pmu/ebb/ebb.c
index d7a72ce..75af212 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/ebb.c
+++ b/tools/testing/selftests/powerpc/pmu/ebb/ebb.c
@@ -324,11 +324,6 @@ void event_ebb_init(struct event *e)
 	e->attr.config |= (1ull << 63);
 }
 
-void event_bhrb_init(struct event *e, unsigned ifm)
-{
-	e->attr.config |= (1ull << 62) | ((u64)ifm << 60);
-}
-
 void event_leader_ebb_init(struct event *e)
 {
 	event_ebb_init(e);
diff --git a/tools/testing/selftests/powerpc/pmu/ebb/ebb.h b/tools/testing/selftests/powerpc/pmu/ebb/ebb.h
index e44eee5..a71596a 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/ebb.h
+++ b/tools/testing/selftests/powerpc/pmu/ebb/ebb.h
@@ -46,7 +46,6 @@ static inline void ebb_enable_pmc_counting(int pmc)
 bool ebb_check_count(int pmc, u64 sample_period, int fudge);
 void event_leader_ebb_init(struct event *e);
 void event_ebb_init(struct event *e);
-void event_bhrb_init(struct event *e, unsigned ifm);
 void setup_ebb_handler(void (*callee)(void));
 void standard_ebb_callee(void);
 int ebb_event_enable(struct event *e);
-- 
1.7.10.4

