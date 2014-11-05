Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaKEQia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:38:30 -0500
Received: from mx2.parallels.com ([199.115.105.18]:52882 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaKEQiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:38:06 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH TRIVIAL] net: unix_listen: remove unused old_pid variable
Date: Wed, 5 Nov 2014 19:37:54 +0300
Message-ID: <1415205474-10240-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 net/unix/af_unix.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e96884380732..2948f39b9a4f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -478,7 +478,6 @@ static int unix_listen(struct socket *sock, int backlog)
 	int err;
 	struct sock *sk = sock->sk;
 	struct unix_sock *u = unix_sk(sk);
-	struct pid *old_pid = NULL;
 
 	err = -EOPNOTSUPP;
 	if (sock->type != SOCK_STREAM && sock->type != SOCK_SEQPACKET)
@@ -499,7 +498,6 @@ static int unix_listen(struct socket *sock, int backlog)
 
 out_unlock:
 	unix_state_unlock(sk);
-	put_pid(old_pid);
 out:
 	return err;
 }
-- 
1.7.10.4

