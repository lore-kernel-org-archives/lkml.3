Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaE1JLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:11:49 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53302 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaE1JLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:11:47 -0400
From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] perf/x86/uncore: Remove unnecessary assignment to "box" in uncore_pci_remove(...)
Date: Wed, 28 May 2014 10:11:34 +0100
Message-Id: <1401268294-28634-1-git-send-email-giedrius.rekasius@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variable "box" gets assigned correct value when it is initialized.
There is no need to assign the same value again.

Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 65bbbea..8cbbb1b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3817,7 +3817,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 	struct intel_uncore_pmu *pmu;
 	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
 
-	box = pci_get_drvdata(pdev);
 	if (!box) {
 		for (i = 0; i < UNCORE_EXTRA_PCI_DEV_MAX; i++) {
 			if (extra_pci_dev[phys_id][i] == pdev) {
-- 
1.9.3

