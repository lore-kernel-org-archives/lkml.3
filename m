Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3FEVfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3FEVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [ 015/127] mac80211: fix AP-mode frame matching
Date: Wed,  5 Jun 2013 14:33:02 -0700
Message-Id: <20130605213219.777712779@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 2b9ccd4e4308272e5aec614b77c5385e7ec2ec90 upstream.

In AP mode, ignore frames with mis-matched BSSID that aren't
multicast or sent to the correct destination. This fixes
reporting public action frames to userspace multiple times
on multiple virtual AP interfaces.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3032,6 +3032,9 @@ static int prepare_for_handlers(struct i
 			 * and location updates. Note that mac80211
 			 * itself never looks at these frames.
 			 */
+			if (!multicast &&
+			    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+				return 0;
 			if (ieee80211_is_public_action(hdr, skb->len))
 				return 1;
 			if (!ieee80211_is_beacon(hdr->frame_control))


