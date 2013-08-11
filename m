Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3HKCr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 22:47:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34511 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3HKCqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 22:46:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 08/28] x86, irq: Make dmar_msi/hpet_msi irq_chip name consistent
Date: Sat, 10 Aug 2013 19:45:19 -0700
Message-Id: <1376189139-31856-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376189139-31856-1-git-send-email-yinghai@kernel.org>
References: <1376189139-31856-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All others are using "-" instead of "_".

Change dmar_msi and hpet_msi to use "-".

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index cf320fb..47add1a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3199,7 +3199,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 }
 
 static struct irq_chip dmar_msi_type = {
-	.name			= "DMAR_MSI",
+	.name			= "DMAR-MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
 	.irq_ack		= ack_apic_edge,
@@ -3247,7 +3247,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 }
 
 struct irq_chip hpet_msi_type = {
-	.name = "HPET_MSI",
+	.name = "HPET-MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
 	.irq_ack = ack_apic_edge,
-- 
1.8.1.4

