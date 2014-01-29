Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaA2STc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:19:32 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33862 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaA2ST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:19:28 -0500
Subject: [PATCH 16/17] ACPI / numa: Make __acpi_map_pxm_to_node(),
 acpi_get_pxm() static
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:19:25 -0700
Message-ID: <20140129181925.15476.24730.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__acpi_map_pxm_to_node() and acpi_get_pxm() are only used within
drivers/acpi/numa.c.  This makes them static and removes their
declarations.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/acpi/numa.c      |    4 ++--
 include/acpi/acpi_numa.h |    1 -
 include/linux/acpi.h     |    5 -----
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index a7e779bfa2f6..359a43bdd948 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -60,7 +60,7 @@ int node_to_pxm(int node)
 	return node_to_pxm_map[node];
 }
 
-void __acpi_map_pxm_to_node(int pxm, int node)
+static void __acpi_map_pxm_to_node(int pxm, int node)
 {
 	if (pxm_to_node_map[pxm] == NUMA_NO_NODE || node < pxm_to_node_map[pxm])
 		pxm_to_node_map[pxm] = node;
@@ -314,7 +314,7 @@ int __init acpi_numa_init(void)
 	return 0;
 }
 
-int acpi_get_pxm(acpi_handle h)
+static int acpi_get_pxm(acpi_handle h)
 {
 	unsigned long long pxm;
 	acpi_status status;
diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
index 451823cb8837..94a37cd7fbda 100644
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -13,7 +13,6 @@
 
 extern int pxm_to_node(int);
 extern int node_to_pxm(int);
-extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
 extern unsigned char acpi_srat_revision;
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 17bee650a0cb..6c29abbefd41 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -259,13 +259,8 @@ extern void acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d);
 extern void acpi_osi_setup(char *str);
 
 #ifdef CONFIG_ACPI_NUMA
-int acpi_get_pxm(acpi_handle handle);
 int acpi_get_node(acpi_handle handle);
 #else
-static inline int acpi_get_pxm(acpi_handle handle)
-{
-	return 0;
-}
 static inline int acpi_get_node(acpi_handle handle)
 {
 	return 0;

