Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab3CVNQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:16:13 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44124 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3CVNQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:16:12 -0400
MIME-Version: 1.0
Date: Fri, 22 Mar 2013 21:16:11 +0800
Message-ID: <CAPgLHd_GCM6HPsbFmj1YfBbQ2VMTzdsNJuoDvDmyaZ2DCnWNXw@mail.gmail.com>
Subject: [PATCH -next] rpmsg: fix error return code in rpmsg_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ohad@wizery.com, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        tj@kernel.org, sboyd@codeaurora.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 33d827b..56fceaf 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -951,8 +951,10 @@ static int rpmsg_probe(struct virtio_device *vdev)
 	bufs_va = dma_alloc_coherent(vdev->dev.parent->parent,
 				RPMSG_TOTAL_BUF_SPACE,
 				&vrp->bufs_dma, GFP_KERNEL);
-	if (!bufs_va)
+	if (!bufs_va) {
+		err = -ENOMEM;
 		goto vqs_del;
+	}
 
 	dev_dbg(&vdev->dev, "buffers: va %p, dma 0x%llx\n", bufs_va,
 					(unsigned long long)vrp->bufs_dma);

