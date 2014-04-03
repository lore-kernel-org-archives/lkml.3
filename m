Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaDCQIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:08:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbaDCQIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:08:47 -0400
Date: Thu, 3 Apr 2014 12:08:43 -0400
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "David S. Miller" <davem@davemloft.net>,
        Mugunthan V N <mugunthanvnm@ti.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: cpts: Add includes for ETH_HLEN and VLAN_HLEN
 definitions
Message-ID: <20140403160843.GD15134@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_TI_CPTS is enabled, the ti_cpsw driver will fail to build with:

drivers/net/ethernet/ti/cpts.c: In function 'cpts_match':
drivers/net/ethernet/ti/cpts.c:266:12: error: 'ETH_HLEN' undeclared (first use in this function)
   offset = ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
            ^
drivers/net/ethernet/ti/cpts.c:266:12: note: each undeclared identifier is reported only once for each function it appears in
drivers/net/ethernet/ti/cpts.c:276:23: error: 'VLAN_HLEN' undeclared (first use in this function)
   offset = ETH_HLEN + VLAN_HLEN;
                       ^

Add includes of if_ether.h and if_vlan.h to bring in the appropriate defines.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 drivers/net/ethernet/ti/cpts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index a3bbf59eaafd..2a2f82ae0c1d 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -19,6 +19,8 @@
  */
 #include <linux/err.h>
 #include <linux/if.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
-- 
1.8.5.3

