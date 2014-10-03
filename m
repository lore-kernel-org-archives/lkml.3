Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaJCWdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:33:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667AbaJCWYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Luciano Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 112/143] Revert "mac80211: disable uAPSD if all ACs are under ACM"
Date: Fri,  3 Oct 2014 14:35:07 -0700
Message-Id: <20141003213317.860472840@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit bb512ad0732232f1d2693bb68f31a76bed8f22ae upstream.

This reverts commit 24aa11ab8ae03292d38ec0dbd9bc2ac49fe8a6dd.

That commit was wrong since it uses data that hasn't even been set
up yet, but might be a hold-over from a previous connection.

Additionally, it seems like a driver-specific workaround that
shouldn't have been in mac80211 to start with.

Fixes: 24aa11ab8ae0 ("mac80211: disable uAPSD if all ACs are under ACM")
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4395,8 +4395,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 	rcu_read_unlock();
 
 	if (bss->wmm_used && bss->uapsd_supported &&
-	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD) &&
-	    sdata->wmm_acm != 0xff) {
+	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
 		assoc_data->uapsd = true;
 		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 	} else {


