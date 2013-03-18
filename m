Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3CREaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33373 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab3CREaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:02 -0400
Message-Id: <20130318042145.547863605@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:57 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 13/82] ath9k: fix RSSI dummy marker value
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit a3d63cadbad97671d740a9698acc2c95d1ca6e79 upstream.

RSSI is being stored internally as s8 in several places. The indication
of an unset RSSI value, ATH_RSSI_DUMMY_MARKER, was supposed to have been
set to 127, but ended up being set to 0x127 because of a code cleanup
mistake. This could lead to invalid signal strength values in a few
places.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -35,7 +35,7 @@
 #define WME_AC_BK   3
 #define WME_NUM_AC  4
 
-#define ATH_RSSI_DUMMY_MARKER   0x127
+#define ATH_RSSI_DUMMY_MARKER   127
 #define ATH_RSSI_LPF_LEN 		10
 #define RSSI_LPF_THRESHOLD		-20
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)


