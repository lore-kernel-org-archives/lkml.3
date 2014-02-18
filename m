Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaBRQZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:25:40 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62379 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbaBRQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:25:35 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>, Joe Perches <joe@perches.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v5 5/5] ACPI: Replace printk with pr_* in tables.c
Date: Wed, 19 Feb 2014 00:23:58 +0800
Message-Id: <1392740638-2479-6-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org>
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just do some clean up to replace printk with pr_*,
no functional change.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/tables.c |  124 +++++++++++++++++++++----------------------------
 1 file changed, 54 insertions(+), 70 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 5837f85..fd95a76 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -55,10 +55,9 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_local_apic *p =
 			    (struct acpi_madt_local_apic *)header;
-			printk(KERN_INFO PREFIX
-			       "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
-			       p->processor_id, p->id,
-			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
+			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
+				p->processor_id, p->id,
+				(p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
 		}
 		break;
 
@@ -66,11 +65,9 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_local_x2apic *p =
 			    (struct acpi_madt_local_x2apic *)header;
-			printk(KERN_INFO PREFIX
-			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
-			       p->local_apic_id, p->uid,
-			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
-			       "enabled" : "disabled");
+			pr_info(PREFIX "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
+				p->local_apic_id, p->uid,
+				(p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
 		}
 		break;
 
@@ -78,9 +75,8 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_io_apic *p =
 			    (struct acpi_madt_io_apic *)header;
-			printk(KERN_INFO PREFIX
-			       "IOAPIC (id[0x%02x] address[0x%08x] gsi_base[%d])\n",
-			       p->id, p->address, p->global_irq_base);
+			pr_info(PREFIX "IOAPIC (id[0x%02x] address[0x%08x] gsi_base[%d])\n",
+				p->id, p->address, p->global_irq_base);
 		}
 		break;
 
@@ -88,18 +84,15 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_interrupt_override *p =
 			    (struct acpi_madt_interrupt_override *)header;
-			printk(KERN_INFO PREFIX
-			       "INT_SRC_OVR (bus %d bus_irq %d global_irq %d %s %s)\n",
-			       p->bus, p->source_irq, p->global_irq,
-			       mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK],
-			       mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2]);
+			pr_info(PREFIX "INT_SRC_OVR (bus %d bus_irq %d global_irq %d %s %s)\n",
+				p->bus, p->source_irq, p->global_irq,
+				mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK],
+				mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2]);
 			if (p->inti_flags  &
 			    ~(ACPI_MADT_POLARITY_MASK | ACPI_MADT_TRIGGER_MASK))
-				printk(KERN_INFO PREFIX
-				       "INT_SRC_OVR unexpected reserved flags: 0x%x\n",
-				       p->inti_flags  &
+				pr_info(PREFIX "INT_SRC_OVR unexpected reserved flags: 0x%x\n",
+					p->inti_flags  &
 					~(ACPI_MADT_POLARITY_MASK | ACPI_MADT_TRIGGER_MASK));
-
 		}
 		break;
 
@@ -107,11 +100,10 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_nmi_source *p =
 			    (struct acpi_madt_nmi_source *)header;
-			printk(KERN_INFO PREFIX
-			       "NMI_SRC (%s %s global_irq %d)\n",
-			       mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK],
-			       mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2],
-			       p->global_irq);
+			pr_info(PREFIX "NMI_SRC (%s %s global_irq %d)\n",
+				mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK],
+				mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2],
+				p->global_irq);
 		}
 		break;
 
@@ -119,12 +111,11 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_local_apic_nmi *p =
 			    (struct acpi_madt_local_apic_nmi *)header;
-			printk(KERN_INFO PREFIX
-			       "LAPIC_NMI (acpi_id[0x%02x] %s %s lint[0x%x])\n",
-			       p->processor_id,
-			       mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK	],
-			       mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2],
-			       p->lint);
+			pr_info(PREFIX "LAPIC_NMI (acpi_id[0x%02x] %s %s lint[0x%x])\n",
+				p->processor_id,
+				mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK	],
+				mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2],
+				p->lint);
 		}
 		break;
 
@@ -137,12 +128,11 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 			polarity = p->inti_flags & ACPI_MADT_POLARITY_MASK;
 			trigger = (p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2;
 
-			printk(KERN_INFO PREFIX
-			       "X2APIC_NMI (uid[0x%02x] %s %s lint[0x%x])\n",
-			       p->uid,
-			       mps_inti_flags_polarity[polarity],
-			       mps_inti_flags_trigger[trigger],
-			       p->lint);
+			pr_info(PREFIX "X2APIC_NMI (uid[0x%02x] %s %s lint[0x%x])\n",
+				p->uid,
+				mps_inti_flags_polarity[polarity],
+				mps_inti_flags_trigger[trigger],
+				p->lint);
 		}
 		break;
 
@@ -150,9 +140,8 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_local_apic_override *p =
 			    (struct acpi_madt_local_apic_override *)header;
