Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3FMGeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab3FMGeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:34:06 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: edumazet@google.com, Jason Wang <jasowang@redhat.com>
Subject: [net-next PATCH V2 2/2] macvtap: fix uninitialized return value macvtap_ioctl_set_queue()
Date: Thu, 13 Jun 2013 14:23:36 +0800
Message-Id: <1371104616-18319-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1371104616-18319-1-git-send-email-jasowang@redhat.com>
References: <1371104616-18319-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EINVAL on illegal flag instead of uninitialized value. This fixes the
kbuild test warning.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index edcbf1c..5a76f20 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -969,6 +969,8 @@ static int macvtap_ioctl_set_queue(struct file *file, unsigned int flags)
 		ret = macvtap_enable_queue(vlan->dev, file, q);
 	else if (flags & IFF_DETACH_QUEUE)
 		ret = macvtap_disable_queue(q);
+	else
+		ret = -EINVAL;
 
 	macvtap_put_vlan(vlan);
 	return ret;
-- 
1.7.1

