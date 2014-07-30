Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaG3CBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:01:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaG3Bt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 28/29] nl80211: move set_qos_map command into split state
Date: Tue, 29 Jul 2014 18:49:03 -0700
Message-Id: <20140730014810.517755068@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 02df00eb0019e7d15a1fcddebe4d020226c1ccda upstream.

The non-split wiphy state shouldn't be increased in size
so move the new set_qos_map command into the split if
statement.

Fixes: fa9ffc745610 ("cfg80211: Add support for QoS mapping")
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1450,18 +1450,17 @@ static int nl80211_send_wiphy(struct cfg
 		}
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
+#ifdef CONFIG_NL80211_TESTMODE
+		CMD(testmode_cmd, TESTMODE);
+#endif
 		if (state->split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
 			if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
 				CMD(channel_switch, CHANNEL_SWITCH);
+			CMD(set_qos_map, SET_QOS_MAP);
 		}
-		CMD(set_qos_map, SET_QOS_MAP);
-
-#ifdef CONFIG_NL80211_TESTMODE
-		CMD(testmode_cmd, TESTMODE);
-#endif
-
+		/* add into the if now */
 #undef CMD
 
 		if (dev->ops->connect || dev->ops->auth) {


