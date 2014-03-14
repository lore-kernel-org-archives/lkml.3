Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaCNIlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:41:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbaCNIkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:40:25 -0400
Date: Fri, 14 Mar 2014 01:39:58 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-81827ed8d85e892311965dc9ec4120b2b2e745bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20140313120436.GA14236@quad>
References: <20140313120436.GA14236@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore: Fix missing end markers for SNB/
 IVB/HSW IMC PMU
Git-Commit-ID: 81827ed8d85e892311965dc9ec4120b2b2e745bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81827ed8d85e892311965dc9ec4120b2b2e745bd
Gitweb:     http://git.kernel.org/tip/81827ed8d85e892311965dc9ec4120b2b2e745bd
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 13 Mar 2014 13:04:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 14 Mar 2014 09:25:25 +0100

perf/x86/uncore: Fix missing end markers for SNB/IVB/HSW IMC PMU

This patch fixes a bug with the SNB/IVB/HSW uncore
mmeory controller support.

The PCI Ids tables for the memory controller were missing end
markers. That could cause random crashes on boot during or after
PCI device registration.

Signed-off-by: Stephane Erainan <eranian@google.com>
Cc: peterz@infradead.org
Cc: zheng.z.yan@intel.com
Cc: bp@alien8.de
Cc: ak@linux.intel.com
Link: http://lkml.kernel.org/r/20140313120436.GA14236@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
--
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index dfd50ea..618d502 100644
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
