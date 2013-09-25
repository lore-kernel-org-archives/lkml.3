Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3IYTlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:41:00 -0400
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:40039 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754503Ab3IYTiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:38:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:2:41:69:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1605:1606:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4117:4321:4385:4605:5007:6261:7903:9592:10004:10026:10848:11026:11233:11657:11658:11914:12043:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: self08_830cb15b71e5d
X-Filterd-Recvd-Size: 6498
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] ipw2x00: Remove extern from function prototypes
Date: Wed, 25 Sep 2013 12:37:24 -0700
Message-Id: <89eb744f1a77b32d6ec718618f356df3188403e7.1380137609.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380137609.git.joe@perches.com>
References: <cover.1380137609.git.joe@perches.com>
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
 drivers/net/wireless/ipw2x00/libipw.h | 87 +++++++++++++++--------------------
 1 file changed, 38 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index 6eede52..5ce2f59 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -950,66 +950,55 @@ static inline int libipw_is_cck_rate(u8 rate)
 }
 
 /* libipw.c */
-extern void free_libipw(struct net_device *dev, int monitor);
-extern struct net_device *alloc_libipw(int sizeof_priv, int monitor);
-extern int libipw_change_mtu(struct net_device *dev, int new_mtu);
+void free_libipw(struct net_device *dev, int monitor);
+struct net_device *alloc_libipw(int sizeof_priv, int monitor);
+int libipw_change_mtu(struct net_device *dev, int new_mtu);
 
-extern void libipw_networks_age(struct libipw_device *ieee,
-				   unsigned long age_secs);
+void libipw_networks_age(struct libipw_device *ieee, unsigned long age_secs);
 
-extern int libipw_set_encryption(struct libipw_device *ieee);
+int libipw_set_encryption(struct libipw_device *ieee);
 
 /* libipw_tx.c */
-extern netdev_tx_t libipw_xmit(struct sk_buff *skb,
-			       struct net_device *dev);
-extern void libipw_txb_free(struct libipw_txb *);
+netdev_tx_t libipw_xmit(struct sk_buff *skb, struct net_device *dev);
+void libipw_txb_free(struct libipw_txb *);
 
 /* libipw_rx.c */
-extern void libipw_rx_any(struct libipw_device *ieee,
-		     struct sk_buff *skb, struct libipw_rx_stats *stats);
-extern int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
-			struct libipw_rx_stats *rx_stats);
+void libipw_rx_any(struct libipw_device *ieee, struct sk_buff *skb,
+		   struct libipw_rx_stats *stats);
+int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
+	      struct libipw_rx_stats *rx_stats);
 /* make sure to set stats->len */
-extern void libipw_rx_mgt(struct libipw_device *ieee,
-			     struct libipw_hdr_4addr *header,
-			     struct libipw_rx_stats *stats);
-extern void libipw_network_reset(struct libipw_network *network);
+void libipw_rx_mgt(struct libipw_device *ieee, struct libipw_hdr_4addr *header,
+		   struct libipw_rx_stats *stats);
+void libipw_network_reset(struct libipw_network *network);
 
 /* libipw_geo.c */
-extern const struct libipw_geo *libipw_get_geo(struct libipw_device
-						     *ieee);
-extern void libipw_set_geo(struct libipw_device *ieee,
-			     const struct libipw_geo *geo);
-
-extern int libipw_is_valid_channel(struct libipw_device *ieee,
-				      u8 channel);
-extern int libipw_channel_to_index(struct libipw_device *ieee,
-				      u8 channel);
-extern u8 libipw_freq_to_channel(struct libipw_device *ieee, u32 freq);
-extern u8 libipw_get_channel_flags(struct libipw_device *ieee,
-				      u8 channel);
-extern const struct libipw_channel *libipw_get_channel(struct
-							     libipw_device
-							     *ieee, u8 channel);
-extern u32 libipw_channel_to_freq(struct libipw_device * ieee,
-				      u8 channel);
+const struct libipw_geo *libipw_get_geo(struct libipw_device *ieee);
+void libipw_set_geo(struct libipw_device *ieee, const struct libipw_geo *geo);
+
+int libipw_is_valid_channel(struct libipw_device *ieee, u8 channel);
+int libipw_channel_to_index(struct libipw_device *ieee, u8 channel);
+u8 libipw_freq_to_channel(struct libipw_device *ieee, u32 freq);
+u8 libipw_get_channel_flags(struct libipw_device *ieee, u8 channel);
+const struct libipw_channel *libipw_get_channel(struct libipw_device *ieee,
+						u8 channel);
+u32 libipw_channel_to_freq(struct libipw_device *ieee, u8 channel);
 
 /* libipw_wx.c */
-extern int libipw_wx_get_scan(struct libipw_device *ieee,
-				 struct iw_request_info *info,
-				 union iwreq_data *wrqu, char *key);
-extern int libipw_wx_set_encode(struct libipw_device *ieee,
-				   struct iw_request_info *info,
-				   union iwreq_data *wrqu, char *key);
-extern int libipw_wx_get_encode(struct libipw_device *ieee,
-				   struct iw_request_info *info,
-				   union iwreq_data *wrqu, char *key);
-extern int libipw_wx_set_encodeext(struct libipw_device *ieee,
-				      struct iw_request_info *info,
-				      union iwreq_data *wrqu, char *extra);
-extern int libipw_wx_get_encodeext(struct libipw_device *ieee,
-				      struct iw_request_info *info,
-				      union iwreq_data *wrqu, char *extra);
+int libipw_wx_get_scan(struct libipw_device *ieee, struct iw_request_info *info,
+		       union iwreq_data *wrqu, char *key);
+int libipw_wx_set_encode(struct libipw_device *ieee,
+			 struct iw_request_info *info, union iwreq_data *wrqu,
+			 char *key);
+int libipw_wx_get_encode(struct libipw_device *ieee,
+			 struct iw_request_info *info, union iwreq_data *wrqu,
+			 char *key);
+int libipw_wx_set_encodeext(struct libipw_device *ieee,
+			    struct iw_request_info *info,
+			    union iwreq_data *wrqu, char *extra);
+int libipw_wx_get_encodeext(struct libipw_device *ieee,
+			    struct iw_request_info *info,
+			    union iwreq_data *wrqu, char *extra);
 
 static inline void libipw_increment_scans(struct libipw_device *ieee)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

