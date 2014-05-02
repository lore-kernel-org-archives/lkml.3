Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaEBPjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:39:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaEBPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 016/151] PCI: mvebu: Fix potential issue in range parsing
Date: Fri,  2 May 2014 08:36:44 -0700
Message-Id: <1399045139-4531-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

commit 4f4bde1df33bde076f53325bdf2c6430cf85e1bb upstream.

The second parameter of of_read_number() is not the index, but a size.  As
it happens, in this case it may work just fine because of the conversion to
u32 and the favorable endianness on this architecture.

Fixes: 11be65472a427 ("PCI: mvebu: Adapt to the new device tree layout")
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/host/pci-mvebu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index e9b7c2c..f26731c 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -766,7 +766,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 
 	for (i = 0; i < nranges; i++) {
 		u32 flags = of_read_number(range, 1);
-		u32 slot = of_read_number(range, 2);
+		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
 		unsigned long rtype;
 
-- 
1.9.1

