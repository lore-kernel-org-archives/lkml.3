Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3IWSdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:33:51 -0400
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:53342 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753695Ab3IWSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:33:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:2892:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6261:7903:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lock87_2104b74d1dd46
X-Filterd-Recvd-Size: 4405
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] wimax.h: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 11:33:45 -0700
Message-Id: <2690f017eb5e7aa46093da5580f1d1e787c5ff67.1379961014.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com>
References: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com>
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
 include/net/wimax.h | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/net/wimax.h b/include/net/wimax.h
index bbb74f9..98498e1 100644
--- a/include/net/wimax.h
+++ b/include/net/wimax.h
@@ -438,9 +438,9 @@ struct wimax_dev {
  *
  * These functions are not exported to user space.
  */
-extern void wimax_dev_init(struct wimax_dev *);
-extern int wimax_dev_add(struct wimax_dev *, struct net_device *);
-extern void wimax_dev_rm(struct wimax_dev *);
+void wimax_dev_init(struct wimax_dev *);
+int wimax_dev_add(struct wimax_dev *, struct net_device *);
+void wimax_dev_rm(struct wimax_dev *);
 
 static inline
 struct wimax_dev *net_dev_to_wimax(struct net_device *net_dev)
@@ -454,8 +454,8 @@ struct device *wimax_dev_to_dev(struct wimax_dev *wimax_dev)
 	return wimax_dev->net_dev->dev.parent;
 }
 
-extern void wimax_state_change(struct wimax_dev *, enum wimax_st);
-extern enum wimax_st wimax_state_get(struct wimax_dev *);
+void wimax_state_change(struct wimax_dev *, enum wimax_st);
+enum wimax_st wimax_state_get(struct wimax_dev *);
 
 /*
  * Radio Switch state reporting.
@@ -463,8 +463,8 @@ extern enum wimax_st wimax_state_get(struct wimax_dev *);
  * enum wimax_rf_state is declared in linux/wimax.h so the exports
  * to user space can use it.
  */
-extern void wimax_report_rfkill_hw(struct wimax_dev *, enum wimax_rf_state);
-extern void wimax_report_rfkill_sw(struct wimax_dev *, enum wimax_rf_state);
+void wimax_report_rfkill_hw(struct wimax_dev *, enum wimax_rf_state);
+void wimax_report_rfkill_sw(struct wimax_dev *, enum wimax_rf_state);
 
 
 /*
@@ -490,15 +490,14 @@ extern void wimax_report_rfkill_sw(struct wimax_dev *, enum wimax_rf_state);
  * send diagnostics information that a device-specific diagnostics
  * tool would be interested in.
  */
-extern struct sk_buff *wimax_msg_alloc(struct wimax_dev *, const char *,
-				       const void *, size_t, gfp_t);
-extern int wimax_msg_send(struct wimax_dev *, struct sk_buff *);
-extern int wimax_msg(struct wimax_dev *, const char *,
-		     const void *, size_t, gfp_t);
+struct sk_buff *wimax_msg_alloc(struct wimax_dev *, const char *, const void *,
+				size_t, gfp_t);
+int wimax_msg_send(struct wimax_dev *, struct sk_buff *);
+int wimax_msg(struct wimax_dev *, const char *, const void *, size_t, gfp_t);
 
-extern const void *wimax_msg_data_len(struct sk_buff *, size_t *);
-extern const void *wimax_msg_data(struct sk_buff *);
-extern ssize_t wimax_msg_len(struct sk_buff *);
+const void *wimax_msg_data_len(struct sk_buff *, size_t *);
+const void *wimax_msg_data(struct sk_buff *);
+ssize_t wimax_msg_len(struct sk_buff *);
 
 
 /*
@@ -513,7 +512,7 @@ extern ssize_t wimax_msg_len(struct sk_buff *);
  * device's control structure and (as such) the 'struct wimax_dev' is
  * referenced by the caller.
  */
-extern int wimax_rfkill(struct wimax_dev *, enum wimax_rf_state);
-extern int wimax_reset(struct wimax_dev *);
+int wimax_rfkill(struct wimax_dev *, enum wimax_rf_state);
+int wimax_reset(struct wimax_dev *);
 
 #endif /* #ifndef __NET__WIMAX_H__ */
-- 
1.8.1.2.459.gbcd45b4.dirty

