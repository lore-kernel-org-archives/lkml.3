Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3BDIoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:44:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43255 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3BDIoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:44:11 -0500
X-IronPort-AV: E=Sophos;i="4.84,598,1355068800"; 
   d="scan'208";a="6686577"
From: liguang <lig.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 2/5] acpi/numa: check if parsing acpi numa info disabled earlier
Date: Mon, 4 Feb 2013 16:43:43 +0800
Message-Id: <1359967426-32629-3-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1359967426-32629-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1359967426-32629-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/04 16:42:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/04 16:42:53,
	Serialize complete at 2013/02/04 16:42:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 arch/x86/mm/srat.c  |    6 ------
 drivers/acpi/numa.c |    2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index a837c95..78c67bd 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -60,8 +60,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	int pxm, node;
 	int apic_id;
 
-	if (srat_disabled())
-		return;
 	if (pa->header.length < sizeof(struct acpi_srat_x2apic_cpu_affinity)) {
 		bad_srat();
 		return;
@@ -100,8 +98,6 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	int pxm, node;
 	int apic_id;
 
-	if (srat_disabled())
-		return;
 	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
 		bad_srat();
 		return;
@@ -148,8 +144,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	u64 start, end;
 	int node, pxm;
 
-	if (srat_disabled())
-		return -1;
 	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
 		bad_srat();
 		return -1;
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index cb31298..1f51222 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -262,6 +262,8 @@ static int __init acpi_parse_srat(struct acpi_table_header *table)
 	struct acpi_table_srat *srat;
 	if (!table)
 		return -EINVAL;
+	if (srat_disabled())
+		return -EACCES;
 
 	srat = (struct acpi_table_srat *)table;
 	acpi_srat_revision = srat->header.revision;
-- 
1.7.2.5

