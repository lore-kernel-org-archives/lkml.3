Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaA2STZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:19:25 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49927 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaA2STV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:19:21 -0500
Subject: [PATCH 15/17] ACPI / numa: Simplify acpi_get_node() style
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:19:18 -0700
Message-ID: <20140129181918.15476.38407.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify control flow by removing local variable initialization and
returning a constant as soon as possible.  No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/acpi/numa.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index dab7dac6b1a8..a7e779bfa2f6 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -333,12 +333,12 @@ int acpi_get_pxm(acpi_handle h)
 
 int acpi_get_node(acpi_handle handle)
 {
-	int pxm, node = NUMA_NO_NODE;
+	int pxm;
 
 	pxm = acpi_get_pxm(handle);
-	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)
-		node = acpi_map_pxm_to_node(pxm);
+	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS)
+		return NUMA_NO_NODE;
 
-	return node;
+	return acpi_map_pxm_to_node(pxm);
 }
 EXPORT_SYMBOL(acpi_get_node);

