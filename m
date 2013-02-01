Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3BANK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:10:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:44902 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab3BANKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:10:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 37/89] ath9k: remove the WARN_ON that triggers if generating a beacon fails
Date: Fri,  1 Feb 2013 14:07:52 +0100
Message-Id: <20130201130210.190538413@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 3adcf20afb585993ffee24de36d1975f6b26b120 upstream.

During teardown, mac80211 will not return a new beacon. This is normal and
handled properly in the driver, so there's no need to spam the user with a kernel
warning here.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -360,7 +360,6 @@ void ath9k_beacon_tasklet(unsigned long
 		return;
 
 	bf = ath9k_beacon_generate(sc->hw, vif);
-	WARN_ON(!bf);
 
 	if (sc->beacon.bmisscnt != 0) {
 		ath_dbg(common, BSTUCK, "resume beacon xmit after %u misses\n",


