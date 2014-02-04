Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbaBDVDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:03:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbaBDVDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:03:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steven Rostedt <srostedt@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 3.10 088/104] Revert "ip6tnl: fix use after free of fb_tnl_dev"
Date: Tue,  4 Feb 2014 13:02:31 -0800
Message-Id: <20140204210225.202185269@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ No relevant upstream commit. ]

This reverts commit 22c3ec552c29cf4bd4a75566088950fe57d860c4.

This patch is not the right fix, it introduces a memory leak when a netns is
destroyed (the FB device is never deleted).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reported-by: Steven Rostedt <srostedt@redhat.com>
Tested-by: Steven Rostedt <srostedt@redhat.com> (and our entire MRG team)
Tested-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Tested-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1711,6 +1711,8 @@ static void __net_exit ip6_tnl_destroy_t
 		}
 	}
 
+	t = rtnl_dereference(ip6n->tnls_wc[0]);
+	unregister_netdevice_queue(t->dev, &list);
 	unregister_netdevice_many(&list);
 }
 


