Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbaEKTXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:23:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075AbaEKTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 42/83] mac80211: fix potential use-after-free
Date: Sun, 11 May 2014 21:19:43 +0200
Message-Id: <20140511191912.713251061@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d2722f8b87fb172ff2f31d3a2816b31d58678d40 upstream.

The bss struct might be freed in ieee80211_rx_bss_put(),
so we shouldn't use it afterwards.

Fixes: 817cee7675237 ("mac80211: track AP's beacon rate and give it to the driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2708,8 +2708,8 @@ static void ieee80211_rx_bss_info(struct
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
 					channel);
 	if (bss) {
-		ieee80211_rx_bss_put(local, bss);
 		sdata->vif.bss_conf.beacon_rate = bss->beacon_rate;
+		ieee80211_rx_bss_put(local, bss);
 	}
 }
 


