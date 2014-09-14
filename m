Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaINNM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:12:59 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:60880 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbaINNM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:12:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4OAH6TFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfIEEF3iEMS8jVkQ3iEIBqFqPGYV8iVEdhDUFjzeNUYwwiQ+CG4FFOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ACPI: processor: use container_of to resolve acpi_madt_local_apic/sapic/x2apic from acpi_subtable_header
Date: Sun, 14 Sep 2014 15:12:43 +0200
Message-Id: <1410700363-17939-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

Compiled but untested.

 drivers/acpi/processor_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index e32321c..ef58f46 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -16,7 +16,7 @@ static int map_lapic_id(struct acpi_subtable_header *entry,
 		 u32 acpi_id, int *apic_id)
 {
 	struct acpi_madt_local_apic *lapic =
-		(struct acpi_madt_local_apic *)entry;
+		container_of(entry, struct acpi_madt_local_apic, header);
 
 	if (!(lapic->lapic_flags & ACPI_MADT_ENABLED))
 		return -ENODEV;
@@ -32,7 +32,7 @@ static int map_x2apic_id(struct acpi_subtable_header *entry,
 			 int device_declaration, u32 acpi_id, int *apic_id)
 {
 	struct acpi_madt_local_x2apic *apic =
-		(struct acpi_madt_local_x2apic *)entry;
+		container_of(entry, struct acpi_madt_local_x2apic, header);
 
 	if (!(apic->lapic_flags & ACPI_MADT_ENABLED))
 		return -ENODEV;
@@ -49,7 +49,7 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 		int device_declaration, u32 acpi_id, int *apic_id)
 {
 	struct acpi_madt_local_sapic *lsapic =
-		(struct acpi_madt_local_sapic *)entry;
+		container_of(entry, struct acpi_madt_local_sapic, header);
 
 	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
 		return -ENODEV;
-- 
1.9.1

