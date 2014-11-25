Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaKYRTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKYRTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:19:15 -0500
Date: Tue, 25 Nov 2014 18:43:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 28/42] vhost: make features 64 bit
Message-ID: <1416933600-21398-29-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use bit 32 for virtio 1.0

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b9032e8..1f321fd 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -106,7 +106,7 @@ struct vhost_virtqueue {
 	/* Protected by virtqueue mutex. */
 	struct vhost_memory *memory;
 	void *private_data;
-	unsigned acked_features;
+	u64 acked_features;
 	/* Log write descriptors */
 	void __user *log_base;
 	struct vhost_log *log;
-- 
MST

