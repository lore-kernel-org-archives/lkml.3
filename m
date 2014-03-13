Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaCMMDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:03:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34805 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaCMMDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:03:49 -0400
Date: Thu, 13 Mar 2014 13:04:36 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, zheng.z.yan@intel.com, bp@alien8.de,
        ak@linux.intel.com
Subject: [PATCH] perf/x86/uncore: fix missing end markers for SNB/IVB/HSW IMC
 PMU
Message-ID: <20140313120436.GA14236@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a bug with the SNB/IVB/HSW uncore
mmeory controller support.

The PCI Ids tables for the memory controller were missing end markers.
That could cause random crashes on boot during or after PCI device
registration.

Signed-off-by: Stephane Erainan <eranian@google.com>
--
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index f509ab1..bd2253d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1989,6 +1989,7 @@ static DEFINE_PCI_DEVICE_TABLE(snb_uncore_pci_ids) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SNB_IMC),
 		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
 	},
+	{ /* end: all zeroes */ },
 };
 
 static DEFINE_PCI_DEVICE_TABLE(ivb_uncore_pci_ids) = {
@@ -1996,6 +1997,7 @@ static DEFINE_PCI_DEVICE_TABLE(ivb_uncore_pci_ids) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_IMC),
 		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
 	},
+	{ /* end: all zeroes */ },
 };
 
 static DEFINE_PCI_DEVICE_TABLE(hsw_uncore_pci_ids) = {
@@ -2003,6 +2005,7 @@ static DEFINE_PCI_DEVICE_TABLE(hsw_uncore_pci_ids) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_HSW_IMC),
 		.driver_data = UNCORE_PCI_DEV_DATA(SNB_PCI_UNCORE_IMC, 0),
 	},
+	{ /* end: all zeroes */ },
 };
 
 static struct pci_driver snb_uncore_pci_driver = {
