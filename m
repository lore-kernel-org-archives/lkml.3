Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaBIQ71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:59:27 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60173 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaBIQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:59:25 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2011/13=5D=20net=3A=20Move=20prototype=20declaration=20to=20header=20file=20include/net/net=5Fnamespace=2Eh=20from=20net/ipx/af=5Fipx=2Ec?=
Date: Sun,  9 Feb 2014 22:29:14 +0530
Message-Id: <1fc35d143bf8d29a11d6a81fb94650682db1aa7c.1391955925.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of function to header file
include/net/net_namespace.h from net/ipx/af_ipx.c because they are used
by more than one file.

This eliminates the following warning in net/ipx/sysctl_net_ipx.c:
net/ipx/sysctl_net_ipx.c:33:6: warning: no previous prototype for ‘ipx_register_sysctl’ [-Wmissing-prototypes]
net/ipx/sysctl_net_ipx.c:38:6: warning: no previous prototype for ‘ipx_unregister_sysctl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

Changes since v1:
Move else block in the header file.

 include/net/net_namespace.h |    8 ++++++++
 net/ipx/af_ipx.c            |    9 +--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index da68c9a..991dcd9 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -162,6 +162,14 @@ extern struct list_head net_namespace_list;
 struct net *get_net_ns_by_pid(pid_t pid);
 struct net *get_net_ns_by_fd(int pid);
 
+#ifdef CONFIG_SYSCTL
+void ipx_register_sysctl(void);
+void ipx_unregister_sysctl(void);
+#else
+#define ipx_register_sysctl()
+#define ipx_unregister_sysctl()
+#endif
+
 #ifdef CONFIG_NET_NS
 void __put_net(struct net *net);
 
diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index 224d058..00b2a6d 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -54,17 +54,10 @@
 #include <net/sock.h>
 #include <net/datalink.h>
 #include <net/tcp_states.h>
+#include <net/net_namespace.h>
 
 #include <asm/uaccess.h>
 
-#ifdef CONFIG_SYSCTL
-extern void ipx_register_sysctl(void);
-extern void ipx_unregister_sysctl(void);
-#else
-#define ipx_register_sysctl()
-#define ipx_unregister_sysctl()
-#endif
-
 /* Configuration Variables */
 static unsigned char ipxcfg_max_hops = 16;
 static char ipxcfg_auto_select_primary;
-- 
1.7.9.5

