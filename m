Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3CNKut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:50:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab3CNKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 48/88] vhost: fix length for cross region descriptor
Date: Thu, 14 Mar 2013 10:35:41 +0000
Message-Id: <1363257381-15900-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit bd97120fc3d1a11f3124c7c9ba1d91f51829eb85 upstream.

If a single descriptor crosses a region, the
second chunk length should be decremented
by size translated so far, instead it includes
the full descriptor length.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 112156f..6da514b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1077,7 +1077,7 @@ static int translate_desc(struct vhost_dev *dev, u64 addr, u32 len,
 		}
 		_iov = iov + ret;
 		size = reg->memory_size - addr + reg->guest_phys_addr;
-		_iov->iov_len = min((u64)len, size);
+		_iov->iov_len = min((u64)len - s, size);
 		_iov->iov_base = (void __user *)(unsigned long)
 			(reg->userspace_addr + addr - reg->guest_phys_addr);
 		s += size;
-- 
1.8.1.2

