Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaFEUtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:49:07 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56903 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaFEUs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:48:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: [PATCH 5/5] staging: rtl8712, rtl8712: avoid lots of build warnings
Date: Thu,  5 Jun 2014 22:48:15 +0200
Message-Id: <1402001295-1980118-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
References: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:850BIissjwNJ/wfp0FfsH16XSmfee+RFwQwRbCIazuV
 pI/R4L9X0YDp1t0OpxkpumBixjldJOtYIRQofQMU25xRMpAHGi
 u8VlZmzBE74G/kj0EMgUFka/iLogD67Q4Y0zVGgZSwXoTqQTAR
 cSwUTNg6jfGyQQRWCNjk2tHZMIHRQtKSJ1wMVHOSsThMUkoAZk
 pXPUdi7nQI5hyCv7s0mhrhE6I+DorK1CTheGG6UmWnvXXoT9N2
 6RUThv8oHiT/7ISQiF6hd+ZBUtH0ivZDQLc4l3ceekJM74X7MU
 di1Abloa5t/0oL7ZRn2otjuPylsR4mCsDV+BrGcUPi3/V5vbbP
 q8T50VVd3kCdh0kTzUuQCWWICVgnqAMTyn6No7gki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtl8712 driver has an 'extern inline' function that contains an
'if', which causes lots of warnings with CONFIG_PROFILE_ALL_BRANCHES
overriding the definition of 'if':

drivers/staging/rtl8712/ieee80211.h:759:229: warning: '______f' is static but declared in inline function 'ieee80211_get_hdrlen' which is not static [enabled by default]

This changes the driver to use 'static inline' instead, which happens
to be the correct annotation anyway.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211.h | 10 +++++-----
 drivers/staging/rtl8712/ieee80211.h            |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index e0aa069..1040bab 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -2238,7 +2238,7 @@ static inline void *ieee80211_priv(struct net_device *dev)
 	return ((struct ieee80211_device *)netdev_priv(dev))->priv;
 }
 
-extern inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
+static inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
 {
 	/* Single white space is for Linksys APs */
 	if (essid_len == 1 && essid[0] == ' ')
@@ -2254,7 +2254,7 @@ extern inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
 	return 1;
 }
 
-extern inline int ieee80211_is_valid_mode(struct ieee80211_device *ieee, int mode)
+static inline int ieee80211_is_valid_mode(struct ieee80211_device *ieee, int mode)
 {
 	/*
 	 * It is possible for both access points and our device to support
@@ -2280,7 +2280,7 @@ extern inline int ieee80211_is_valid_mode(struct ieee80211_device *ieee, int mod
 	return 0;
 }
 
-extern inline int ieee80211_get_hdrlen(u16 fc)
+static inline int ieee80211_get_hdrlen(u16 fc)
 {
 	int hdrlen = IEEE80211_3ADDR_LEN;
 
@@ -2564,12 +2564,12 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee);
 
 extern const long ieee80211_wlan_frequencies[];
 
-extern inline void ieee80211_increment_scans(struct ieee80211_device *ieee)
+static inline void ieee80211_increment_scans(struct ieee80211_device *ieee)
 {
 	ieee->scans++;
 }
 
-extern inline int ieee80211_get_scans(struct ieee80211_device *ieee)
+static inline int ieee80211_get_scans(struct ieee80211_device *ieee)
 {
 	return ieee->scans;
 }
diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index da4000e..8269be8 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -734,7 +734,7 @@ enum ieee80211_state {
 #define IEEE_G            (1<<2)
 #define IEEE_MODE_MASK    (IEEE_A|IEEE_B|IEEE_G)
 
-extern inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
+static inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
 {
 	/* Single white space is for Linksys APs */
 	if (essid_len == 1 && essid[0] == ' ')
@@ -748,7 +748,7 @@ extern inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
 	return 1;
 }
 
-extern inline int ieee80211_get_hdrlen(u16 fc)
+static inline int ieee80211_get_hdrlen(u16 fc)
 {
 	int hdrlen = 24;
 
-- 
1.8.3.2

