Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbaK0Mdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:33:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbaK0Mdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:33:31 -0500
Date: Thu, 27 Nov 2014 14:33:16 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        netdev@vger.kernel.org, linux-api@vger.kernel.org
Subject: [PATCH v5 38/45] tun: add VNET_LE flag
Message-ID: <1417091078-24611-39-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio 1.0 modified virtio net header format,
making all fields little endian.

Users can tweak header format before submitting it to tun,
but this means more data copies where none were necessary.
And if the iovec is in RO memory, this means we might
need to split iovec also means we might in theory overflow
iovec max size.

This patch adds a simpler way for applications to handle this,
using new "little endian" flag in tun.
As a result, tun simply byte-swaps header fields as appropriate.
This is a NOP on LE architectures.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/if_tun.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 277a260..18b2403 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -57,6 +57,7 @@
 #define IFF_ONE_QUEUE	0x2000
 #define IFF_VNET_HDR	0x4000
 #define IFF_TUN_EXCL	0x8000
+#define IFF_VNET_LE	0x10000
 #define IFF_MULTI_QUEUE 0x0100
 #define IFF_ATTACH_QUEUE 0x0200
 #define IFF_DETACH_QUEUE 0x0400
-- 
MST

