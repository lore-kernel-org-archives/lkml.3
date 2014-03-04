Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaCDCIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:08:52 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59556 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaCDCIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:08:51 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, ying.xue@windriver.com,
        davem@davemloft.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: cxt1e1: Fix line length over 80 characters in linux.c
Date: Tue, 04 Mar 2014 11:08:46 +0900
Message-ID: <2825545.2YpN0JuVSn@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up checkpatch.pl warnings:
 WARNING: Line length over 80 characters

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |   48 +++++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 17d73f4..579e68e 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -31,7 +31,7 @@
 #include "pmcc4_private.h"
 #include "sbeproc.h"
 
-/*****************************************************************************************
+/*******************************************************************************
  * Error out early if we have compiler trouble.
  *
  *   (This section is included from the kernel's init/main.c as a friendly
@@ -50,7 +50,7 @@
 #warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
 #endif
 
-/*****************************************************************************************/
+/*******************************************************************************/
 
 #define CHANNAME "hdlc"
 
@@ -321,7 +321,8 @@ chan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 
 static int
-chan_attach_noop(struct net_device *ndev, unsigned short foo_1, unsigned short foo_2)
+chan_attach_noop(struct net_device *ndev, unsigned short foo_1,
+		 unsigned short foo_2)
 {
 	/* our driver has nothing to do here, show's
 	 * over, go home
@@ -431,13 +432,15 @@ create_chan(struct net_device *ndev, ci_t *ci,
 		priv = OS_kmalloc(sizeof(struct c4_priv));
 		if (!priv)
 		{
-			pr_warning("%s: no memory for net_device !\n", ci->devname);
+			pr_warning("%s: no memory for net_device !\n",
+				   ci->devname);
 			return NULL;
 		}
 		dev = alloc_hdlcdev(priv);
 		if (!dev)
 		{
-			pr_warning("%s: no memory for hdlc_device !\n", ci->devname);
+			pr_warning("%s: no memory for hdlc_device !\n",
+				   ci->devname);
 			OS_kfree(priv);
 			return NULL;
 		}
@@ -458,10 +461,12 @@ create_chan(struct net_device *ndev, ci_t *ci,
 		switch (hi->promfmt)
 		{
 		case PROM_FORMAT_TYPE1:
-			memcpy(dev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
+			memcpy(dev->dev_addr,
+			       (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
 			break;
 		case PROM_FORMAT_TYPE2:
-			memcpy(dev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
+			memcpy(dev->dev_addr,
+			       (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
 			break;
 		default:
 			memset(dev->dev_addr, 0, 6);
@@ -691,9 +696,11 @@ do_create_chan(struct net_device *ndev, void *data)
 	ret = mkret(c4_new_chan(ci, cp.port, cp.channum, dev));
 	if (ret)
 	{
-		rtnl_unlock();             /* needed due to Ioctl calling sequence */
+		/* needed due to Ioctl calling sequence */
+		rtnl_unlock();
 		unregister_hdlc_device(dev);
-		rtnl_lock();               /* needed due to Ioctl calling sequence */
+		/* needed due to Ioctl calling sequence */
+		rtnl_lock();
 		free_netdev(dev);
 	}
 	return ret;
@@ -753,11 +760,13 @@ do_deluser(struct net_device *ndev, int lockit)
 		ch->user = NULL;	/* will be freed, below */
 	}
 
+	/* needed if Ioctl calling sequence */
 	if (lockit)
-		rtnl_unlock();             /* needed if Ioctl calling sequence */
+		rtnl_unlock();
 	unregister_hdlc_device(ndev);
+	/* needed if Ioctl calling sequence */
 	if (lockit)
-		rtnl_lock();               /* needed if Ioctl calling sequence */
+		rtnl_lock();
 	free_netdev(ndev);
 	return 0;
 }
@@ -927,7 +936,8 @@ c4_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 		ret = do_pld_rw(ndev, data);
 		break;
 	case SBE_IOC_IID_GET:
-		ret = (iolen == sizeof(struct sbe_iid_info)) ? c4_get_iidinfo(ci, &arg.u.iip) : -EFAULT;
+		ret = (iolen == sizeof(struct sbe_iid_info)) ?
+		       c4_get_iidinfo(ci, &arg.u.iip) : -EFAULT;
 		if (ret == 0)               /* no error, copy data */
 			if (copy_to_user(data, &arg, iolen))
 				return -EFAULT;
@@ -962,7 +972,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 	ndev = alloc_netdev(sizeof(ci_t), SBE_IFACETMPL, c4_setup);
 	if (!ndev)
 	{
-		pr_warning("%s: no memory for struct net_device !\n", hi->devname);
+		pr_warning("%s: no memory for struct net_device !\n",
+			   hi->devname);
 		error_flag = ENOMEM;
 		return NULL;
 	}
@@ -1022,7 +1033,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 			IRQF_SHARED,
 			ndev->name, ndev))
 	{
-		pr_warning("%s: MUSYCC could not get irq: %d\n", ndev->name, irq0);
+		pr_warning("%s: MUSYCC could not get irq: %d\n",
+			   ndev->name, irq0);
 		unregister_netdev(ndev);
 		OS_kfree(netdev_priv(ndev));
 		OS_kfree(ndev);
@@ -1053,13 +1065,15 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		switch (hi->promfmt)
 		{
 		case PROM_FORMAT_TYPE1:
-			memcpy(ndev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
+			memcpy(ndev->dev_addr,
+			       (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
 			/* unaligned data acquisition */
 			memcpy(&tmp, (FLD_TYPE1 *) (hi->mfg_info.pft1.Id), 4);
 			ci->brd_id = cpu_to_be32(tmp);
 			break;
 		case PROM_FORMAT_TYPE2:
-			memcpy(ndev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
+			memcpy(ndev->dev_addr,
+			       (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
 			/* unaligned data acquisition */
 			memcpy(&tmp, (FLD_TYPE2 *) (hi->mfg_info.pft2.Id), 4);
 			ci->brd_id = cpu_to_be32(tmp);
@@ -1110,7 +1124,7 @@ c4_mod_init(void)
 
 	pr_warning("%s\n", pmcc4_OSSI_release);
 	if ((rtn = c4hw_attach_all()))
-		return -rtn;                /* installation failure - see system log */
+		return -rtn; /* installation failure - see system log */
 
 	/* housekeeping notifications */
 	if (cxt1e1_log_level != log_level_default)
-- 
1.7.4.4


