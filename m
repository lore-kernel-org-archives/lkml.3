Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaGaRH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:07:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaGaRHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:07:54 -0400
Date: Thu, 31 Jul 2014 10:07:43 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-4c59f3e63d5a0673af8abbce64467a6b497c94d2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1407302350450.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302350450.17503@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Replace noop_check_apicid_used
Git-Commit-ID: 4c59f3e63d5a0673af8abbce64467a6b497c94d2
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

Commit-ID:  4c59f3e63d5a0673af8abbce64467a6b497c94d2
Gitweb:     http://git.kernel.org/tip/4c59f3e63d5a0673af8abbce64467a6b497c94d2
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 30 Jul 2014 23:53:40 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 31 Jul 2014 08:05:43 -0700

x86, apic: Replace noop_check_apicid_used

noop_check_apicid_used() has the same implementation as
default_check_apicid_used() in the standard header file, so replace the
former with the latter.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1407302350450.17503@chino.kir.corp.google.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/apic_noop.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 8c165d9..c480dac 100644
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
