Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaLPNFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:05:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaLPNFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:05:11 -0500
Date: Tue, 16 Dec 2014 15:05:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-api@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 2/5] if_tun: add TUNSETVNETLE/TUNGETVNETLE
Message-ID: <1418732988-3535-3-git-send-email-mst@redhat.com>
References: <1418732988-3535-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418732988-3535-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ifreq flags field is only 16 bit wide, so setting IFF_VNET_LE there has
no effect:
doesn't fit in two bytes.

The tests passed apparently because they have an even number of bugs,
all cancelling out.

Luckily we didn't release a kernel with this flag, so it's
not too late to fix this.

Add TUNSETVNETLE/TUNGETVNETLE to really achieve the purpose
of IFF_VNET_LE.

This has an added benefit that if we ever want a BE flag,
we won't have to deal with weird configurations like
setting both LE and BE at the same time.

IFF_VNET_LE will be dropped in a follow-up patch.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/if_tun.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 18b2403..274630c 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -48,6 +48,8 @@
 #define TUNSETQUEUE  _IOW('T', 217, int)
 #define TUNSETIFINDEX	_IOW('T', 218, unsigned int)
 #define TUNGETFILTER _IOR('T', 219, struct sock_fprog)
+#define TUNSETVNETLE _IOW('T', 220, int)
+#define TUNGETVNETLE _IOR('T', 221, int)
 
 /* TUNSETIFF ifr flags */
 #define IFF_TUN		0x0001
-- 
MST

