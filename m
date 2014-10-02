Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaJBPZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:25:41 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:57576 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaJBPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:25:39 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com, akpm@linux-foundation.org,
        adobriyan@gmail.com, rui.xiang@huawei.com, viro@zeniv.linux.org.uk,
        oleg@redhat.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu,
        Thierry Herbelot <thierry.herbelot@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC PATCH linux 1/2] proc_net: declare /proc/net as a directory
Date: Thu,  2 Oct 2014 17:25:00 +0200
Message-Id: <1412263501-6572-2-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>
References: <20131003.150947.2179820478039260398.davem@davemloft.net>
 <1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Herbelot <thierry.herbelot@6wind.com>

The mode bits are copied from those of "proc_root".

This commit prepares the next patch.

Signed-off-by: Thierry Herbelot <thierry.herbelot@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 fs/proc/proc_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index a63af3e0a612..6fc308ec105c 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -193,6 +193,7 @@ static __net_init int proc_net_ns_init(struct net *net)
 		goto out;
 
 	netd->data = net;
+	netd->mode = S_IFDIR | S_IRUGO | S_IXUGO;
 	netd->nlink = 2;
 	netd->namelen = 3;
 	netd->parent = &proc_root;
-- 
2.1.0

