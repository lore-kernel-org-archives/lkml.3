Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3EWDX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:23:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725Ab3EWDXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:23:25 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next RFC 8/8] macvtap: enable multiqueue flag
Date: Thu, 23 May 2013 11:12:33 +0800
Message-Id: <1369278753-2533-9-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 06b10a5..6a4af74 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -31,10 +31,6 @@
  * macvtap_proto is used to allocate queues through the sock allocation
  * mechanism.
  *
- * TODO: multiqueue support is currently not implemented, even though
- * macvtap is basically prepared for that. We will need to add this
- * here as well as in virtio-net and qemu to get line rate on 10gbit
- * adapters from a guest.
  */
 struct macvtap_queue {
 	struct sock sk;
@@ -1046,7 +1042,8 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
 		return macvtap_ioctl_set_queue(file, u);
 
 	case TUNGETFEATURES:
-		if (put_user(IFF_TAP | IFF_NO_PI | IFF_VNET_HDR, up))
+		if (put_user(IFF_TAP | IFF_NO_PI | IFF_VNET_HDR |
+			     IFF_MULTI_QUEUE, up))
 			return -EFAULT;
 		return 0;
 
-- 
1.7.1

