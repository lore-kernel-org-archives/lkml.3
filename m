Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3JKFD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:03:26 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:58612
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3JKFDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:03:25 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, olaf@aepfle.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] x86: hyperv: Fix a compilation warning
Date: Thu, 10 Oct 2013 22:43:25 -0700
Message-Id: <1381470205-7296-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable hv_lapic_frequency is only used when CONFIG_X86_LOCAL_APIC
is defined. Make the necessary adjustment. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 628ff50..d7ff7b8 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -69,7 +69,6 @@ static struct clocksource hyperv_cs = {
 
 static void __init ms_hyperv_init_platform(void)
 {
-	u64	hv_lapic_frequency;
 
 	/*
 	 * Extract the features and hints
@@ -82,6 +81,7 @@ static void __init ms_hyperv_init_platform(void)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
+		u64	hv_lapic_frequency;
 		/*
 		 * Get the APIC frequency.
 		 */
-- 
1.7.4.1

