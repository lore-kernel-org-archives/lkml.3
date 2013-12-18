Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab3LRVev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:34:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3LRVNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Copeland <me@bobcopeland.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 055/118] Revert "mac80211: allow disable power save in mesh"
Date: Wed, 18 Dec 2013 13:11:32 -0800
Message-Id: <20131218211221.023028144@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 2d3db210860f1df099a35b1dd54cca35454e0361 upstream.

This reverts commit ee1f668136b2fb6640ee2d54c2a525ea41f98211.

The aformentioned commit added a check to allow
'iw wlan0 set power_save off' to work for mesh interfaces.

However, this is problematic because it also allows
'iw wlan0 set power_save on', which will crash in short order
because all of the subsequent code manipulates sdata->u.mgd.

The power-saving states for mesh interfaces can be manipulated
through the mesh config, e.g:
'iw wlan0 set mesh_param mesh_power_save=active' (which,
despite the name, actualy disables power saving since the
setting refers to the type of sleep the interface undergoes).

Fixes: ee1f668136b2 ("mac80211: allow disable power save in mesh")
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2386,8 +2386,7 @@ static int ieee80211_set_power_mgmt(stru
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))


