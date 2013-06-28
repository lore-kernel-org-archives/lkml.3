Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3F1TCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:02:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3F1S6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:58:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 084/105] tuntap: set SOCK_ZEROCOPY flag during open
Date: Fri, 28 Jun 2013 11:51:46 -0700
Message-Id: <1372445527-24414-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 19a6afb23e5d323e1245baa4e62755492b2f1200 ]

Commit 54f968d6efdbf7dec36faa44fc11f01b0e4d1990
(tuntap: move socket to tun_file) forgets to set SOCK_ZEROCOPY flag, which will
prevent vhost_net from doing zercopy w/ tap. This patch fixes this by setting
it during file open.

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2129cf90..2a56317 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2154,6 +2154,8 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	set_bit(SOCK_EXTERNALLY_ALLOCATED, &tfile->socket.flags);
 	INIT_LIST_HEAD(&tfile->next);
 
+	sock_set_flag(&tfile->sk, SOCK_ZEROCOPY);
+
 	return 0;
 }
 
-- 
1.8.1.2

