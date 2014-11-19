Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaKSQSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:18:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbaKSQSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:18:52 -0500
Date: Wed, 19 Nov 2014 18:18:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, davem@davemloft.net,
        Jason Wang <jasowang@redhat.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Tom Herbert <therbert@google.com>, Ben Hutchings <ben@decadent.org.uk>,
        Masatake YAMATO <yamato@redhat.com>, Xi Wang <xii@google.com>,
        netdev@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH 1/3] tun: move internal flag defines out of uapi
Message-ID: <1416413891-29562-2-git-send-email-mst@redhat.com>
References: <1416413891-29562-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416413891-29562-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TUN_ flags are internal and never exposed
to userspace. Any application using it is almost
certainly buggy.

Move them out to tun.c, we'll remove them in follow-up patches.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/if_tun.h | 14 --------------
 drivers/net/tun.c           | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index e9502dd..b82c276 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -23,20 +23,6 @@
 /* Read queue size */
 #define TUN_READQ_SIZE	500
 
-/* TUN device flags */
-#define TUN_TUN_DEV 	0x0001	
-#define TUN_TAP_DEV	0x0002
-#define TUN_TYPE_MASK   0x000f
-
-#define TUN_FASYNC	0x0010
-#define TUN_NOCHECKSUM	0x0020
-#define TUN_NO_PI	0x0040
-/* This flag has no real effect */
-#define TUN_ONE_QUEUE	0x0080
-#define TUN_PERSIST 	0x0100	
-#define TUN_VNET_HDR 	0x0200
-#define TUN_TAP_MQ      0x0400
-
 /* Ioctl defines */
 #define TUNSETNOCSUM  _IOW('T', 200, int) 
 #define TUNSETDEBUG   _IOW('T', 201, int) 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2e18ddd..81735f5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -103,6 +103,20 @@ do {								\
 } while (0)
 #endif
 
+/* TUN device flags */
+#define TUN_TUN_DEV 	0x0001
+#define TUN_TAP_DEV	0x0002
+#define TUN_TYPE_MASK   0x000f
+
+#define TUN_FASYNC	0x0010
+#define TUN_NOCHECKSUM	0x0020
+#define TUN_NO_PI	0x0040
+/* This flag has no real effect */
+#define TUN_ONE_QUEUE	0x0080
+#define TUN_PERSIST 	0x0100
+#define TUN_VNET_HDR 	0x0200
+#define TUN_TAP_MQ      0x0400
+
 #define GOODCOPY_LEN 128
 
 #define FLT_EXACT_COUNT 8
-- 
MST

