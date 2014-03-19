Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbaCSIUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:20:45 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:42214 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbaCSIUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:20:41 -0400
From: Mathieu Maret <mathieu.maret@gmail.com>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mathieu Maret <mathieu.maret@gmail.com>
Subject: [PATCH 2/5] staging: wlags49_h2: remove commented code in wl_netdev.c
Date: Wed, 19 Mar 2014 09:20:32 +0100
Message-Id: <1395217235-2979-2-git-send-email-mathieu.maret@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
References: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused code under C99 comment style

Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
---
 drivers/staging/wlags49_h2/wl_netdev.c | 38 ----------------------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index ae42c8e..d9f9237 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -68,31 +68,14 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-// #include <linux/sched.h>
-// #include <linux/ptrace.h>
-// #include <linux/slab.h>
-// #include <linux/ctype.h>
-// #include <linux/string.h>
-//#include <linux/timer.h>
-// #include <linux/interrupt.h>
-// #include <linux/in.h>
-// #include <linux/delay.h>
-// #include <linux/skbuff.h>
-// #include <asm/io.h>
-// // #include <asm/bitops.h>
-
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
-// #include <linux/skbuff.h>
-// #include <linux/if_arp.h>
-// #include <linux/ioport.h>
 
 #include <debug.h>
 
 #include <hcf.h>
 #include <dhf.h>
-// #include <hcfdef.h>
 
 #include <wl_if.h>
 #include <wl_internal.h>
@@ -120,10 +103,6 @@
 #define MTU_MAX (HCF_MAX_MSG - ETH_HLEN)
 #endif
 
-//static int mtu = MTU_MAX;
-//MODULE_PARM(mtu, "i");
-//MODULE_PARM_DESC(mtu, "MTU");
-
 /*******************************************************************************
  * macros
  ******************************************************************************/
@@ -159,16 +138,7 @@
  ******************************************************************************/
 int wl_init(struct net_device *dev)
 {
-//    unsigned long       flags;
-//    struct wl_private   *lp = wl_priv(dev);
-
 	DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
-
-	/* Nothing to do, but grab the spinlock anyway just in case we ever need
-	   this routine */
-//  wl_lock( lp, &flags );
-//  wl_unlock( lp, &flags );
-
 	return 0;
 }				// wl_init
 
@@ -427,17 +397,12 @@ static void wl_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRIVER_NAME, sizeof(info->driver));
 	strlcpy(info->version, DRV_VERSION_STR, sizeof(info->version));
-//      strlcpy(info.fw_version, priv->fw_name,
-//      sizeof(info.fw_version));
 
 	if (dev->dev.parent) {
 		dev_set_name(dev->dev.parent, "%s", info->bus_info);
-		//strlcpy(info->bus_info, dev->dev.parent->bus_id,
-		//      sizeof(info->bus_info));
 	} else {
 		snprintf(info->bus_info, sizeof(info->bus_info),
 			 "PCMCIA FIXME");
-//                  "PCMCIA 0x%lx", priv->hw.iobase);
 	}
 }				// wl_get_drvinfo
 
@@ -1237,8 +1202,6 @@ struct net_device *wl_device_alloc(void)
  ******************************************************************************/
 void wl_device_dealloc(struct net_device *dev)
 {
-//    struct wl_private   *lp = wl_priv(dev);
-
 	/* Dealloc the WDS ports */
 	WL_WDS_DEVICE_DEALLOC(lp);
 
@@ -1832,7 +1795,6 @@ int wl_rx_dma(struct net_device *dev)
 	struct sk_buff *skb;
 	struct wl_private *lp = NULL;
 	DESC_STRCT *desc, *desc_next;
-	//CFG_MB_INFO_RANGE2_STRCT x;
     /*------------------------------------------------------------------------*/
 
 	DBG_PARAM(DbgInfo, "dev", "%s (0x%p)", dev->name, dev);
-- 
1.9.0

