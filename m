Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab3ICQ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:26:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46487 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3ICQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:26:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 47/58] arm64: perf: fix event validation for software group leaders
Date: Tue,  3 Sep 2013 09:23:51 -0700
Message-Id: <1378225442-20654-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit ee7538a008a45050c8f706d38b600f55953169f9 upstream.

This is a port of c95eb3184ea1 ("ARM: 7809/1: perf: fix event validation
for software group leaders") to arm64, which fixes a panic in the arm64
perf backend found as a result of Vince's fuzzing tool.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/perf_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 8a724a1..34e1bca 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -322,6 +322,9 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
 		return 1;
 
-- 
1.8.1.2

