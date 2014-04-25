Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaDYRRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:17:01 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34442 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDYRQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:16:51 -0400
Subject: [PATCH 3/4] x86/PCI: Move pcibios_assign_resources() annotation to
 definition
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Bodo Eggert <7eggert@gmx.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 25 Apr 2014 11:16:47 -0600
Message-ID: <20140425171647.312.98481.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140425171144.312.9601.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140425171144.312.9601.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pcibios_assign_resources() fs_initcall annotation next to the
function definition.  No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/i386.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 6db58d68feb5..a19ed92e74e4 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -361,6 +361,12 @@ static int __init pcibios_assign_resources(void)
 	return 0;
 }
 
+/**
+ * called in fs_initcall (one below subsys_initcall),
+ * give a chance for motherboard reserve resources
+ */
+fs_initcall(pcibios_assign_resources);
+
 void pcibios_resource_survey_bus(struct pci_bus *bus)
 {
 	dev_printk(KERN_DEBUG, &bus->dev, "Allocating resources\n");
@@ -397,12 +403,6 @@ void __init pcibios_resource_survey(void)
 	ioapic_insert_resources();
 }
 
-/**
- * called in fs_initcall (one below subsys_initcall),
- * give a chance for motherboard reserve resources
- */
-fs_initcall(pcibios_assign_resources);
-
 static const struct vm_operations_struct pci_mmap_ops = {
 	.access = generic_access_phys,
 };

