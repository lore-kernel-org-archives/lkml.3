Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab3JGLSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:18:37 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:58805 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3JGLSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:18:34 -0400
Date: Mon, 7 Oct 2013 14:16:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH mmots] net: static declaration of net_secret_init() follows
 non-static
Message-ID: <20131007111655.GC2460@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix secure_seq build error

net/core/secure_seq.c:17:13: error: static declaration of ‘net_secret_init’ follows
non-static declaration
 static void net_secret_init(void)

In file included from net/core/secure_seq.c:11:0:
include/net/secure_seq.h:6:6: note: previous declaration of ‘net_secret_init’ was
here
 void net_secret_init(void);

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 include/net/secure_seq.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index 52c1a90..f257486 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 
-void net_secret_init(void);
 __u32 secure_ip_id(__be32 daddr);
 __u32 secure_ipv6_id(const __be32 daddr[4]);
 u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);

