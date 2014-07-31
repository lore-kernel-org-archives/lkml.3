Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaGaGxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:53:49 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41922 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbaGaGxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:43 -0400
Date: Wed, 30 Jul 2014 23:53:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [patch 6/9] x86, apic: Replace noop_check_apicid_used
In-Reply-To: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407302350450.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302346450.17503@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

noop_check_apicid_used() has the same implementation as 
default_check_apicid_used() in the standard header file, so replace the 
former with the latter.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/apic/apic_noop.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -89,11 +89,6 @@ static const struct cpumask *noop_target_cpus(void)
 	return cpumask_of(0);
 }
 
-static unsigned long noop_check_apicid_used(physid_mask_t *map, int apicid)
-{
-	return physid_isset(apicid, *map);
-}
-
 static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask,
 					  const struct cpumask *mask)
 {
@@ -128,7 +123,7 @@ struct apic apic_noop = {
 	.target_cpus			= noop_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= noop_check_apicid_used,
+	.check_apicid_used		= default_check_apicid_used,
 
 	.vector_allocation_domain	= noop_vector_allocation_domain,
 	.init_apic_ldr			= noop_init_apic_ldr,
