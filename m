Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3H0BN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:13:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3H0BHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 46/74] arm64: perf: fix event validation for software group leaders
Date: Mon, 26 Aug 2013 18:08:44 -0700
Message-Id: <20130827010434.246237578@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit ee7538a008a45050c8f706d38b600f55953169f9 upstream.

This is a port of c95eb3184ea1 ("ARM: 7809/1: perf: fix event validation
for software group leaders") to arm64, which fixes a panic in the arm64
perf backend found as a result of Vince's fuzzing tool.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/perf_event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -322,6 +322,9 @@ validate_event(struct pmu_hw_events *hw_
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
 		return 1;
 


