Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaKDOhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:37:11 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41044 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKDOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:37:08 -0500
Message-ID: <5458E605.6070801@gmail.com>
Date: Tue, 04 Nov 2014 22:43:17 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: michal.simek@xilinx.com, soren.brinkmann@xilinx.com, davem@davemloft.net,
        sthokal@xilinx.com, manuel.schoelling@gmx.de, f.fainelli@gmail.com,
        paul.gortmaker@windriver.com, ebiederm@xmission.com
CC: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: net: ethernet: xilinx: xilinx_emaclite: revert the
 original commit "1db3ddff1602edf2390b7667dcbaa0f71512e3ea"
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microblaze is a fpga soft core, it can be customized easily, which may
cause many various hardware version strings.

So the original fix patch based on hard-coded compatible version strings
is not a good idea (although it is correct for current issue). For it,
there will be a new solving way soon (which based on the device tree).

The original issue is related with qemu, so can only change the hardware
version string in qemu for it, then keep the original driver no touch (
qemu is for virtualization which has much easier life than real world).


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 298fad3..28dbbdc 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1236,7 +1236,6 @@ static struct of_device_id xemaclite_of_match[] = {
 	{ .compatible = "xlnx,opb-ethernetlite-1.01.b", },
 	{ .compatible = "xlnx,xps-ethernetlite-1.00.a", },
 	{ .compatible = "xlnx,xps-ethernetlite-2.00.a", },
-	{ .compatible = "xlnx,xps-ethernetlite-2.00.b", },
 	{ .compatible = "xlnx,xps-ethernetlite-2.01.a", },
 	{ .compatible = "xlnx,xps-ethernetlite-3.00.a", },
 	{ /* end of list */ },
-- davem@davemloft.net
1.9.3
