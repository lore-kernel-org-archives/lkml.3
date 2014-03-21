Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966919AbaCUArr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:47:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965780AbaCUAIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Nelson <tim.l.nelson@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 16/85] mac80211: fix association to 20/40 MHz VHT networks
Date: Thu, 20 Mar 2014 17:09:19 -0700
Message-Id: <20140321000600.928581500@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit cb664981607a6b5b3d670ad57bbda893b2528d96 upstream.

When a VHT network uses 20 or 40 MHz as per the HT operation
information, the channel center frequency segment 0 field in
the VHT operation information is reserved, so ignore it.

This fixes association with such networks when the AP puts 0
into the field, previously we'd disconnect due to an invalid
channel with the message
wlan0: AP VHT information is invalid, disable VHT

Fixes: f2d9d270c15ae ("mac80211: support VHT association")
Reported-by: Tim Nelson <tim.l.nelson@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -310,6 +310,7 @@ ieee80211_determine_chantype(struct ieee
 	switch (vht_oper->chan_width) {
 	case IEEE80211_VHT_CHANWIDTH_USE_HT:
 		vht_chandef.width = chandef->width;
+		vht_chandef.center_freq1 = chandef->center_freq1;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80MHZ:
 		vht_chandef.width = NL80211_CHAN_WIDTH_80;


