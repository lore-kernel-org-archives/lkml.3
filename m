Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3FPWO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:14:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46430 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688Ab3FPWJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sujith Manoharan" <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.113375664@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [68/83] ath9k: Disable PowerSave by default
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 73c79617596b89a3693ff0d89d42bcd5ddedcf15 upstream.

Almost all the DMA issues which have plagued ath9k (in station mode)
for years are related to PS. Disabling PS usually "fixes" the user's
connection stablility. Reports of DMA problems are still trickling in
and are sitting in the kernel bugzilla. Until the PS code in ath9k is
given a thorough review, disbale it by default. The slight increase
in chip power consumption is a small price to pay for improved link
stability.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -691,8 +691,7 @@ void ath9k_set_hw_capab(struct ath_softc
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	if (AR_SREV_5416(sc->sc_ah))
-		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 

