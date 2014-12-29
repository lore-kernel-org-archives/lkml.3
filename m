Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaL2BSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:18:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33132 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "kbuild test robot" <fengguang.wu@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.301260267@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 25/27] drivers/net: macvtap and tun depend on INET
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 drivers/net/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -143,6 +143,7 @@ config MACVLAN
 config MACVTAP
 	tristate "MAC-VLAN based tap driver (EXPERIMENTAL)"
 	depends on MACVLAN
+	depends on INET
 	help
 	  This adds a specialized tap character device driver that is based
 	  on the MAC-VLAN network interface, called macvtap. A macvtap device
@@ -195,6 +196,7 @@ config RIONET_RX_SIZE
 
 config TUN
 	tristate "Universal TUN/TAP device driver support"
+	depends on INET
 	select CRC32
 	---help---
 	  TUN/TAP provides packet reception and transmission for user space

