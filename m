Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612Ab3DDQBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:01:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41470 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761807Ab3DDQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:01:42 -0400
Date: Fri, 5 Apr 2013 00:01:30 +0800
From: Wang YanQing <udknight@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lib80211: make lib80211 can be enabled independently
Message-ID: <20130404160130.GA2577@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current we can only enable lib80211 by enable a driver
in tree use it which will select it, but some out tree's
drivers also use it, so I think it has sense to make lib80211
can be enabled independently.

A example of the out tree's drivers use lib80211 is:
hybird driver(wl) for Broadcom Corporation BCM43225 802.11b/g/n

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 net/wireless/Kconfig | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 16d08b3..6e83f0a 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -140,22 +140,34 @@ config CFG80211_WEXT
 	  extensions with cfg80211-based drivers.
 
 config LIB80211
-	tristate
+	tristate "common routines used by IEEE802.11 wireless LAN drivers"
 	default n
 	help
 	  This options enables a library of common routines used
 	  by IEEE802.11 wireless LAN drivers.
 
-	  Drivers should select this themselves if needed.
+	  Drivers could select this themselves if needed.
 
 config LIB80211_CRYPT_WEP
-	tristate
+	tristate "host-based WEP encryption implementation for lib80211"
+	depends on LIB80211
+	default n
+	---help---
+	   host-based WEP encryption implementation for lib80211
 
 config LIB80211_CRYPT_CCMP
-	tristate
+	tristate "host-based CCMP encryption implementation for lib80211"
+	depends on LIB80211
+	default n
+	---help---
+	   host-based CCMP encryption implementation for lib80211
 
 config LIB80211_CRYPT_TKIP
-	tristate
+	tristate "host-based TKIP encryption implementation for lib80211"
+	depends on LIB80211
+	default n
+	---help---
+	    host-based TKIP encryption implementation for lib80211
 
 config LIB80211_DEBUG
 	bool "lib80211 debugging messages"
-- 
1.7.12.4.dirty
