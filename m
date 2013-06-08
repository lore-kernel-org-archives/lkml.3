Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3FKNNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:13:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab3FKNNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:13:36 -0400
From: Jason Wang <jasowang@redhat.com>
To: smtp.corp.redhat.com@redhat.com, davem@davemloft.net, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net PATCH] tuntap: set SOCK_ZEROCOPY flag during open
Date: Sat,  8 Jun 2013 14:17:41 +0800
Message-Id: <1370672261-30076-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 54f968d6efdbf7dec36faa44fc11f01b0e4d1990
(tuntap: move socket to tun_file) forgets to set SOCK_ZEROCOPY flag, which will
prevent vhost_net from doing zercopy w/ tap. This patch fixes this by setting
it during file open.

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f042b03..d2ddd6d 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2155,6 +2155,8 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	set_bit(SOCK_EXTERNALLY_ALLOCATED, &tfile->socket.flags);
 	INIT_LIST_HEAD(&tfile->next);
 
+	sock_set_flag(&tfile->sk, SOCK_ZEROCOPY);
+
 	return 0;
 }
 
-- 
1.7.1
