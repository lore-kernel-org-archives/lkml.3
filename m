Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3IURXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:23:33 -0400
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:56695 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752605Ab3IURXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2553:2559:2562:2895:2907:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3874:4321:4605:5007:6119:6261:7903:8660:10004:10026:10848:11026:11658:11914:12043:12438:12517:12519:12555:12683:13148:13161:13229:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss20_1bb211de91748
X-Filterd-Recvd-Size: 4006
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] iw_handler.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:49 -0700
Message-Id: <ed8fa3f192a3dbc7305f97c2ac0a0a0f247dd1b3.1379783996.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
References: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
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
 include/net/iw_handler.h | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index 5d5a6a4..a830b01 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -432,44 +432,32 @@ struct iw_public_data {
 /* First : function strictly used inside the kernel */
 
 /* Handle /proc/net/wireless, called in net/code/dev.c */
-extern int dev_get_wireless_info(char * buffer, char **start, off_t offset,
-				 int length);
+int dev_get_wireless_info(char *buffer, char **start, off_t offset, int length);
 
 /* Second : functions that may be called by driver modules */
 
 /* Send a single event to user space */
-extern void wireless_send_event(struct net_device *	dev,
-				unsigned int		cmd,
-				union iwreq_data *	wrqu,
-				const char *		extra);
+void wireless_send_event(struct net_device *dev, unsigned int cmd,
+			 union iwreq_data *wrqu, const char *extra);
 
 /* We may need a function to send a stream of events to user space.
  * More on that later... */
 
 /* Standard handler for SIOCSIWSPY */
-extern int iw_handler_set_spy(struct net_device *	dev,
-			      struct iw_request_info *	info,
-			      union iwreq_data *	wrqu,
-			      char *			extra);
+int iw_handler_set_spy(struct net_device *dev, struct iw_request_info *info,
+		       union iwreq_data *wrqu, char *extra);
 /* Standard handler for SIOCGIWSPY */
-extern int iw_handler_get_spy(struct net_device *	dev,
-			      struct iw_request_info *	info,
-			      union iwreq_data *	wrqu,
-			      char *			extra);
+int iw_handler_get_spy(struct net_device *dev, struct iw_request_info *info,
+		       union iwreq_data *wrqu, char *extra);
 /* Standard handler for SIOCSIWTHRSPY */
-extern int iw_handler_set_thrspy(struct net_device *	dev,
-				 struct iw_request_info *info,
-				 union iwreq_data *	wrqu,
-				 char *			extra);
+int iw_handler_set_thrspy(struct net_device *dev, struct iw_request_info *info,
+			  union iwreq_data *wrqu, char *extra);
 /* Standard handler for SIOCGIWTHRSPY */
-extern int iw_handler_get_thrspy(struct net_device *	dev,
-				 struct iw_request_info *info,
-				 union iwreq_data *	wrqu,
-				 char *			extra);
+int iw_handler_get_thrspy(struct net_device *dev, struct iw_request_info *info,
+			  union iwreq_data *wrqu, char *extra);
 /* Driver call to update spy records */
-extern void wireless_spy_update(struct net_device *	dev,
-				unsigned char *		address,
-				struct iw_quality *	wstats);
+void wireless_spy_update(struct net_device *dev, unsigned char *address,
+			 struct iw_quality *wstats);
 
 /************************* INLINE FUNTIONS *************************/
 /*
-- 
1.8.1.2.459.gbcd45b4.dirty

