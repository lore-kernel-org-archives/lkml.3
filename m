Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbaKMVbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:31:46 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50756 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934364AbaKMVbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:43 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 53/56] net/ipv6: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:30 +0100
Message-Id: <1415913813-362-54-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ipv6 networking when the splice-family of
syscalls is not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is
undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 net/ipv6/af_inet6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2daa3a1..3d17064 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -523,7 +523,7 @@ const struct proto_ops inet6_stream_ops = {
 	.recvmsg	   = inet_recvmsg,		/* ok		*/
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
-	.splice_read	   = tcp_splice_read,
+	SPLICE_READ_INIT(tcp_splice_read)
 #ifdef CONFIG_COMPAT
 	.compat_setsockopt = compat_sock_common_setsockopt,
 	.compat_getsockopt = compat_sock_common_getsockopt,
-- 
1.9.1

