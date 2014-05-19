Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaESQwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:52:18 -0400
Received: from mout.gmx.net ([212.227.15.15]:60725 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549AbaESQwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:52:14 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] net: vxge: Use time_is_before_jiffies() for time comparison
Date: Mon, 19 May 2014 18:51:58 +0200
Message-Id: <1400518318-12386-2-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400518318-12386-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400518056-12089-1-git-send-email-manuel.schoelling@gmx.de>
 <1400518318-12386-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:cyAJw3cFIAwF3bfsHbneN5TJz6sN/2E+efJJWXSGxVyCkAdL4Hl
 klby3r75eWcKtW/mOBvuojdSOc+jrmJDTTwxnpdgCIqaNZSgIsXI1Qf+ZSHPnex0JH6cm4K
 hVtE4wbsii/6510BLT4/s/n2o1HEMDnKmif4ETAnzW5Jv1WhUpaPoKC0wNyD0W2tQkrorhv
 tB3zYNTHeecMXEzJyfriQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_is_before_jiffies() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index d107bcb..79f42db 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2122,7 +2122,7 @@ static int vxge_open_vpaths(struct vxgedev *vdev)
 static void adaptive_coalesce_tx_interrupts(struct vxge_fifo *fifo)
 {
 	fifo->interrupt_count++;
-	if (jiffies > fifo->jiffies + HZ / 100) {
+	if (time_is_before_jiffies(fifo->jiffies + HZ / 100)) {
 		struct __vxge_hw_fifo *hw_fifo = fifo->handle;
 
 		fifo->jiffies = jiffies;
@@ -2150,7 +2150,7 @@ static void adaptive_coalesce_tx_interrupts(struct vxge_fifo *fifo)
 static void adaptive_coalesce_rx_interrupts(struct vxge_ring *ring)
 {
 	ring->interrupt_count++;
-	if (jiffies > ring->jiffies + HZ / 100) {
+	if (time_is_before_jiffies(ring->jiffies + HZ / 100)) {
 		struct __vxge_hw_ring *hw_ring = ring->handle;
 
 		ring->jiffies = jiffies;
-- 
1.7.10.4

