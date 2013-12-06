Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3LFGUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:20:05 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55153 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab3LFGT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:19:57 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [net-next PATCH v3 1/6] vhost: remove the dead branch
Date: Fri,  6 Dec 2013 14:19:37 +0800
Message-Id: <1386310782-9378-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386310782-9378-1-git-send-email-zwu.kernel@gmail.com>
References: <1386310782-9378-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120606-8236-0000-0000-00000499C3B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Since vhost_dev_init() forever return 0, some branches are never run,
therefore need to be removed.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c  |    5 -----
 drivers/vhost/scsi.c |    5 -----
 drivers/vhost/test.c |    5 -----
 3 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 831eb4f..0554785 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -707,11 +707,6 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].sock_hlen = 0;
 	}
 	r = vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX);
-	if (r < 0) {
-		kfree(n);
-		kfree(vqs);
-		return r;
-	}
 
 	vhost_poll_init(n->poll + VHOST_NET_VQ_TX, handle_tx_net, POLLOUT, dev);
 	vhost_poll_init(n->poll + VHOST_NET_VQ_RX, handle_rx_net, POLLIN, dev);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f175629..3164680 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1421,14 +1421,9 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 
 	tcm_vhost_init_inflight(vs, NULL);
 
-	if (r < 0)
-		goto err_init;
-
 	f->private_data = vs;
 	return 0;
 
-err_init:
-	kfree(vqs);
 err_vqs:
 	vhost_scsi_free(vs);
 err_vs:
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 339eae8..99cb960 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -118,11 +118,6 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
 	r = vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX);
-	if (r < 0) {
-		kfree(vqs);
-		kfree(n);
-		return r;
-	}
 
 	f->private_data = n;
 
-- 
1.7.6.5

