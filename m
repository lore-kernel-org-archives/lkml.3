Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349AbaEKTto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:49:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbaEKTXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Braun <michael-dev@fami-braun.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 43/83] mac80211: fix WPA with VLAN on AP side with ps-sta again
Date: Sun, 11 May 2014 21:19:44 +0200
Message-Id: <20140511191912.808217268@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Braun <michael-dev@fami-braun.de>

commit 112c44b2df0984121a52fbda89425843b8e1a457 upstream.

commit de74a1d9032f4d37ea453ad2a647e1aff4cd2591
  "mac80211: fix WPA with VLAN on AP side with ps-sta"
fixed an issue where queued multicast packets would
be sent out encrypted with the key of an other bss.

commit "7cbf9d017dbb5e3276de7d527925d42d4c11e732"
  "mac80211: fix oops on mesh PS broadcast forwarding"
essentially reverted it, because vif.type cannot be AP_VLAN
due to the check to vif.type in ieee80211_get_buffered_bc before.

As the later commit intended to fix the MESH case, fix it
by checking for IFTYPE_AP instead of IFTYPE_AP_VLAN.

Fixes: 7cbf9d017dbb ("mac80211: fix oops on mesh PS broadcast forwarding")
Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2909,7 +2909,7 @@ ieee80211_get_buffered_bc(struct ieee802
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 		if (!ieee80211_tx_prepare(sdata, &tx, skb))
 			break;