-			printk(KERN_INFO PREFIX
-			       "LAPIC_ADDR_OVR (address[%p])\n",
-			       (void *)(unsigned long)p->address);
+			pr_info(PREFIX "LAPIC_ADDR_OVR (address[%p])\n",
+				(void *)(unsigned long)p->address);
 		}
 		break;
 
@@ -160,10 +149,9 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_io_sapic *p =
 			    (struct acpi_madt_io_sapic *)header;
-			printk(KERN_INFO PREFIX
-			       "IOSAPIC (id[0x%x] address[%p] gsi_base[%d])\n",
-			       p->id, (void *)(unsigned long)p->address,
-			       p->global_irq_base);
+			pr_info(PREFIX "IOSAPIC (id[0x%x] address[%p] gsi_base[%d])\n",
+				p->id, (void *)(unsigned long)p->address,
+				p->global_irq_base);
 		}
 		break;
 
@@ -171,10 +159,10 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_local_sapic *p =
 			    (struct acpi_madt_local_sapic *)header;
-			printk(KERN_INFO PREFIX
-			       "LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
-			       p->processor_id, p->id, p->eid,
-			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
+			pr_info(PREFIX
+				"LSAPIC (acpi_id[0x%02x] lsapic_id[0x%02x] lsapic_eid[0x%02x] %s)\n",
+				p->processor_id, p->id, p->eid,
+				(p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
 		}
 		break;
 
@@ -182,19 +170,18 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		{
 			struct acpi_madt_interrupt_source *p =
 			    (struct acpi_madt_interrupt_source *)header;
-			printk(KERN_INFO PREFIX
-			       "PLAT_INT_SRC (%s %s type[0x%x] id[0x%04x] eid[0x%x] iosapic_vector[0x%x] global_irq[0x%x]\n",
-			       mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK],
-			       mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2],
-			       p->type, p->id, p->eid, p->io_sapic_vector,
-			       p->global_irq);
+			pr_info(PREFIX
+				"PLAT_INT_SRC (%s %s type[0x%x] id[0x%04x] eid[0x%x] iosapic_vector[0x%x] global_irq[0x%x]\n",
+				mps_inti_flags_polarity[p->inti_flags & ACPI_MADT_POLARITY_MASK],
+				mps_inti_flags_trigger[(p->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2],
+				p->type, p->id, p->eid, p->io_sapic_vector,
+				p->global_irq);
 		}
 		break;
 
 	default:
-		printk(KERN_WARNING PREFIX
-		       "Found unsupported MADT entry (type = 0x%x)\n",
-		       header->type);
+		pr_warn(PREFIX "Found unsupported MADT entry (type = 0x%x)\n",
+			header->type);
 		break;
 	}
 }
@@ -225,7 +212,7 @@ acpi_table_parse_entries(char *id,
 		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
 
 	if (!table_header) {
-		printk(KERN_WARNING PREFIX "%4.4s not present\n", id);
+		pr_warn(PREFIX "%4.4s not present\n", id);
 		return -ENODEV;
 	}
 
@@ -256,8 +243,8 @@ acpi_table_parse_entries(char *id,
 		    ((unsigned long)entry + entry->length);
 	}
 	if (max_entries && count > max_entries) {
-		printk(KERN_WARNING PREFIX "[%4.4s:0x%02x] ignored %i entries of "
-		       "%i found\n", id, entry_id, count - max_entries, count);
+		pr_warn(PREFIX "[%4.4s:0x%02x] ignored %i entries of %i found\n",
+			id, entry_id, count - max_entries, count);
 	}
 
 	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
@@ -322,13 +309,11 @@ static void __init check_multiple_madt(void)
 
 	acpi_get_table_with_size(ACPI_SIG_MADT, 2, &table, &tbl_size);
 	if (table) {
-		printk(KERN_WARNING PREFIX
-		       "BIOS bug: multiple APIC/MADT found,"
-		       " using %d\n", acpi_apic_instance);
-		printk(KERN_WARNING PREFIX
-		       "If \"acpi_apic_instance=%d\" works better, "
-		       "notify linux-acpi@vger.kernel.org\n",
-		       acpi_apic_instance ? 0 : 2);
+		pr_warn(PREFIX "BIOS bug: multiple APIC/MADT found, using %d\n",
+			acpi_apic_instance);
+		pr_warn(PREFIX "If \"acpi_apic_instance=%d\" works better, "
+			"notify linux-acpi@vger.kernel.org\n",
+			acpi_apic_instance ? 0 : 2);
 		early_acpi_os_unmap_memory(table, tbl_size);
 
 	} else
@@ -365,8 +350,7 @@ static int __init acpi_parse_apic_instance(char *str)
 
 	acpi_apic_instance = simple_strtoul(str, NULL, 0);
 
-	printk(KERN_NOTICE PREFIX "Shall use APIC/MADT table %d\n",
-	       acpi_apic_instance);
+	pr_notice(PREFIX "Shall use APIC/MADT table %d\n", acpi_apic_instance);
 
 	return 0;
 }
-- 
1.7.9.5

