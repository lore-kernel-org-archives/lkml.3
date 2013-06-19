Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab3FSCAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:00:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933792Ab3FSBxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596284"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 05/22] Audit: implement audit self-defined compare function
Date: Wed, 19 Jun 2013 09:53:37 +0800
Message-Id: <1371606834-5802-6-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:00,
	Serialize complete at 2013/06/19 09:52:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch, audit netlink sockets can
communicate with each other when they belong
to the same user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 11b56b7..a411b02 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -895,6 +895,11 @@ static void audit_receive(struct sk_buff  *skb)
 	mutex_unlock(&audit_cmd_mutex);
 }
 
+static bool audit_compare(struct net *net, struct sock *sk)
+{
+	return (sock_net(sk)->user_ns == net->user_ns);
+}
+
 static int __net_init audit_net_init(struct net *net)
 {
 	struct user_namespace *ns = net->user_ns;
@@ -907,6 +912,7 @@ static int __net_init audit_net_init(struct net *net)
 		 */
 		struct netlink_kernel_cfg cfg = {
 			.input	= audit_receive,
+			.compare = audit_compare,
 		};
 
 		sk = netlink_kernel_create(net, NETLINK_AUDIT, &cfg);
-- 
1.8.1.4

