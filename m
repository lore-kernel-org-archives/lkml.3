Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3EaKEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:04:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab3EaKDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:03:55 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next rfc V2 4/8] macvlan: change the max number of queues to 16
Date: Fri, 31 May 2013 17:53:21 +0800
Message-Id: <1369994005-5943-5-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369994005-5943-1-git-send-email-jasowang@redhat.com>
References: <1369994005-5943-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macvtap should be at least compatible with tap, so change the max number to 16.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/if_macvlan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index e47ad46..62d8bda 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -50,7 +50,7 @@ struct macvlan_pcpu_stats {
  * Maximum times a macvtap device can be opened. This can be used to
  * configure the number of receive queue, e.g. for multiqueue virtio.
  */
-#define MAX_MACVTAP_QUEUES	(NR_CPUS < 16 ? NR_CPUS : 16)
+#define MAX_MACVTAP_QUEUES	16
 
 #define MACVLAN_MC_FILTER_BITS	8
 #define MACVLAN_MC_FILTER_SZ	(1 << MACVLAN_MC_FILTER_BITS)
-- 
1.7.1

