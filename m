Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaESU7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:59:12 -0400
Received: from mout.gmx.net ([212.227.15.15]:63522 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaESU7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:59:10 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: jdmason@kudzu.us
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, joe@perches.com,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] vxge: Use time_before()
Date: Mon, 19 May 2014 22:59:04 +0200
Message-Id: <1400533144-8473-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400520928.30820.23.camel@joe-AO725>
References: <1400520928.30820.23.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ibkimXP67vQfYF5SiDAGFlDTftYpn7D8HIjm6Q/aNffSQjMb1h9
 /mtDPnvl2oN3MmOuZr/kq6bUw8enYNM3aiv8k14wk4ZCv2ZSqbSKpGiuBk6LvH8QVOT1ZqX
 XfA25+Xmc+Jy8bwcxxEk4L1k5+4qwf6RcER9SzmValWReybtcp7jJMpd3YrQTVmGODGfWIn
 mCJfxdO3UwbjJVTacSz8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index d107bcb..7a0dead 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2122,7 +2122,7 @@ static int vxge_open_vpaths(struct vxgedev *vdev)
 static void adaptive_coalesce_tx_interrupts(struct vxge_fifo *fifo)
 {
 	fifo->interrupt_count++;
-	if (jiffies > fifo->jiffies + HZ / 100) {
+	if (time_before(fifo->jiffies + HZ / 100, jiffies)) {
 		struct __vxge_hw_fifo *hw_fifo = fifo->handle;
 
 		fifo->jiffies = jiffies;
@@ -2150,7 +2150,7 @@ static void adaptive_coalesce_tx_interrupts(struct vxge_fifo *fifo)
 static void adaptive_coalesce_rx_interrupts(struct vxge_ring *ring)
 {
 	ring->interrupt_count++;
-	if (jiffies > ring->jiffies + HZ / 100) {
+	if (time_before(ring->jiffies + HZ / 100, jiffies)) {
 		struct __vxge_hw_ring *hw_ring = ring->handle;
 
 		ring->jiffies = jiffies;
-- 
1.7.10.4

