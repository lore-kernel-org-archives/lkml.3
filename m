Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3J2SOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:14:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3J2SJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Healy <cphealy@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 39/81] resubmit bridge: fix message_age_timer calculation
Date: Tue, 29 Oct 2013 11:04:00 -0700
Message-Id: <1383069882-11437-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Healy <cphealy@gmail.com>

[ Upstream commit 9a0620133ccce9dd35c00a96405c8d80938c2cc0 ]

This changes the message_age_timer calculation to use the BPDU's max age as
opposed to the local bridge's max age.  This is in accordance with section
8.6.2.3.2 Step 2 of the 802.1D-1998 sprecification.

With the current implementation, when running with very large bridge
diameters, convergance will not always occur even if a root bridge is
configured to have a longer max age.

Tested successfully on bridge diameters of ~200.

Signed-off-by: Chris Healy <cphealy@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_stp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index b01849a..e26f712 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -209,7 +209,7 @@ static void br_record_config_information(struct net_bridge_port *p,
 	p->designated_age = jiffies - bpdu->message_age;
 
 	mod_timer(&p->message_age_timer, jiffies
-		  + (p->br->max_age - bpdu->message_age));
+		  + (bpdu->max_age - bpdu->message_age));
 }
 
 /* called under bridge lock */
-- 
1.8.1.2

