Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3EWDW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab3EWDWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:22:55 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next RFC 2/8] macvtap: return -EBADFD when TUNGETIFF fails
Date: Thu, 23 May 2013 11:12:27 +0800
Message-Id: <1369278753-2533-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuntap return -EBADFD when TUNGETIFF fails, we should return the same value.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 59e9605..ce1c72a 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -928,7 +928,7 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
 		rcu_read_unlock_bh();
 
 		if (!vlan)
-			return -ENOLINK;
+			return -EBADFD;
 
 		ret = 0;
 		if (copy_to_user(&ifr->ifr_name, vlan->dev->name, IFNAMSIZ) ||
-- 
1.7.1

