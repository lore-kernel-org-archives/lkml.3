Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaG2D2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:28:19 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58973 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaG2D2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:28:17 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH] ACPI / processor: Make it possible to get local x2apic id via _MAT
Date: Tue, 29 Jul 2014 11:27:50 +0800
Message-Id: <1406604470-4800-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logical processors with APIC ID values of 255 and greater are
required to have a Processor Device object and must convey the
processor's APIC information to OSPM using the Processor Local
X2APIC structure, but not until ACPI 5.1, X2APIC structure was
not supported in _MAT method.

_MAT is needed for CPU hotplug and system with more than 255
CPUs will definitely need X2APIC structure, so add its support
in map_mat_entry() to make it possible to get local x2apic id
via _MAT based on ACPI 5.1.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/processor_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 00f48d1..e32321c 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -129,6 +129,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 		map_lapic_id(header, acpi_id, &apic_id);
 	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 		map_lsapic_id(header, type, acpi_id, &apic_id);
+	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+		map_x2apic_id(header, type, acpi_id, &apic_id);
 	}
 
 exit:
-- 
1.7.9.5

