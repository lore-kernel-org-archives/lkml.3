Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbaLVSKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:10:22 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62532 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957AbaLVSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:10:20 -0500
Message-ID: <1419271817.2317.12.camel@tiscali.nl>
Subject: [PATCH RFC] ipw2200: select CFG80211_WEXT
From: Paul Bolle <pebolle@tiscali.nl>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2014 19:10:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.8 (3.12.8-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2014 18:10:17.0843 (UTC) FILETIME=[8AAAAC30:01D01E12]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable")
made it impossible to depend on CFG80211_WEXT. It does still allow to
select that symbol. (Yes, the commit summary is confusing.)

So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
built again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Johannes,

Building v3.19-rc1 for an outdated ThinkPad X41 left me without the
ipw2200 driver. It turns out this trivial patch is all that's needed to
make ipw2200 buildable again.

(A similar patch would be needed for the drivers behind Kconfig symbol
HERMES. Ie, orinico and friends.) 

I must admit that I do not fully understand your commit. (How was
CFG80211_WEXT "marked for deprecation and removal for a little more than
two years"?) There's some terminology confusion: what you call "select"
I tend to call "set". Anyhow, your commit basically disables building
ipw2200 (and apparently orinoco and friends)?

Was that your intention?
 
 drivers/net/wireless/ipw2x00/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 91c0cb3c368e..21de4fe6cf2d 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -65,7 +65,8 @@ config IPW2100_DEBUG
 
 config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on PCI && CFG80211 && CFG80211_WEXT
+	depends on PCI && CFG80211
+	select CFG80211_WEXT
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
-- 
2.1.0

