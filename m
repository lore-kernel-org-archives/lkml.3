Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaGaRIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:08:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaGaRIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:08:09 -0400
Date: Thu, 31 Jul 2014 10:07:56 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-e76661ba09353efd04e3435ac15bb9444f5cf1fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1407302351120.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302351120.17503@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Remove multi_timer_check callback
Git-Commit-ID: e76661ba09353efd04e3435ac15bb9444f5cf1fa
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

Commit-ID:  e76661ba09353efd04e3435ac15bb9444f5cf1fa
Gitweb:     http://git.kernel.org/tip/e76661ba09353efd04e3435ac15bb9444f5cf1fa
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 30 Jul 2014 23:53:43 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 31 Jul 2014 08:05:43 -0700

x86, apic: Remove multi_timer_check callback

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the multi_timer_check() apic callback has been obsolete.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1407302351120.17503@chino.kir.corp.google.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/apic.h           |  1 -
 arch/x86/kernel/apic/apic_flat_64.c   |  2 --
 arch/x86/kernel/apic/apic_noop.c      |  1 -
 arch/x86/kernel/apic/apic_numachip.c  |  1 -
 arch/x86/kernel/apic/bigsmp_32.c      |  1 -
 arch/x86/kernel/apic/io_apic.c        | 16 ----------------
 arch/x86/kernel/apic/probe_32.c       |  1 -
 arch/x86/kernel/apic/x2apic_cluster.c |  1 -
 arch/x86/kernel/apic/x2apic_phys.c    |  1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    |  1 -
 10 files changed, 26 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e1c0c2d..d8da5fc 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -300,7 +300,6 @@ struct apic {
 	void (*ioapic_phys_id_map)(physid_mask_t *phys_map, physid_mask_t *retmap);
 
 	void (*setup_apic_routing)(void);
-	int (*multi_timer_check)(int apic, int irq);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	void (*setup_portio_remap)(void);
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index a8ed9ac..f23b5e8 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -174,7 +174,6 @@ static struct apic apic_flat =  {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
@@ -285,7 +284,6 @@ static struct apic apic_physflat =  {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index c480dac..66a91e5 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -130,7 +130,6 @@ struct apic apic_noop = {
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index b49eb40..3d7f6b2 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -223,7 +223,6 @@ static const struct apic apic_numachip __refconst = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 163ad45..fa99280 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -169,7 +169,6 @@ static struct apic apic_bigsmp = {
 
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a44dce8..29290f5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3882,14 +3882,6 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
 	struct io_apic_irq_attr attr;
 
-	/*
-	 * Skip the timer IRQ if there's a quirk handler installed and if it
-	 * returns 1:
-	 */
-	if (apic->multi_timer_check &&
-	    apic->multi_timer_check(ioapic, virq))
-		return 0;
-
 	/* Get default attribute if not set by caller yet */
 	if (!info->set) {
 		u32 gsi = mp_pin_to_gsi(ioapic, hwirq);
@@ -3919,14 +3911,6 @@ void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq)
 	int ioapic = (int)(long)domain->host_data;
 	int pin = (int)data->hwirq;
 
-	/*
-	 * Skip the timer IRQ if there's a quirk handler installed and if it
-	 * returns 1:
-	 */
-	if (apic->multi_timer_check &&
-	    apic->multi_timer_check(ioapic, virq))
-		return;
-
 	ioapic_mask_entry(ioapic, pin);
 	__remove_pin_from_irq(cfg, ioapic, pin);
 	WARN_ON(cfg->irq_2_pin != NULL);
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 4d92ef8..a445842 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -94,7 +94,6 @@ static struct apic apic_default = {
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_flat_routing,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index d7bbe89..88eeaa9 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -255,7 +255,6 @@ static struct apic apic_x2apic_cluster = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index e23bec9..29614ae 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -109,7 +109,6 @@ static struct apic apic_x2apic_phys = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 633732f..5376012 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -371,7 +371,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
-	.multi_timer_check		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.setup_portio_remap		= NULL,
