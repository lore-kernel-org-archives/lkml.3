Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbaEMJ6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:58:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60839 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760081AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 053/182] PCI: mvebu: Fix potential issue in range parsing
Date: Tue, 13 May 2014 11:26:45 +0200
Message-Id: <27363f77e5527780eddb255c345c0f69173ee45f.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/host/pci-mvebu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 8efd11dafd44..b4214cba58b7 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -749,7 +749,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 
 	for (i = 0; i < nranges; i++) {
 		u32 flags = of_read_number(range, 1);
-		u32 slot = of_read_number(range, 2);
+		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
 		unsigned long rtype;
 
-- 
1.9.3

