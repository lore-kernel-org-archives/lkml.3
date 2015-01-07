Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828AbbAGCzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:55:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbbAGBwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.18 49/84] mac80211: avoid using uninitialized stack data
Date: Tue,  6 Jan 2015 17:49:52 -0800
Message-Id: <20150107014030.599718231@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jes Sorensen <Jes.Sorensen@redhat.com>

commit 7e6225a1604d0c6aa4140289bf5761868ffc9c83 upstream.

Avoid a case where we would access uninitialized stack data if the AP
advertises HT support without 40MHz channel support.

Fixes: f3000e1b43f1 ("mac80211: fix broken use of VHT/20Mhz with some APs")
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -174,6 +174,7 @@ ieee80211_determine_chantype(struct ieee
 	if (!(ht_cap->cap_info &
 	      cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40))) {
 		ret = IEEE80211_STA_DISABLE_40MHZ;
+		vht_chandef = *chandef;
 		goto out;
 	}
 


