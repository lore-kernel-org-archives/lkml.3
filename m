Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaBGMPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:15:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42233 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaBGLvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: ZHAO Gang <gamerh2o@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 172/233] b43: fix the wrong assignment of status.freq in b43_rx()
Date: Fri,  7 Feb 2014 11:46:31 +0000
Message-Id: <1391773652-25214-173-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZHAO Gang <gamerh2o@gmail.com>

commit 64e5acb09ca6b50c97299cff9ef51299470b29f2 upstream.

Use the right function to update frequency value.

If rx skb is probe response or beacon, the wrong frequency value can
cause problem that bss info can't be updated when it should be.

Fixes: 8318d78a44d4 ("cfg80211 API for channels/bitrates, mac80211
and driver conversion")
Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 8cb206a..e85d34b 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -821,10 +821,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		 * channel number in b43. */
 		if (chanstat & B43_RX_CHAN_5GHZ) {
 			status.band = IEEE80211_BAND_5GHZ;
-			status.freq = b43_freq_to_channel_5ghz(chanid);
+			status.freq = b43_channel_to_freq_5ghz(chanid);
 		} else {
 			status.band = IEEE80211_BAND_2GHZ;
-			status.freq = b43_freq_to_channel_2ghz(chanid);
+			status.freq = b43_channel_to_freq_2ghz(chanid);
 		}
 		break;
 	default:
-- 
1.8.3.2

