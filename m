Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaGZOVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:21:41 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37258 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGZOVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:21:39 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: intel: i40e: i40e_main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:23:04 +0200
Message-Id: <1406384584-2524-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 275ca9a..64668ac 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4193,13 +4193,13 @@ static void i40e_print_link_message(struct i40e_vsi *vsi, bool isup)
 
 	switch (vsi->back->hw.phy.link_info.link_speed) {
 	case I40E_LINK_SPEED_40GB:
-		strncpy(speed, "40 Gbps", SPEED_SIZE);
+		strlcpy(speed, "40 Gbps", SPEED_SIZE);
 		break;
 	case I40E_LINK_SPEED_10GB:
-		strncpy(speed, "10 Gbps", SPEED_SIZE);
+		strlcpy(speed, "10 Gbps", SPEED_SIZE);
 		break;
 	case I40E_LINK_SPEED_1GB:
-		strncpy(speed, "1000 Mbps", SPEED_SIZE);
+		strlcpy(speed, "1000 Mbps", SPEED_SIZE);
 		break;
 	default:
 		break;
@@ -4207,16 +4207,16 @@ static void i40e_print_link_message(struct i40e_vsi *vsi, bool isup)
 
 	switch (vsi->back->hw.fc.current_mode) {
 	case I40E_FC_FULL:
-		strncpy(fc, "RX/TX", FC_SIZE);
+		strlcpy(fc, "RX/TX", FC_SIZE);
 		break;
 	case I40E_FC_TX_PAUSE:
-		strncpy(fc, "TX", FC_SIZE);
+		strlcpy(fc, "TX", FC_SIZE);
 		break;
 	case I40E_FC_RX_PAUSE:
-		strncpy(fc, "RX", FC_SIZE);
+		strlcpy(fc, "RX", FC_SIZE);
 		break;
 	default:
-		strncpy(fc, "None", FC_SIZE);
+		strlcpy(fc, "None", FC_SIZE);
 		break;
 	}
 
@@ -5558,7 +5558,7 @@ static void i40e_send_version(struct i40e_pf *pf)
 	dv.minor_version = DRV_VERSION_MINOR;
 	dv.build_version = DRV_VERSION_BUILD;
 	dv.subbuild_version = 0;
-	strncpy(dv.driver_string, DRV_VERSION, sizeof(dv.driver_string));
+	strlcpy(dv.driver_string, DRV_VERSION, sizeof(dv.driver_string));
 	i40e_aq_send_driver_version(&pf->hw, &dv, NULL);
 }
 
-- 
1.7.10.4

