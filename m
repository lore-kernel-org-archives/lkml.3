Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbaKYL7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:59:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaKYKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 036/254] fix breakage in o2net_send_tcp_msg()
Date: Tue, 25 Nov 2014 10:36:26 +0000
Message-Id: <1416912004-5928-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7e8631e8b9d4e9f698c09c7e7309c96249180ff9 upstream.

uninitialized msghdr.  Broken in "ocfs2: don't open-code kernel_recvmsg()"
by me ;-/

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ocfs2/cluster/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 681691bc233a..f39a0e9dacf0 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -925,7 +925,7 @@ static int o2net_send_tcp_msg(struct socket *sock, struct kvec *vec,
 			      size_t veclen, size_t total)
 {
 	int ret;
-	struct msghdr msg;
+	struct msghdr msg = {.msg_flags = 0,};
 
 	if (sock == NULL) {
 		ret = -EINVAL;
-- 
2.1.0

