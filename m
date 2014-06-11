Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaFKLJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:09:20 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50666 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaFKLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:09:19 -0400
Date: Wed, 11 Jun 2014 15:09:14 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] ip_vti: fix sparse warnings for VTI_ISVTI
Message-Id: <20140611150914.c3cb48bb8a1a760564f5db6e@qrator.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

net/ipv4/ip_tunnel.c:245:53: warning: restricted __be16 degrades to integer
net/ipv4/ip_vti.c:321:19: warning: incorrect type in assignment (different base types)
net/ipv4/ip_vti.c:321:19:    expected restricted __be16 [addressable] [assigned] [usertype] i_flags
net/ipv4/ip_vti.c:321:19:    got int
net/ipv4/ip_vti.c:447:24: warning: incorrect type in assignment (different base types)
net/ipv4/ip_vti.c:447:24:    expected restricted __be16 [usertype] i_flags
net/ipv4/ip_vti.c:447:24:    got int

Since VTI_ISVTI is always used with ip_tunnel_parm->i_flags (which is __be16),
we can __force cast VTI_ISVTI to __be16 in header file.

Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
---
 include/uapi/linux/if_tunnel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
index aee73d0..3bce9e9 100644
--- a/include/uapi/linux/if_tunnel.h
+++ b/include/uapi/linux/if_tunnel.h
@@ -100,7 +100,7 @@ enum {
 #define IFLA_GRE_MAX	(__IFLA_GRE_MAX - 1)
 
 /* VTI-mode i_flags */
-#define VTI_ISVTI 0x0001
+#define VTI_ISVTI ((__force __be16)0x0001)
 
 enum {
 	IFLA_VTI_UNSPEC,
