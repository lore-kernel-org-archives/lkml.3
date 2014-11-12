Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaKLDUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:20:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbaKLBfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:35:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.17 296/319] fix breakage in o2net_send_tcp_msg()
Date: Wed, 12 Nov 2014 10:17:14 +0900
Message-Id: <20141112011041.840156323@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7e8631e8b9d4e9f698c09c7e7309c96249180ff9 upstream.

uninitialized msghdr.  Broken in "ocfs2: don't open-code kernel_recvmsg()"
by me ;-/

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -925,7 +925,7 @@ static int o2net_send_tcp_msg(struct soc
 			      size_t veclen, size_t total)
 {
 	int ret;
-	struct msghdr msg;
+	struct msghdr msg = {.msg_flags = 0,};
 
 	if (sock == NULL) {
 		ret = -EINVAL;


