Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaAJK2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:28:13 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49816 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaAJK2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:28:10 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: thomas.petazzoni@free-electrons.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH] mvebu : pcie: dt: potential issue in range parsing
Date: Fri, 10 Jan 2014 11:23:51 +0100
Message-Id: <1389349431-7997-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second parameter of of_read_number is not the index, but a size.
As it happens, in this case it may work just fine because of the the conversion
to u32 and the favorable endianness on this architecture.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/pci/host/pci-mvebu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index c269e43..877e8ce 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -768,7 +768,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 
 	for (i = 0; i < nranges; i++) {
 		u32 flags = of_read_number(range, 1);
-		u32 slot = of_read_number(range, 2);
+		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
 		unsigned long rtype;
 
-- 
1.8.5.2

