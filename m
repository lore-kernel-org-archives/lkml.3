Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaA2STV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:19:21 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:58532 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaA2STO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:19:14 -0500
Subject: [PATCH 14/17] ACPI / numa: Fix acpi_get_node() prototype
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:19:10 -0700
Message-ID: <20140129181910.15476.66581.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_get_node() takes an acpi_handle, not an "acpi_handle *".  This
fixes the prototype and the definitions.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/acpi/numa.c  |    2 +-
 include/linux/acpi.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 9e6816ef280a..dab7dac6b1a8 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -331,7 +331,7 @@ int acpi_get_pxm(acpi_handle h)
 	return -1;
 }
 
-int acpi_get_node(acpi_handle *handle)
+int acpi_get_node(acpi_handle handle)
 {
 	int pxm, node = NUMA_NO_NODE;
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 1151a1dcfe41..17bee650a0cb 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -260,13 +260,13 @@ extern void acpi_osi_setup(char *str);
 
 #ifdef CONFIG_ACPI_NUMA
 int acpi_get_pxm(acpi_handle handle);
-int acpi_get_node(acpi_handle *handle);
+int acpi_get_node(acpi_handle handle);
 #else
 static inline int acpi_get_pxm(acpi_handle handle)
 {
 	return 0;
 }
-static inline int acpi_get_node(acpi_handle *handle)
+static inline int acpi_get_node(acpi_handle handle)
 {
 	return 0;
 }

