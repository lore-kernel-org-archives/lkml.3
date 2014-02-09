Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaBIQ5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:57:53 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41443 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaBIQ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:57:51 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2010/13=5D=20net=3A=20Move=20prototype=20declaration=20to=20header=20file=20include/net/datalink=2Eh=20from=20net/ipx/af=5Fipx=2Ec?=
Date: Sun,  9 Feb 2014 22:27:41 +0530
Message-Id: <b6f64a14cdcff5333ee2c83cefeca42f8e934b12.1391955925.git.rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
References: <6f029c895035908595957fb16ab445c82793c77d.1391955924.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of function to header file
include/net/datalink.h from net/ipx/af_ipx.c because they are used by
more than one file.

This eliminates the following warning in net/ipx/pe2.c:
net/ipx/pe2.c:20:24: warning: no previous prototype for ‘make_EII_client’ [-Wmissing-prototypes]
net/ipx/pe2.c:32:6: warning: no previous prototype for ‘destroy_EII_client’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/net/datalink.h |    2 ++
 net/ipx/af_ipx.c       |    4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/datalink.h b/include/net/datalink.h
index deb7ca7..93cb18f 100644
--- a/include/net/datalink.h
+++ b/include/net/datalink.h
@@ -15,4 +15,6 @@ struct datalink_proto {
 	struct list_head node;
 };
 
+struct datalink_proto *make_EII_client(void);
+void destroy_EII_client(struct datalink_proto *dl);
 #endif
diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index e5a00a9..224d058 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -52,6 +52,7 @@
 #include <net/p8022.h>
 #include <net/psnap.h>
 #include <net/sock.h>
+#include <net/datalink.h>
 #include <net/tcp_states.h>
 
 #include <asm/uaccess.h>
@@ -1977,9 +1978,6 @@ static struct notifier_block ipx_dev_notifier = {
 	.notifier_call	= ipxitf_device_event,
 };
 
-extern struct datalink_proto *make_EII_client(void);
-extern void destroy_EII_client(struct datalink_proto *);
-
 static const unsigned char ipx_8022_type = 0xE0;
 static const unsigned char ipx_snap_id[5] = { 0x0, 0x0, 0x0, 0x81, 0x37 };
 static const char ipx_EII_err_msg[] __initconst =
-- 
1.7.9.5

