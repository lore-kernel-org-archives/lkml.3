Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3IWWMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:12:03 -0400
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:48083 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754456Ab3IWWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:11:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4321:4385:5007:6117:6261:7903:9592:10004:10026:10848:11026:11657:11658:11914:12043:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hen57_2e0e173c24b14
X-Filterd-Recvd-Size: 4536
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] chelsio: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 15:11:35 -0700
Message-Id: <67806dfa2733eb6ccfb1fbe3f445ab52f21e1366.1379974101.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/chelsio/cxgb/common.h | 46 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/common.h b/drivers/net/ethernet/chelsio/cxgb/common.h
index 5ccbed1..8abb46b 100644
--- a/drivers/net/ethernet/chelsio/cxgb/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb/common.h
@@ -324,30 +324,30 @@ static inline unsigned int core_ticks_per_usec(const adapter_t *adap)
 	return board_info(adap)->clock_core / 1000000;
 }
 
-extern int __t1_tpi_read(adapter_t *adapter, u32 addr, u32 *valp);
-extern int __t1_tpi_write(adapter_t *adapter, u32 addr, u32 value);
-extern int t1_tpi_write(adapter_t *adapter, u32 addr, u32 value);
-extern int t1_tpi_read(adapter_t *adapter, u32 addr, u32 *value);
-
-extern void t1_interrupts_enable(adapter_t *adapter);
-extern void t1_interrupts_disable(adapter_t *adapter);
-extern void t1_interrupts_clear(adapter_t *adapter);
-extern int t1_elmer0_ext_intr_handler(adapter_t *adapter);
-extern void t1_elmer0_ext_intr(adapter_t *adapter);
-extern int t1_slow_intr_handler(adapter_t *adapter);
-
-extern int t1_link_start(struct cphy *phy, struct cmac *mac, struct link_config *lc);
-extern const struct board_info *t1_get_board_info(unsigned int board_id);
-extern const struct board_info *t1_get_board_info_from_ids(unsigned int devid,
+int __t1_tpi_read(adapter_t *adapter, u32 addr, u32 *valp);
+int __t1_tpi_write(adapter_t *adapter, u32 addr, u32 value);
+int t1_tpi_write(adapter_t *adapter, u32 addr, u32 value);
+int t1_tpi_read(adapter_t *adapter, u32 addr, u32 *value);
+
+void t1_interrupts_enable(adapter_t *adapter);
+void t1_interrupts_disable(adapter_t *adapter);
+void t1_interrupts_clear(adapter_t *adapter);
+int t1_elmer0_ext_intr_handler(adapter_t *adapter);
+void t1_elmer0_ext_intr(adapter_t *adapter);
+int t1_slow_intr_handler(adapter_t *adapter);
+
+int t1_link_start(struct cphy *phy, struct cmac *mac, struct link_config *lc);
+const struct board_info *t1_get_board_info(unsigned int board_id);
+const struct board_info *t1_get_board_info_from_ids(unsigned int devid,
 						    unsigned short ssid);
-extern int t1_seeprom_read(adapter_t *adapter, u32 addr, __le32 *data);
-extern int t1_get_board_rev(adapter_t *adapter, const struct board_info *bi,
+int t1_seeprom_read(adapter_t *adapter, u32 addr, __le32 *data);
+int t1_get_board_rev(adapter_t *adapter, const struct board_info *bi,
 		     struct adapter_params *p);
-extern int t1_init_hw_modules(adapter_t *adapter);
-extern int t1_init_sw_modules(adapter_t *adapter, const struct board_info *bi);
-extern void t1_free_sw_modules(adapter_t *adapter);
-extern void t1_fatal_err(adapter_t *adapter);
-extern void t1_link_changed(adapter_t *adapter, int port_id);
-extern void t1_link_negotiated(adapter_t *adapter, int port_id, int link_stat,
+int t1_init_hw_modules(adapter_t *adapter);
+int t1_init_sw_modules(adapter_t *adapter, const struct board_info *bi);
+void t1_free_sw_modules(adapter_t *adapter);
+void t1_fatal_err(adapter_t *adapter);
+void t1_link_changed(adapter_t *adapter, int port_id);
+void t1_link_negotiated(adapter_t *adapter, int port_id, int link_stat,
 			    int speed, int duplex, int pause);
 #endif /* _CXGB_COMMON_H_ */
-- 
1.8.1.2.459.gbcd45b4.dirty

