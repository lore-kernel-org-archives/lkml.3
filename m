Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbaGRH2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:28:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45639 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755936AbaGRH1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:27:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to the 3.12 stable tree] NFS: populate ->net in mount data when remounting
Date: Fri, 18 Jul 2014 09:25:18 +0200
Message-Id: <1405668451-13298-37-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405668451-13298-1-git-send-email-jslaby@suse.cz>
References: <1405668451-13298-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mateusz Guzik <mguzik@redhat.com>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

commit a914722f333b3359d2f4f12919380a334176bb89 upstream.

Otherwise the kernel oopses when remounting with IPv6 server because
net is dereferenced in dev_get_by_name.

Use net ns of current thread so that dev_get_by_name does not operate on
foreign ns. Changing the address is prohibited anyway so this should not
affect anything.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index a03b9c6f9489..64940b5286db 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2197,6 +2197,7 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	data->timeo = 10U * nfss->client->cl_timeout->to_initval / HZ;
 	data->nfs_server.port = nfss->port;
 	data->nfs_server.addrlen = nfss->nfs_client->cl_addrlen;
+	data->net = current->nsproxy->net_ns;
 	memcpy(&data->nfs_server.address, &nfss->nfs_client->cl_addr,
 		data->nfs_server.addrlen);
 
-- 
2.0.0

