Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934624Ab3DGX1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:27:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46604 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759308Ab3DGX07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:26:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Masatake YAMATO" <yamato@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.693726952@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [57/74] thermal: shorten too long mcast group name
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Masatake YAMATO <yamato@redhat.com>

[ Upstream commits 73214f5d9f33b79918b1f7babddd5c8af28dd23d
  and f1e79e208076ffe7bad97158275f1c572c04f5c7, the latter
  adds an assertion to genetlink to prevent this from happening
  again in the future. ]

The original name is too long.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/thermal.h | 2 +-
 net/netlink/genetlink.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 47b4a27..5ef859a 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -108,7 +108,7 @@ struct thermal_zone_device {
 /* Adding event notification support elements */
 #define THERMAL_GENL_FAMILY_NAME                "thermal_event"
 #define THERMAL_GENL_VERSION                    0x01
-#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_group"
+#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
 
 enum events {
 	THERMAL_AUX0,
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 482fa57..874f8ff 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -134,6 +134,7 @@ int genl_register_mc_group(struct genl_family *family,
 	int err = 0;
 
 	BUG_ON(grp->name[0] == '\0');
+	BUG_ON(memchr(grp->name, '\0', GENL_NAMSIZ) == NULL);
 
 	genl_lock();
 

