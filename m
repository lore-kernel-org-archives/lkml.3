Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaKKLpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:45:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57529 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaKKLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 085/170] drivers/net: macvtap and tun depend on INET
Date: Tue, 11 Nov 2014 11:07:24 +0000
Message-Id: <1415704129-12709-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit de11b0e8c569b96c2cf6a811e3805b7aeef498a3 upstream.

These drivers now call ipv6_proxy_select_ident(), which is defined
only if CONFIG_INET is enabled.  However, they have really depended
on CONFIG_INET for as long as they have allowed sending GSO packets
from userland.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: f43798c27684 ("tun: Allow GSO using virtio_net_hdr")
Fixes: b9fb9ee07e67 ("macvtap: add GSO/csum offload support")
Fixes: 5188cd44c55d ("drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 89402c3b64f8..3fdfe317a6c5 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -135,6 +135,7 @@ config MACVLAN
 config MACVTAP
 	tristate "MAC-VLAN based tap driver"
 	depends on MACVLAN
+	depends on INET
 	help
 	  This adds a specialized tap character device driver that is based
 	  on the MAC-VLAN network interface, called macvtap. A macvtap device
@@ -200,6 +201,7 @@ config RIONET_RX_SIZE
 
 config TUN
 	tristate "Universal TUN/TAP device driver support"
+	depends on INET
 	select CRC32
 	---help---
 	  TUN/TAP provides packet reception and transmission for user space
-- 
2.1.0

