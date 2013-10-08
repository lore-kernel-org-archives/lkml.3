Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3JHNqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:46:50 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46696 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3JHNqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:46:25 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, Joe Perches <joe@perches.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the net-next tree
Date: Tue,  8 Oct 2013 15:44:14 +0200
Message-Id: <1381239855-16314-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381239855-16314-1-git-send-email-treding@nvidia.com>
References: <1381239855-16314-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the net-next tree got a conflict in:

	include/linux/netdevice.h

caused by commits 3573540 (netif_set_xps_queue: make cpu mask const) and
f629d20 ([networking]device.h: Remove extern from function prototypes).
I fixed it up (see below). Please verify that the resolution looks
correct.

Thanks,
Thierry
---
diff --cc include/linux/netdevice.h
index 25f5d2d,6d77e0f..2e53b44
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@@ -2264,12 -2273,11 +2273,11 @@@ static inline void netif_wake_subqueue(
  }
  
  #ifdef CONFIG_XPS
- extern int netif_set_xps_queue(struct net_device *dev,
- 			       const struct cpumask *mask,
- 			       u16 index);
 -int netif_set_xps_queue(struct net_device *dev, struct cpumask *mask,
++int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
+ 			u16 index);
  #else
  static inline int netif_set_xps_queue(struct net_device *dev,
 -				      struct cpumask *mask,
 +				      const struct cpumask *mask,
  				      u16 index)
  {
  	return 0;
