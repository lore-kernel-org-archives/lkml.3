Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaFGMhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 08:37:08 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:31244 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbaFGMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 08:37:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMOAPgGk1NXQ3Uj/2dsb2JhbABZgw2sGggBAQUBmRCBBBd1hDEvI1ZEN4hGAbQSmQMXhV2IOFcdhCsEmiGLKIgdgXyBQjuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Amir Vadai <amirv@mellanox.com>
Subject: [PATCH 1/1 linux-next] drivers/net/ethernet/mellanox/mlx4/main.c: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Sat,  7 Jun 2014 14:36:56 +0200
Message-Id: <1402144616-29646-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel.h definition.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index f627ad1..4a000da 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -2201,7 +2201,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data)
 	 * per port, we must limit the number of VFs to 63 (since their are
 	 * 128 MACs)
 	 */
-	for (i = 0; i < sizeof(nvfs)/sizeof(nvfs[0]) && i < num_vfs_argc;
+	for (i = 0; i < ARRAY_SIZE(nvfs) && i < num_vfs_argc;
 	     total_vfs += nvfs[param_map[num_vfs_argc - 1][i]], i++) {
 		nvfs[param_map[num_vfs_argc - 1][i]] = num_vfs[i];
 		if (nvfs[i] < 0) {
@@ -2209,8 +2209,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data)
 			return -EINVAL;
 		}
 	}
-	for (i = 0; i < sizeof(prb_vf)/sizeof(prb_vf[0]) && i < probe_vfs_argc;
-	     i++) {
+	for (i = 0; i < ARRAY_SIZE(prb_vf) && i < probe_vfs_argc; i++) {
 		prb_vf[param_map[probe_vfs_argc - 1][i]] = probe_vf[i];
 		if (prb_vf[i] < 0 || prb_vf[i] > nvfs[i]) {
 			dev_err(&pdev->dev, "probe_vf module parameter cannot be negative or greater than num_vfs\n");
@@ -2303,11 +2302,11 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data)
 		 * requested to probe them. */
 		if (total_vfs) {
 			unsigned vfs_offset = 0;
-			for (i = 0; i < sizeof(nvfs)/sizeof(nvfs[0]) &&
-				     vfs_offset + nvfs[i] < extended_func_num(pdev);
+			for (i = 0; i < ARRAY_SIZE(nvfs) &&
+			     vfs_offset + nvfs[i] < extended_func_num(pdev);
 			     vfs_offset += nvfs[i], i++)
 				;
-			if (i == sizeof(nvfs)/sizeof(nvfs[0])) {
+			if (i == ARRAY_SIZE(nvfs)) {
 				err = -ENODEV;
 				goto err_free_dev;
 			}
@@ -2441,7 +2440,7 @@ slave_start:
 					 "Invalid syntax of num_vfs/probe_vfs with IB port - single port VFs syntax is only supported when all ports are configured as ethernet\n");
 				goto err_close;
 			}
-			for (i = 0; i < sizeof(nvfs)/sizeof(nvfs[0]); i++) {
+			for (i = 0; i < ARRAY_SIZE(nvfs); i++) {
 				unsigned j;
 				for (j = 0; j < nvfs[i]; ++sum, ++j) {
 					dev->dev_vfs[sum].min_port =
-- 
1.9.1

