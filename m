Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaJMCoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:44:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaJMC2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:28:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matan Barak <matanb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 34/55] net/mlx4_core: Allow not to specify probe_vf in SRIOV IB mode
Date: Mon, 13 Oct 2014 04:24:48 +0200
Message-Id: <20141013022445.252722722@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matan Barak <matanb@mellanox.com>

[ Upstream commit effa4bc4e75a265105f4ccb55857057e5ad231ed ]

When the HCA is configured in SRIOV IB mode (that is, at least one of
the ports is IB) and the probe_vf module param isn't specified,
mlx4_init_one() failed because of the following condition:

if (ib_ports && (num_vfs_argc > 1 || probe_vfs_argc > 1)) {
	 .....
}

The root cause for that is a mistake in the initialization of num_vfs_argc
and probe_vfs_argc. When num_vfs / probe_vf aren't given, their argument
count counterpart should be 0, fix that.

Fixes: dd41cc3bb90e ('net/mlx4: Adapt num_vfs/probed_vf params for single port VF')
Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -78,13 +78,13 @@ MODULE_PARM_DESC(msi_x, "attempt to use
 #endif /* CONFIG_PCI_MSI */
 
 static uint8_t num_vfs[3] = {0, 0, 0};
-static int num_vfs_argc = 3;
+static int num_vfs_argc;
 module_param_array(num_vfs, byte , &num_vfs_argc, 0444);
 MODULE_PARM_DESC(num_vfs, "enable #num_vfs functions if num_vfs > 0\n"
 			  "num_vfs=port1,port2,port1+2");
 
 static uint8_t probe_vf[3] = {0, 0, 0};
-static int probe_vfs_argc = 3;
+static int probe_vfs_argc;
 module_param_array(probe_vf, byte, &probe_vfs_argc, 0444);
 MODULE_PARM_DESC(probe_vf, "number of vfs to probe by pf driver (num_vfs > 0)\n"
 			   "probe_vf=port1,port2,port1+2");


