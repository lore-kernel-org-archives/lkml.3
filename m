Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaBTRpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:45:31 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:38619 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaBTRp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:45:28 -0500
Date: Thu, 20 Feb 2014 18:45:31 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, gleb@redhat.com
Subject: [PATCH] kvm/pmu: fix mapping of unhalted_reference_cycles event
Message-ID: <20140220174531.GA8811@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The pseudo encoding for unhalted_reference_cycles
is 0x0300. The KVM table was mapping it to 0x3000
This patch fixes this.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 5c4f631..db79c00 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -33,7 +33,7 @@ static struct kvm_arch_event_perf_mapping {
 	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
 	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
 	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	[7] = { 0x00, 0x30, PERF_COUNT_HW_REF_CPU_CYCLES },
+	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
 };
 
 /* mapping between fixed pmc index and arch_events array */
