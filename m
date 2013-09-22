Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3IVQKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 12:10:00 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49973 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3IVQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 12:09:59 -0400
From: Avinash kumar <avi.kp.137@gmail.com>
To: sbhatewara@vmware.com
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avinash kumar <avi.kp.137@gmail.com>
Subject: [PATCH 2/2] drivers: net: vmxnet3 : vmxnet3_drv.c: removed checkaptch warning related to msleep()
Date: Sun, 22 Sep 2013 21:39:47 +0530
Message-Id: <1379866187-3158-1-git-send-email-avi.kp.137@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replaced msleep(1) by usleep_range(1000,1500). Documentation/timers/timers_howto.txt
suggests use of usleep_range() in place of msleep() where desired delay is of range
1-20 ms.

Signed-off-by: Avinash Kumar <avi.kp.137@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 7e2788c..34fd6b6 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2608,7 +2608,7 @@ vmxnet3_close(struct net_device *netdev)
 	 * completion.
 	 */
 	while (test_and_set_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state))
-		msleep(1);
+		usleep_range(1000, 1500);
 
 	vmxnet3_quiesce_dev(adapter);
 
@@ -2656,7 +2656,7 @@ vmxnet3_change_mtu(struct net_device *netdev, int new_mtu)
 	 * completion.
 	 */
 	while (test_and_set_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state))
-		msleep(1);
+		usleep_range(1000, 1500);
 
 	if (netif_running(netdev)) {
 		vmxnet3_quiesce_dev(adapter);
-- 
1.7.9.5

