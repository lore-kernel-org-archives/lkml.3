Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaE2UvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 16:51:09 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:47777 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaE2UvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 16:51:07 -0400
From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] perf/x86/uncore: Remove unnecessary assignment to "box" in uncore_pci_remove(...)
Date: Thu, 29 May 2014 21:51:03 +0100
Message-Id: <1401396663-23829-1-git-send-email-giedrius.rekasius@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <alpine.DEB.2.10.1405282239190.3952@nanos>
References: <alpine.DEB.2.10.1405282239190.3952@nanos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variable "box" gets assigned correct value when it is initialized.
There is no need to assign the same value again. Variable declarations
were reshuffled for better readability.

Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
---
Original patch was amended for better readability based on feedback from Walter
Harms and Thomas Gleixner.

 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 65bbbea..6fe20db 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3813,11 +3813,10 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 
 static void uncore_pci_remove(struct pci_dev *pdev)
 {
+	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
 	struct intel_uncore_box *box = pci_get_drvdata(pdev);
 	struct intel_uncore_pmu *pmu;
-	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
 
-	box = pci_get_drvdata(pdev);
 	if (!box) {
 		for (i = 0; i < UNCORE_EXTRA_PCI_DEV_MAX; i++) {
 			if (extra_pci_dev[phys_id][i] == pdev) {
-- 
1.9.3

