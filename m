Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab3DBXKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:10:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3DBWM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Lutomirski <luto@mit.edu>
Subject: [ 046/124] mac80211: prevent spurious HT/VHT downgrade message
Date: Tue,  2 Apr 2013 15:10:28 -0700
Message-Id: <20130402221109.536460965@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 586e01ededf9b713a1512dd658806791a7ca1a50 upstream.

Even when connecting to an AP that doesn't support VHT,
and even when the local device doesn't support it either,
the downgrade message gets printed. Suppress the message
if HT and/or VHT is disabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Andrew Lutomirski <luto@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3401,6 +3401,10 @@ ieee80211_determine_chantype(struct ieee
 	ret = 0;
 
 out:
+	/* don't print the message below for VHT mismatch if VHT is disabled */
+	if (ret & IEEE80211_STA_DISABLE_VHT)
+		vht_chandef = *chandef;
+
 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
 					IEEE80211_CHAN_DISABLED)) {
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {


