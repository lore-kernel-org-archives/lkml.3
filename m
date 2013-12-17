Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3LQJ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:26:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53341 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3LQJ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:26:30 -0500
X-AuditID: cbfee61b-b7fbf6d0000051a3-bf-52b018bfc848
From: Karol Lewandowski <k.lewandowsk@samsung.com>
To: netdev@vger.kernel.org
Cc: kyungmin.park@samsung.com, lennart@poettering.net,
        linux-kernel@vger.kernel.org,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH] net: Make it possible to set defaults for net.core.[rw]mem_max
 parameters
Date: Tue, 17 Dec 2013 10:25:53 +0100
Message-id: <1387272353-3560-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.8.4.rc3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQd39EhuCDPr2GVk0fprLbHG26Q27
	xbe+Z4wWl3fNYbM4tkDMgdXjyvr3jB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcebjEcaC
	Fr6KLx/nsjYw7uDuYuTkkBAwkZi48BkThC0mceHeerYuRi4OIYHpjBK7zj1ngnA6mCTe9z1g
	A6liEzCS+HZoAzOILSIgJfFxx3Z2EJtZoJlRYkuTdBcjB4ewQIzErtPWIGEWAVWJTWv+sYDY
	vALuEo+mfmaDWKYksfDUNtYJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgT7/pn0
	DsZVDRaHGAU4GJV4eDlmrw8SYk0sK67MPcQowcGsJMLLUgAU4k1JrKxKLcqPLyrNSS0+xCjN
	waIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwDjVd+Ohs65/eKeufxhr0Cw6d9vX4ENnPlk8
	cGgQdEx+Ot/PWOeT/6LnPm9f31ywwDX69EPRjalK0lfOKjqKv/3s9mX9pz+bGIzmR58wNfpp
	dNrJzKtvtXtpVc9xB535l7d3P0hpvNkSd9iDX4lfufbYod/H/YPOXeid/0uNpX6CidY/1TKG
	7GwlluKMREMt5qLiRAATy4/2+QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default limits are quite low even for today's embedded hardware.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
---
 net/Kconfig      | 1 +
 net/core/Kconfig | 7 +++++++
 net/core/sock.c  | 5 ++---
 3 files changed, 10 insertions(+), 3 deletions(-)
 create mode 100644 net/core/Kconfig

diff --git a/net/Kconfig b/net/Kconfig
index d334678..75b7478 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -46,6 +46,7 @@ config COMPAT_NETLINK_MESSAGES
 
 menu "Networking options"
 
+source "net/core/Kconfig"
 source "net/packet/Kconfig"
 source "net/unix/Kconfig"
 source "net/xfrm/Kconfig"
diff --git a/net/core/Kconfig b/net/core/Kconfig
new file mode 100644
index 0000000..91aa793
--- /dev/null
+++ b/net/core/Kconfig
@@ -0,0 +1,7 @@
+config SK_MEM_PACKETS
+        int "Default maximum socket queue depth (packets)" if EMBEDDED
+        range 128 65536
+        default 256
+        ---help---
+          This config option allows to set defaults for net.core.[rw]mem_max
+          parameters
diff --git a/net/core/sock.c b/net/core/sock.c
index 5393b4b..6f33bd6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -259,10 +259,9 @@ static struct lock_class_key af_callback_keys[AF_MAX];
  * platforms.  This makes socket queueing behavior and performance
  * not depend upon such differences.
  */
-#define _SK_MEM_PACKETS		256
 #define _SK_MEM_OVERHEAD	SKB_TRUESIZE(256)
-#define SK_WMEM_MAX		(_SK_MEM_OVERHEAD * _SK_MEM_PACKETS)
-#define SK_RMEM_MAX		(_SK_MEM_OVERHEAD * _SK_MEM_PACKETS)
+#define SK_WMEM_MAX		(_SK_MEM_OVERHEAD * CONFIG_SK_MEM_PACKETS)
+#define SK_RMEM_MAX		(_SK_MEM_OVERHEAD * CONFIG_SK_MEM_PACKETS)
 
 /* Run time adjustable parameters. */
 __u32 sysctl_wmem_max __read_mostly = SK_WMEM_MAX;
-- 
1.8.4.rc3

