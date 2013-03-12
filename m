Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779Ab3CLWo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:44:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857Ab3CLWoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 14/40] ath9k: fix RSSI dummy marker value
Date: Tue, 12 Mar 2013 15:43:35 -0700
Message-Id: <20130312223213.016372414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


