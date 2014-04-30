Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbaD3NzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:55:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17001 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbaD3Ny0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:54:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 4/6] xen/pciback: Document when the 'unbind' and 'bind' functions are called.
Date: Wed, 30 Apr 2014 09:54:09 -0400
Message-Id: <1398866051-32714-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And also mention that you cannot do any pci_reset_function,
pci_reset_slot, or such calls. This is because they take the same
lock as SysFS does - and we would end up with a dead-lock if
we call those functions.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index b84426a..1539bec 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -493,6 +493,8 @@ static int pcistub_seize(struct pci_dev *dev)
 	return err;
 }
 
+/* Called when 'bind'. This means we must _NOT_ call pci_reset_function or
+ * other functions that take the sysfs lock. */
 static int pcistub_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int err = 0;
@@ -520,6 +522,8 @@ out:
 	return err;
 }
 
+/* Called when 'unbind'. This means we must _NOT_ call pci_reset_function or
+ * other functions that take the sysfs lock. */
 static void pcistub_remove(struct pci_dev *dev)
 {
 	struct pcistub_device *psdev, *found_psdev = NULL;
-- 
1.8.5.3

