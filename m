Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaLOTuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:50:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLOT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 12/96] drivers/net: macvtap and tun depend on INET
Date: Mon, 15 Dec 2014 11:25:32 -0800
Message-Id: <1418671616-25482-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit de11b0e8c569b96c2cf6a811e3805b7aeef498a3 ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b45b240..367aabc 100644
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
@@ -205,6 +206,7 @@ config RIONET_RX_SIZE
 
 config TUN
 	tristate "Universal TUN/TAP device driver support"
+	depends on INET
 	select CRC32
 	---help---
 	  TUN/TAP provides packet reception and transmission for user space
-- 
1.9.1

