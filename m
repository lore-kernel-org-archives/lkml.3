Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaKRPZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:25:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbaKROJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 016/206] drivers/net: macvtap and tun depend on INET
Date: Tue, 18 Nov 2014 15:06:11 +0100
Message-Id: <0e8361ae716b89ea54a97050fbf9d74f6dc4292d.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
---
 drivers/net/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b45b240889f5..367aabc6fd48 100644
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
2.1.3

