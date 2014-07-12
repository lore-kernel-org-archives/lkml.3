Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaGLLhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:37:01 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:30364 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025AbaGLLgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:36:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8KALscwVNXQ56W/2dsb2JhbABZgw6tMQEBAQEBAQUBbgGcAAGBDRd1hAQBBVYjEFE5HhmIRgG0Q5InF4V7iVAHFoQtBZsOi1WISINGOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/7] powerpc/mv64x60_pci: replace sscanf by kstrtou32
Date: Sat, 12 Jul 2014 13:36:15 +0200
Message-Id: <1405164980-9525-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405164980-9525-1-git-send-email-fabf@skynet.be>
References: <1405164980-9525-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See checkpatch warning
"Prefer kstrto<type> to single variable sscanf"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/powerpc/sysdev/mv64x60_pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/mv64x60_pci.c b/arch/powerpc/sysdev/mv64x60_pci.c
index 330d566..ca0b29c 100644
--- a/arch/powerpc/sysdev/mv64x60_pci.c
+++ b/arch/powerpc/sysdev/mv64x60_pci.c
@@ -52,14 +52,17 @@ static ssize_t mv64x60_hs_reg_write(struct file *filp, struct kobject *kobj,
 {
 	struct pci_dev *phb;
 	u32 v;
+	int rc;
 
 	if (off > 0)
 		return 0;
 	if (count <= 0)
 		return -EINVAL;
 
-	if (sscanf(buf, "%i", &v) != 1)
-		return -EINVAL;
+	rc = kstrtou32(buf, 0, &v);
+
+	if (rc)
+		return rc;
 
 	phb = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
 	if (!phb)
-- 
1.9.1

