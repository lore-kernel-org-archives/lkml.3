Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab3DBWvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:51:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab3DBWvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:51:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Masatake YAMATO <yamato@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 46/56] thermal: shorten too long mcast group name
Date: Tue,  2 Apr 2013 15:50:13 -0700
Message-Id: <20130402224717.173198694@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Masatake YAMATO <yamato@redhat.com>

[ Upstream commits 73214f5d9f33b79918b1f7babddd5c8af28dd23d
  and f1e79e208076ffe7bad97158275f1c572c04f5c7, the latter
  adds an assertion to genetlink to prevent this from happening
  again in the future. ]

The original name is too long.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/thermal.h |    2 +-
 net/netlink/genetlink.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -130,7 +130,7 @@ struct thermal_zone_device {
 /* Adding event notification support elements */
 #define THERMAL_GENL_FAMILY_NAME                "thermal_event"
 #define THERMAL_GENL_VERSION                    0x01
-#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_group"
+#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
 
 enum events {
 	THERMAL_AUX0,
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -134,6 +134,7 @@ int genl_register_mc_group(struct genl_f
 	int err = 0;
 
 	BUG_ON(grp->name[0] == '\0');
+	BUG_ON(memchr(grp->name, '\0', GENL_NAMSIZ) == NULL);
 
 	genl_lock();
 


