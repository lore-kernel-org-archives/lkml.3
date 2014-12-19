Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaLSODt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:03:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaLSODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:03:48 -0500
Date: Fri, 19 Dec 2014 06:02:49 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-13ca62b243f69b5c0f82386e1cfbb880ee6fce10@git.kernel.org>
Cc: bp@alien8.de, gregkh@linuxfoundation.org, bhelgaas@google.com,
        jiang.liu@linux.intel.com, lenb@kernel.org, tony.luck@intel.com,
        hpa@zytor.com, joro@8bytes.org, tglx@linutronix.de, rjw@rjwysocki.net,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, yinghai@kernel.org, konrad.wilk@oracle.com,
        rdunlap@infradead.org
Reply-To: yinghai@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        rjw@rjwysocki.net, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tony.luck@intel.com,
        hpa@zytor.com, tglx@linutronix.de, joro@8bytes.org, bp@alien8.de,
        gregkh@linuxfoundation.org, bhelgaas@google.com,
        jiang.liu@linux.intel.com, lenb@kernel.org
In-Reply-To: <1414387308-27148-7-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-7-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] ACPI: Fix minor syntax issues in processor_core.c
Git-Commit-ID: 13ca62b243f69b5c0f82386e1cfbb880ee6fce10
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

Commit-ID:  13ca62b243f69b5c0f82386e1cfbb880ee6fce10
Gitweb:     http://git.kernel.org/tip/13ca62b243f69b5c0f82386e1cfbb880ee6fce10
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:36 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:14 +0100

ACPI: Fix minor syntax issues in processor_core.c

Fix minor syntax issues in processor_core.c to follow coding styles.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/1414387308-27148-7-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/acpi/processor_core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ef58f46..342942f 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -125,13 +125,12 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 	}
 
 	header = (struct acpi_subtable_header *)obj->buffer.pointer;
-	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC) {
+	if (header->type == ACPI_MADT_TYPE_LOCAL_APIC)
 		map_lapic_id(header, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC)
 		map_lsapic_id(header, type, acpi_id, &apic_id);
-	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
+	else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC)
 		map_x2apic_id(header, type, acpi_id, &apic_id);
-	}
 
 exit:
 	kfree(buffer.pointer);
@@ -164,7 +163,7 @@ int acpi_map_cpuid(int apic_id, u32 acpi_id)
 		 * For example,
 		 *
 		 * Scope (_PR)
-                 * {
+		 * {
 		 *     Processor (CPU0, 0x00, 0x00000410, 0x06) {}
 		 *     Processor (CPU1, 0x01, 0x00000410, 0x06) {}
 		 *     Processor (CPU2, 0x02, 0x00000410, 0x06) {}
