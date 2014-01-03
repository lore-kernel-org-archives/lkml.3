Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaACAHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:07:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21887 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaACAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:34 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v5 08/33] x86, irq: Make dmar_msi/hpet_msi irq_chip name consistent
Date: Thu,  2 Jan 2014 16:05:40 -0800
Message-Id: <1388707565-16535-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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
index c52085c..241325c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3204,7 +3204,7 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 }
 
 static struct irq_chip dmar_msi_type = {
-	.name			= "DMAR_MSI",
+	.name			= "DMAR-MSI",
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
 	.irq_ack		= ack_apic_edge,
@@ -3252,7 +3252,7 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 }
 
 struct irq_chip hpet_msi_type = {
-	.name = "HPET_MSI",
+	.name = "HPET-MSI",
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
 	.irq_ack = ack_apic_edge,
-- 
1.8.4

