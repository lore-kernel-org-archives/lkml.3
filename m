Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaCXUQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:16:03 -0400
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:48859 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbaCXUP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:15:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:966:968:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:4321:4385:5007:6261:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bay
X-HE-Tag: tiger42_16a17917a2510
X-Filterd-Recvd-Size: 2391
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] intel: Remove casts of pointer to same type
Date: Mon, 24 Mar 2014 13:15:36 -0700
Message-Id: <9e1ace2dfe6b14005e66c914b4905efb3eadd18e.1395692043.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting a pointer to a pointer of the same type is pointless,
so remove these unnecessary casts.

Done via coccinelle script:

$ cat typecast_2.cocci
@@
type T;
T *foo;
@@

-	(T *)foo
+	foo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 28da412..93c09c0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -396,7 +396,7 @@ static int i40e_get_eeprom(struct net_device *netdev,
 		ret_val = i40e_aq_read_nvm(hw, 0x0,
 				eeprom->offset + (I40E_NVM_SECTOR_SIZE * i),
 				len,
-				(u8 *)eeprom_buff + (I40E_NVM_SECTOR_SIZE * i),
+				eeprom_buff + (I40E_NVM_SECTOR_SIZE * i),
 				last, NULL);
 		if (ret_val) {
 			dev_info(&pf->pdev->dev,
@@ -408,7 +408,7 @@ static int i40e_get_eeprom(struct net_device *netdev,
 
 release_nvm:
 	i40e_release_nvm(hw);
-	memcpy(bytes, (u8 *)eeprom_buff, eeprom->len);
+	memcpy(bytes, eeprom_buff, eeprom->len);
 free_buff:
 	kfree(eeprom_buff);
 	return ret_val;
-- 
1.8.1.2.459.gbcd45b4.dirty

