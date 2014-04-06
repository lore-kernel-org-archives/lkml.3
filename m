Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaDFPs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:48:28 -0400
Received: from ms-10.1blu.de ([178.254.4.101]:33216 "EHLO ms-10.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbaDFPsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:48:24 -0400
From: Jonas Hahnfeld <hahnjo@hahnjo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ana Rey <anarey@gmail.com>, Jonas Hahnfeld <hahnjo@hahnjo.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@gnumonks.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        Teodora Baluta <teobaluta@gmail.com>,
        Dan LaManna <dan.lamanna@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8187se: Fix warning symbol should be static
Date: Sun,  6 Apr 2014 17:46:04 +0200
Message-Id: <1396799183-7412-1-git-send-email-hahnjo@hahnjo.de>
X-Mailer: git-send-email 1.9.1
X-Con-Id: 154395
X-Con-U: 0-hahnjo
X-Originating-IP: 79.233.157.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves some sparse warnings about "symbol [...] was not
declared. Should it be static?" by including the correct header files.

Signed-off-by: Jonas Hahnfeld <hahnjo@hahnjo.de>
---
Tested by compile only

 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c      | 1 +
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c | 1 +
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c  | 1 +
 drivers/staging/rtl8187se/r8180_wx.c                       | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index 101f0c0..03462c3 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -19,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 
+#include "../r8180.h"
 #include "ieee80211.h"
 
 MODULE_AUTHOR("Jouni Malinen");
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 4fe2538..7eae3d9 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -21,6 +21,7 @@
 #include <linux/string.h>
 #include <linux/wireless.h>
 
+#include "../r8180.h"
 #include "ieee80211.h"
 
 #include <linux/crypto.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
index f253672..288f86c 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -17,6 +17,7 @@
 #include <linux/skbuff.h>
 #include <linux/string.h>
 
+#include "../r8180.h"
 #include "ieee80211.h"
 
 #include <linux/crypto.h>
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index b552491..57bf01f 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -20,6 +20,7 @@
 
 #include "r8180.h"
 #include "r8180_hw.h"
+#include "r8180_wx.h"
 
 #include <net/iw_handler.h>
 #include "ieee80211/dot11d.h"
-- 
1.9.1

