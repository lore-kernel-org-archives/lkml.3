Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbbA2BcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:32:11 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59343 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbbA2BcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:32:09 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ganesan Ramalingam <ganesanr@broadcom.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Toby Smith <toby@tismith.id.au>, Chaitanya Hazarey <c@24.io>,
        Mostyn Bramley-Moore <mbmcode@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: netlogic: xlr_net: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:48:23 +0100
Message-Id: <1422485303-11349-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/netlogic/xlr_net.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index 5ecb3e6..0d9308a 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -814,9 +814,8 @@ static void xlr_gmac_link_adjust(struct net_device *ndev)
 {
 	struct xlr_net_priv *priv = netdev_priv(ndev);
 	struct phy_device *phydev = priv->mii_bus->phy_map[priv->phy_addr];
-	u32 intreg;
 
-	intreg = xlr_nae_rdreg(priv->base_addr, R_INTREG);
+	xlr_nae_rdreg(priv->base_addr, R_INTREG);
 	if (phydev->link) {
 		if (phydev->speed != priv->phy_speed) {
 			xlr_set_gmac_speed(priv);
-- 
1.7.10.4

