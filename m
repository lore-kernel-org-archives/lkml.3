Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbaKADCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 23:02:05 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33901 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaKADCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 23:02:03 -0400
Message-ID: <54544E98.4060007@gmail.com>
Date: Sat, 01 Nov 2014 11:08:08 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: michal.simek@xilinx.com, soren.brinkmann@xilinx.com
CC: davem@davemloft.net, sthokal@xilinx.com, manuel.schoelling@gmx.de,
        paul.gortmaker@windriver.com, f.fainelli@gmail.com,
        ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers: net: ethernet: xilinx: xilinx_emaclite: Compatible
 with 'xlnx,xps-ethernetlite-2.00.b' for QEMU using
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When use current latest upstream qemu (current version: 2.1.2), need let
driver compatible with 'xlnx,xps-ethernetlite-2.00.b', or can not find
net device in microblaze qemu. Related QEMU commands under fedora 20:

  yum install libvirt
  yum install tunctl
  tunctl -b
  ip link set tap0 up
  brctl addif virbr0 tap0
  ./microblaze-softmmu/qemu-system-microblaze -M petalogix-s3adsp1800 \
    -kernel ../linux-stable.microblaze/arch/microblaze/boot/linux.bin \
    -no-reboot -append "console=ttyUL0,115200 doreboot" -nographic \
    -net nic,vlan=0,model=xlnx.xps-ethernetlite,macaddr=00:16:35:AF:94:00 \
    -net tap,vlan=0,ifname=tap0,script=no,downscript=no

  in microblaze qemu bash (guest machine):

    ifconfig eth0 add 192.168.122.1 netmask 255.255.255.0
    ifconfig eth0 up

After add this patch, can find the device, and can be used by 'telnetd'
(need cross-build busybox with glibc for it), then outside can telnet to
it without password.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 28dbbdc..298fad3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1236,6 +1236,7 @@ static struct of_device_id xemaclite_of_match[] = {
 	{ .compatible = "xlnx,opb-ethernetlite-1.01.b", },
 	{ .compatible = "xlnx,xps-ethernetlite-1.00.a", },
 	{ .compatible = "xlnx,xps-ethernetlite-2.00.a", },
+	{ .compatible = "xlnx,xps-ethernetlite-2.00.b", },
 	{ .compatible = "xlnx,xps-ethernetlite-2.01.a", },
 	{ .compatible = "xlnx,xps-ethernetlite-3.00.a", },
 	{ /* end of list */ },
-- 
1.9.3
