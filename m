Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3LRVgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:36:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3LRVN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 052/118] cfg80211: disable 5/10 MHz support for all drivers
Date: Wed, 18 Dec 2013 13:11:29 -0800
Message-Id: <20131218211220.941183257@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 9f16d84ad73ea04145a5dc85c8f1067915b37eea upstream.

Due to nl80211 API breakage, 5/10 MHz support is broken for
all drivers. Fixing it requires adding new API, but that
can't be done as a bugfix commit since that would require
either updating all APIs in the trees needing the bugfix or
cause different kernels to have incompatible API.

Therefore, just disable 5/10 MHz support for all drivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -451,6 +451,9 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
+	/* support for 5/10 MHz is broken due to nl80211 API mess - disable */
+	wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_5_10_MHZ;
+
 #ifdef CONFIG_PM
 	if (WARN_ON(wiphy->wowlan &&
 		    (wiphy->wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&


