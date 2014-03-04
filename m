Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaCDCGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:06:37 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46165 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaCDCGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:06:35 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca, ying.xue@windriver.com,
        dulshani.gunawardhana89@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] staging: cxt1e1: Fix no spaces at the start of a line in linux.c
Date: Tue, 04 Mar 2014 11:06:31 +0900
Message-ID: <1722628.L1l9hkyCi9@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up checkpatch.pl warnings:
 WARNING: please no spaces at the start of a line in

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/linux.c | 1478 ++++++++++++++++++++--------------------
 1 files changed, 743 insertions(+), 735 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 7129265..17d73f4 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -86,7 +86,7 @@ extern ci_t *CI;
 extern struct s_hdw_info hdw_info[];
 
 #if defined(CONFIG_SBE_HDLC_V7) || defined(CONFIG_SBE_WAN256T3_HDLC_V7) || \
-    defined(CONFIG_SBE_HDLC_V7_MODULE) || defined(CONFIG_SBE_WAN256T3_HDLC_V7_MODULE)
+	defined(CONFIG_SBE_HDLC_V7_MODULE) || defined(CONFIG_SBE_WAN256T3_HDLC_V7_MODULE)
 #define _v7_hdlc_  1
 #else
 #define _v7_hdlc_  0
@@ -130,30 +130,30 @@ module_param(max_rxdesc_used, int, 0444);
 void *
 getuserbychan(int channum)
 {
-    mch_t      *ch;
+	mch_t      *ch;
 
-    ch = c4_find_chan(channum);
-    return ch ? ch->user : NULL;
+	ch = c4_find_chan(channum);
+	return ch ? ch->user : NULL;
 }
 
 
 char *
 get_hdlc_name(hdlc_device *hdlc)
 {
-    struct c4_priv *priv = hdlc->priv;
-    struct net_device *dev = getuserbychan(priv->channum);
+	struct c4_priv *priv = hdlc->priv;
+	struct net_device *dev = getuserbychan(priv->channum);
 
-    return dev->name;
+	return dev->name;
 }
 
 
 static status_t
 mkret(int bsd)
 {
-    if (bsd > 0)
-        return -bsd;
-    else
-        return bsd;
+	if (bsd > 0)
+		return -bsd;
+	else
+		return bsd;
 }
 
 /***************************************************************************/
@@ -181,72 +181,72 @@ mkret(int bsd)
 void
 c4_wk_chan_restart(mch_t *ch)
 {
-    mpi_t      *pi = ch->up;
+	mpi_t      *pi = ch->up;
 
 #ifdef RLD_RESTART_DEBUG
-    pr_info(">> %s: queueing Port %d Chan %d, mch_t @ %p\n",
-            __func__, pi->portnum, ch->channum, ch);
+	pr_info(">> %s: queueing Port %d Chan %d, mch_t @ %p\n",
+		__func__, pi->portnum, ch->channum, ch);
 #endif
 
-    /* create new entry w/in workqueue for this channel and let'er rip */
+	/* create new entry w/in workqueue for this channel and let'er rip */
 
-    /** queue_work(struct workqueue_struct *queue,
-     **            struct work_struct *work);
-     **/
-    queue_work(pi->wq_port, &ch->ch_work);
+	/** queue_work(struct workqueue_struct *queue,
+	 **            struct work_struct *work);
+	 **/
+	queue_work(pi->wq_port, &ch->ch_work);
 }
 
 status_t
 c4_wk_chan_init(mpi_t *pi, mch_t *ch)
 {
-    /*
-     * this will be used to restart a stopped channel
-     */
-
-    /** INIT_WORK(struct work_struct *work,
-     **           void (*function)(void *),
-     **           void *data);
-     **/
-    INIT_WORK(&ch->ch_work, (void *)musycc_wq_chan_restart);
-    return 0;                       /* success */
+	/*
+	 * this will be used to restart a stopped channel
+	 */
+
+	/** INIT_WORK(struct work_struct *work,
+	 **           void (*function)(void *),
+	 **           void *data);
+	 **/
+	INIT_WORK(&ch->ch_work, (void *)musycc_wq_chan_restart);
+	return 0;                       /* success */
 }
 
 status_t
 c4_wq_port_init(mpi_t *pi)
 {
 
-    char        name[16], *np;  /* NOTE: name of the queue limited by system
-                                 * to 10 characters */
+	char        name[16], *np;  /* NOTE: name of the queue limited by system
+				     * to 10 characters */
 
-    if (pi->wq_port)
-        return 0;                   /* already initialized */
+	if (pi->wq_port)
+		return 0;                   /* already initialized */
 
-    np = name;
-    memset(name, 0, 16);
-    sprintf(np, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
+	np = name;
+	memset(name, 0, 16);
+	sprintf(np, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
 
 #ifdef RLD_RESTART_DEBUG
-    pr_info(">> %s: creating workqueue <%s> for Port %d.\n",
-            __func__, name, pi->portnum); /* RLD DEBUG */
+	pr_info(">> %s: creating workqueue <%s> for Port %d.\n",
+		__func__, name, pi->portnum); /* RLD DEBUG */
 #endif
-    if (!(pi->wq_port = create_singlethread_workqueue(name)))
-        return -ENOMEM;
-    return 0;                       /* success */
+	if (!(pi->wq_port = create_singlethread_workqueue(name)))
+		return -ENOMEM;
+	return 0;                       /* success */
 }
 
 void
 c4_wq_port_cleanup(mpi_t *pi)
 {
-    /*
-     * PORT POINT: cannot call this if WQ is statically allocated w/in
-     * structure since it calls kfree(wq);
-     */
-    if (pi->wq_port)
-    {
-        destroy_workqueue(pi->wq_port);        /* this also calls
-                                                 * flush_workqueue() */
-        pi->wq_port = NULL;
-    }
+	/*
+	 * PORT POINT: cannot call this if WQ is statically allocated w/in
+	 * structure since it calls kfree(wq);
+	 */
+	if (pi->wq_port)
+	{
+		destroy_workqueue(pi->wq_port);        /* this also calls
+							* flush_workqueue() */
+		pi->wq_port = NULL;
+	}
 }
 
 /***************************************************************************/
@@ -254,9 +254,9 @@ c4_wq_port_cleanup(mpi_t *pi)
 irqreturn_t
 c4_linux_interrupt(int irq, void *dev_instance)
 {
-    struct net_device *ndev = dev_instance;
+	struct net_device *ndev = dev_instance;
 
-    return musycc_intr_th_handler(netdev_priv(ndev));
+	return musycc_intr_th_handler(netdev_priv(ndev));
 }
 
 
@@ -264,9 +264,9 @@ c4_linux_interrupt(int irq, void *dev_instance)
 irqreturn_t
 c4_ebus_interrupt(int irq, void *dev_instance)
 {
-    struct net_device *ndev = dev_instance;
+	struct net_device *ndev = dev_instance;
 
-    return c4_ebus_intr_th_handler(netdev_priv(ndev));
+	return c4_ebus_intr_th_handler(netdev_priv(ndev));
 }
 #endif
 
@@ -274,231 +274,237 @@ c4_ebus_interrupt(int irq, void *dev_instance)
 static int
 void_open(struct net_device *ndev)
 {
-    pr_info("%s: trying to open master device !\n", ndev->name);
-    return -1;
+	pr_info("%s: trying to open master device !\n", ndev->name);
+	return -1;
 }
 
 
 static int
 chan_open(struct net_device *ndev)
 {
-    hdlc_device *hdlc = dev_to_hdlc(ndev);
-    const struct c4_priv *priv = hdlc->priv;
-    int         ret;
-
-    if ((ret = hdlc_open(ndev)))
-    {
-        pr_info("hdlc_open failure, err %d.\n", ret);
-        return ret;
-    }
-    if ((ret = c4_chan_up(priv->ci, priv->channum)))
-        return -ret;
-    try_module_get(THIS_MODULE);
-    netif_start_queue(ndev);
-    return 0;                       /* no error = success */
+	hdlc_device *hdlc = dev_to_hdlc(ndev);
+	const struct c4_priv *priv = hdlc->priv;
+	int         ret;
+
+	if ((ret = hdlc_open(ndev)))
+	{
+		pr_info("hdlc_open failure, err %d.\n", ret);
+		return ret;
+	}
+	if ((ret = c4_chan_up(priv->ci, priv->channum)))
+		return -ret;
+	try_module_get(THIS_MODULE);
+	netif_start_queue(ndev);
+	return 0;                       /* no error = success */
 }
 
 
 static int
 chan_close(struct net_device *ndev)
 {
-    hdlc_device *hdlc = dev_to_hdlc(ndev);
-    const struct c4_priv *priv = hdlc->priv;
-
-    netif_stop_queue(ndev);
-    musycc_chan_down((ci_t *) 0, priv->channum);
-    hdlc_close(ndev);
-    module_put(THIS_MODULE);
-    return 0;
+	hdlc_device *hdlc = dev_to_hdlc(ndev);
+	const struct c4_priv *priv = hdlc->priv;
+
+	netif_stop_queue(ndev);
+	musycc_chan_down((ci_t *) 0, priv->channum);
+	hdlc_close(ndev);
+	module_put(THIS_MODULE);
+	return 0;
 }
 
 
 static int
 chan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-    return hdlc_ioctl(dev, ifr, cmd);
+	return hdlc_ioctl(dev, ifr, cmd);
 }
 
 
 static int
 chan_attach_noop(struct net_device *ndev, unsigned short foo_1, unsigned short foo_2)
 {
-    return 0;                   /* our driver has nothing to do here, show's
-                                 * over, go home */
+	/* our driver has nothing to do here, show's
+	 * over, go home
+	 */
+	return 0;
 }
 
 
 static struct net_device_stats *
 chan_get_stats(struct net_device *ndev)
 {
-    mch_t      *ch;
-    struct net_device_stats *nstats;
-    struct sbecom_chan_stats *stats;
-    int         channum;
-
-    {
-        struct c4_priv *priv;
-
-        priv = (struct c4_priv *)dev_to_hdlc(ndev)->priv;
-        channum = priv->channum;
-    }
-
-    ch = c4_find_chan(channum);
-    if (ch == NULL)
-        return NULL;
-
-    nstats = &ndev->stats;
-    stats = &ch->s;
-
-    memset(nstats, 0, sizeof(struct net_device_stats));
-    nstats->rx_packets = stats->rx_packets;
-    nstats->tx_packets = stats->tx_packets;
-    nstats->rx_bytes = stats->rx_bytes;
-    nstats->tx_bytes = stats->tx_bytes;
-    nstats->rx_errors = stats->rx_length_errors +
-        stats->rx_over_errors +
-        stats->rx_crc_errors +
-        stats->rx_frame_errors +
-        stats->rx_fifo_errors +
-        stats->rx_missed_errors;
-    nstats->tx_errors = stats->tx_dropped +
-        stats->tx_aborted_errors +
-        stats->tx_fifo_errors;
-    nstats->rx_dropped = stats->rx_dropped;
-    nstats->tx_dropped = stats->tx_dropped;
-
-    nstats->rx_length_errors = stats->rx_length_errors;
-    nstats->rx_over_errors = stats->rx_over_errors;
-    nstats->rx_crc_errors = stats->rx_crc_errors;
-    nstats->rx_frame_errors = stats->rx_frame_errors;
-    nstats->rx_fifo_errors = stats->rx_fifo_errors;
-    nstats->rx_missed_errors = stats->rx_missed_errors;
-
-    nstats->tx_aborted_errors = stats->tx_aborted_errors;
-    nstats->tx_fifo_errors = stats->tx_fifo_errors;
-
-    return nstats;
+	mch_t      *ch;
+	struct net_device_stats *nstats;
+	struct sbecom_chan_stats *stats;
+	int         channum;
+
+	{
+		struct c4_priv *priv;
+
+		priv = (struct c4_priv *)dev_to_hdlc(ndev)->priv;
+		channum = priv->channum;
+	}
+
+	ch = c4_find_chan(channum);
+	if (ch == NULL)
+		return NULL;
+
+	nstats = &ndev->stats;
+	stats = &ch->s;
+
+	memset(nstats, 0, sizeof(struct net_device_stats));
+	nstats->rx_packets = stats->rx_packets;
+	nstats->tx_packets = stats->tx_packets;
+	nstats->rx_bytes = stats->rx_bytes;
+	nstats->tx_bytes = stats->tx_bytes;
+	nstats->rx_errors = stats->rx_length_errors +
+		stats->rx_over_errors +
+		stats->rx_crc_errors +
+		stats->rx_frame_errors +
+		stats->rx_fifo_errors +
+		stats->rx_missed_errors;
+	nstats->tx_errors = stats->tx_dropped +
+		stats->tx_aborted_errors +
+		stats->tx_fifo_errors;
+	nstats->rx_dropped = stats->rx_dropped;
+	nstats->tx_dropped = stats->tx_dropped;
+
+	nstats->rx_length_errors = stats->rx_length_errors;
+	nstats->rx_over_errors = stats->rx_over_errors;
+	nstats->rx_crc_errors = stats->rx_crc_errors;
+	nstats->rx_frame_errors = stats->rx_frame_errors;
+	nstats->rx_fifo_errors = stats->rx_fifo_errors;
+	nstats->rx_missed_errors = stats->rx_missed_errors;
+
+	nstats->tx_aborted_errors = stats->tx_aborted_errors;
+	nstats->tx_fifo_errors = stats->tx_fifo_errors;
+
+	return nstats;
 }
 
 
 static ci_t *
 get_ci_by_dev(struct net_device *ndev)
 {
-    return (ci_t *)(netdev_priv(ndev));
+	return (ci_t *)(netdev_priv(ndev));
 }
 
 
 static int
 c4_linux_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-    const struct c4_priv *priv;
-    int         rval;
+	const struct c4_priv *priv;
+	int         rval;
 
-    hdlc_device *hdlc = dev_to_hdlc(ndev);
+	hdlc_device *hdlc = dev_to_hdlc(ndev);
 
-    priv = hdlc->priv;
+	priv = hdlc->priv;
 
-    rval = musycc_start_xmit(priv->ci, priv->channum, skb);
-    return rval;
+	rval = musycc_start_xmit(priv->ci, priv->channum, skb);
+	return rval;
 }
 
 static const struct net_device_ops chan_ops = {
-       .ndo_open       = chan_open,
-       .ndo_stop       = chan_close,
-       .ndo_start_xmit = c4_linux_xmit,
-       .ndo_do_ioctl   = chan_dev_ioctl,
-       .ndo_get_stats  = chan_get_stats,
+	.ndo_open       = chan_open,
+	.ndo_stop       = chan_close,
+	.ndo_start_xmit = c4_linux_xmit,
+	.ndo_do_ioctl   = chan_dev_ioctl,
+	.ndo_get_stats  = chan_get_stats,
 };
 
 static struct net_device *
 create_chan(struct net_device *ndev, ci_t *ci,
-            struct sbecom_chan_param *cp)
+	    struct sbecom_chan_param *cp)
 {
-    hdlc_device *hdlc;
-    struct net_device *dev;
-    hdw_info_t *hi;
-    int         ret;
-
-    if (c4_find_chan(cp->channum))
-        return NULL;                   /* channel already exists */
-
-    {
-        struct c4_priv *priv;
-
-        /* allocate then fill in private data structure */
-        priv = OS_kmalloc(sizeof(struct c4_priv));
-        if (!priv)
-        {
-            pr_warning("%s: no memory for net_device !\n", ci->devname);
-	    return NULL;
-        }
-        dev = alloc_hdlcdev(priv);
-        if (!dev)
-        {
-            pr_warning("%s: no memory for hdlc_device !\n", ci->devname);
-            OS_kfree(priv);
-	    return NULL;
-        }
-        priv->ci = ci;
-        priv->channum = cp->channum;
-    }
-
-    hdlc = dev_to_hdlc(dev);
-
-    dev->base_addr = 0;             /* not I/O mapped */
-    dev->irq = ndev->irq;
-    dev->type = ARPHRD_RAWHDLC;
-    *dev->name = 0;                 /* default ifconfig name = "hdlc" */
-
-    hi = (hdw_info_t *)ci->hdw_info;
-    if (hi->mfg_info_sts == EEPROM_OK)
-    {
-        switch (hi->promfmt)
-        {
-        case PROM_FORMAT_TYPE1:
-            memcpy(dev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
-            break;
-        case PROM_FORMAT_TYPE2:
-            memcpy(dev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
-            break;
-        default:
-            memset(dev->dev_addr, 0, 6);
-            break;
-        }
-    } else
-    {
-        memset(dev->dev_addr, 0, 6);
-    }
-
-    hdlc->xmit = c4_linux_xmit;
-
-    dev->netdev_ops = &chan_ops;
-    /*
-     * The native hdlc stack calls this 'attach' routine during
-     * hdlc_raw_ioctl(), passing parameters for line encoding and parity.
-     * Since hdlc_raw_ioctl() stack does not interrogate whether an 'attach'
-     * routine is actually registered or not, we supply a dummy routine which
-     * does nothing (since encoding and parity are setup for our driver via a
-     * special configuration application).
-     */
-
-    hdlc->attach = chan_attach_noop;
-
-    rtnl_unlock();                 /* needed due to Ioctl calling sequence */
-    ret = register_hdlc_device(dev);
-    /* NOTE: <stats> setting must occur AFTER registration in order to "take" */
-    dev->tx_queue_len = MAX_DEFAULT_IFQLEN;
-
-    rtnl_lock();                   /* needed due to Ioctl calling sequence */
-    if (ret)
-    {
-        if (cxt1e1_log_level >= LOG_WARN)
-            pr_info("%s: create_chan[%d] registration error = %d.\n",
-                    ci->devname, cp->channum, ret);
-        free_netdev(dev);          /* cleanup */
-	return NULL;		/* failed to register */
-    }
-    return dev;
+	hdlc_device *hdlc;
+	struct net_device *dev;
+	hdw_info_t *hi;
+	int         ret;
+
+	if (c4_find_chan(cp->channum))
+		return NULL;                   /* channel already exists */
+
+	{
+		struct c4_priv *priv;
+
+		/* allocate then fill in private data structure */
+		priv = OS_kmalloc(sizeof(struct c4_priv));
+		if (!priv)
+		{
+			pr_warning("%s: no memory for net_device !\n", ci->devname);
+			return NULL;
+		}
+		dev = alloc_hdlcdev(priv);
+		if (!dev)
+		{
+			pr_warning("%s: no memory for hdlc_device !\n", ci->devname);
+			OS_kfree(priv);
+			return NULL;
+		}
+		priv->ci = ci;
+		priv->channum = cp->channum;
+	}
+
+	hdlc = dev_to_hdlc(dev);
+
+	dev->base_addr = 0;             /* not I/O mapped */
+	dev->irq = ndev->irq;
+	dev->type = ARPHRD_RAWHDLC;
+	*dev->name = 0;                 /* default ifconfig name = "hdlc" */
+
+	hi = (hdw_info_t *)ci->hdw_info;
+	if (hi->mfg_info_sts == EEPROM_OK)
+	{
+		switch (hi->promfmt)
+		{
+		case PROM_FORMAT_TYPE1:
+			memcpy(dev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
+			break;
+		case PROM_FORMAT_TYPE2:
+			memcpy(dev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
+			break;
+		default:
+			memset(dev->dev_addr, 0, 6);
+			break;
+		}
+	} else
+	{
+		memset(dev->dev_addr, 0, 6);
+	}
+
+	hdlc->xmit = c4_linux_xmit;
+
+	dev->netdev_ops = &chan_ops;
+	/*
+	 * The native hdlc stack calls this 'attach' routine during
+	 * hdlc_raw_ioctl(), passing parameters for line encoding and parity.
+	 * Since hdlc_raw_ioctl() stack does not interrogate whether an 'attach'
+	 * routine is actually registered or not, we supply a dummy routine which
+	 * does nothing (since encoding and parity are setup for our driver via a
+	 * special configuration application).
+	 */
+
+	hdlc->attach = chan_attach_noop;
+
+	/* needed due to Ioctl calling sequence */
+	rtnl_unlock();
+	ret = register_hdlc_device(dev);
+	/* NOTE: <stats> setting must occur AFTER registration in order to "take" */
+	dev->tx_queue_len = MAX_DEFAULT_IFQLEN;
+
+	/* needed due to Ioctl calling sequence */
+	rtnl_lock();
+	if (ret)
+	{
+		if (cxt1e1_log_level >= LOG_WARN)
+			pr_info("%s: create_chan[%d] registration error = %d.\n",
+				ci->devname, cp->channum, ret);
+		/* cleanup */
+		free_netdev(dev);
+		/* failed to register */
+		return NULL;
+	}
+	return dev;
 }
 
 
@@ -506,629 +512,631 @@ create_chan(struct net_device *ndev, ci_t *ci,
 static status_t
 do_get_port(struct net_device *ndev, void *data)
 {
-    int         ret;
-    ci_t       *ci;             /* ci stands for card information */
-    struct sbecom_port_param pp;/* copy data to kernel land */
-
-    if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    if (pp.portnum >= MUSYCC_NPORTS)
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;             /* get card info */
-
-    ret = mkret(c4_get_port(ci, pp.portnum));
-    if (ret)
-        return ret;
-    if (copy_to_user(data, &ci->port[pp.portnum].p,
-                     sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    return 0;
+	int         ret;
+	ci_t       *ci;             /* ci stands for card information */
+	struct sbecom_port_param pp;/* copy data to kernel land */
+
+	if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	if (pp.portnum >= MUSYCC_NPORTS)
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;             /* get card info */
+
+	ret = mkret(c4_get_port(ci, pp.portnum));
+	if (ret)
+		return ret;
+	if (copy_to_user(data, &ci->port[pp.portnum].p,
+			 sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	return 0;
 }
 
 /* this function copys the user data and then calls the real action function */
 static status_t
 do_set_port(struct net_device *ndev, void *data)
 {
-    ci_t       *ci;             /* ci stands for card information */
-    struct sbecom_port_param pp;/* copy data to kernel land */
-
-    if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    if (pp.portnum >= MUSYCC_NPORTS)
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;             /* get card info */
-
-    if (pp.portnum >= ci->max_port) /* sanity check */
-        return -ENXIO;
-
-    memcpy(&ci->port[pp.portnum].p, &pp, sizeof(struct sbecom_port_param));
-    return mkret(c4_set_port(ci, pp.portnum));
+	ci_t       *ci;             /* ci stands for card information */
+	struct sbecom_port_param pp;/* copy data to kernel land */
+
+	if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	if (pp.portnum >= MUSYCC_NPORTS)
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;             /* get card info */
+
+	if (pp.portnum >= ci->max_port) /* sanity check */
+		return -ENXIO;
+
+	memcpy(&ci->port[pp.portnum].p, &pp, sizeof(struct sbecom_port_param));
+	return mkret(c4_set_port(ci, pp.portnum));
 }
 
 /* work the port loopback mode as per directed */
 static status_t
 do_port_loop(struct net_device *ndev, void *data)
 {
-    struct sbecom_port_param pp;
-    ci_t       *ci;
-
-    if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;
-    return mkret(c4_loop_port(ci, pp.portnum, pp.port_mode));
+	struct sbecom_port_param pp;
+	ci_t       *ci;
+
+	if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;
+	return mkret(c4_loop_port(ci, pp.portnum, pp.port_mode));
 }
 
 /* set the specified register with the given value / or just read it */
 static status_t
 do_framer_rw(struct net_device *ndev, void *data)
 {
-    struct sbecom_port_param pp;
-    ci_t       *ci;
-    int         ret;
-
-    if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;
-    ret = mkret(c4_frame_rw(ci, &pp));
-    if (ret)
-        return ret;
-    if (copy_to_user(data, &pp, sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    return 0;
+	struct sbecom_port_param pp;
+	ci_t       *ci;
+	int         ret;
+
+	if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;
+	ret = mkret(c4_frame_rw(ci, &pp));
+	if (ret)
+		return ret;
+	if (copy_to_user(data, &pp, sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	return 0;
 }
 
 /* set the specified register with the given value / or just read it */
 static status_t
 do_pld_rw(struct net_device *ndev, void *data)
 {
-    struct sbecom_port_param pp;
-    ci_t       *ci;
-    int         ret;
-
-    if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;
-    ret = mkret(c4_pld_rw(ci, &pp));
-    if (ret)
-        return ret;
-    if (copy_to_user(data, &pp, sizeof(struct sbecom_port_param)))
-        return -EFAULT;
-    return 0;
+	struct sbecom_port_param pp;
+	ci_t       *ci;
+	int         ret;
+
+	if (copy_from_user(&pp, data, sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;
+	ret = mkret(c4_pld_rw(ci, &pp));
+	if (ret)
+		return ret;
+	if (copy_to_user(data, &pp, sizeof(struct sbecom_port_param)))
+		return -EFAULT;
+	return 0;
 }
 
 /* set the specified register with the given value / or just read it */
 static status_t
 do_musycc_rw(struct net_device *ndev, void *data)
 {
-    struct c4_musycc_param mp;
-    ci_t       *ci;
-    int         ret;
-
-    if (copy_from_user(&mp, data, sizeof(struct c4_musycc_param)))
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;
-    ret = mkret(c4_musycc_rw(ci, &mp));
-    if (ret)
-        return ret;
-    if (copy_to_user(data, &mp, sizeof(struct c4_musycc_param)))
-        return -EFAULT;
-    return 0;
+	struct c4_musycc_param mp;
+	ci_t       *ci;
+	int         ret;
+
+	if (copy_from_user(&mp, data, sizeof(struct c4_musycc_param)))
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;
+	ret = mkret(c4_musycc_rw(ci, &mp));
+	if (ret)
+		return ret;
+	if (copy_to_user(data, &mp, sizeof(struct c4_musycc_param)))
+		return -EFAULT;
+	return 0;
 }
 
 static status_t
 do_get_chan(struct net_device *ndev, void *data)
 {
-    struct sbecom_chan_param cp;
-    int         ret;
+	struct sbecom_chan_param cp;
+	int         ret;
 
-    if (copy_from_user(&cp, data,
-                       sizeof(struct sbecom_chan_param)))
-        return -EFAULT;
+	if (copy_from_user(&cp, data,
+				sizeof(struct sbecom_chan_param)))
+		return -EFAULT;
 
-    if ((ret = mkret(c4_get_chan(cp.channum, &cp))))
-        return ret;
+	if ((ret = mkret(c4_get_chan(cp.channum, &cp))))
+		return ret;
 
-    if (copy_to_user(data, &cp, sizeof(struct sbecom_chan_param)))
-        return -EFAULT;
-    return 0;
+	if (copy_to_user(data, &cp, sizeof(struct sbecom_chan_param)))
+		return -EFAULT;
+	return 0;
 }
 
 static status_t
 do_set_chan(struct net_device *ndev, void *data)
 {
-    struct sbecom_chan_param cp;
-    int         ret;
-    ci_t       *ci;
-
-    if (copy_from_user(&cp, data, sizeof(struct sbecom_chan_param)))
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;
-    switch (ret = mkret(c4_set_chan(cp.channum, &cp)))
-    {
-    case 0:
-        return 0;
-    default:
-        return ret;
-    }
+	struct sbecom_chan_param cp;
+	int         ret;
+	ci_t       *ci;
+
+	if (copy_from_user(&cp, data, sizeof(struct sbecom_chan_param)))
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;
+	switch (ret = mkret(c4_set_chan(cp.channum, &cp)))
+	{
+	case 0:
+		return 0;
+	default:
+		return ret;
+	}
 }
 
 static status_t
 do_create_chan(struct net_device *ndev, void *data)
 {
-    ci_t       *ci;
-    struct net_device *dev;
-    struct sbecom_chan_param cp;
-    int         ret;
-
-    if (copy_from_user(&cp, data, sizeof(struct sbecom_chan_param)))
-        return -EFAULT;
-    ci = get_ci_by_dev(ndev);
-    if (!ci)
-        return -EINVAL;
-    dev = create_chan(ndev, ci, &cp);
-    if (!dev)
-        return -EBUSY;
-    ret = mkret(c4_new_chan(ci, cp.port, cp.channum, dev));
-    if (ret)
-    {
-        rtnl_unlock();             /* needed due to Ioctl calling sequence */
-        unregister_hdlc_device(dev);
-        rtnl_lock();               /* needed due to Ioctl calling sequence */
-        free_netdev(dev);
-    }
-    return ret;
+	ci_t       *ci;
+	struct net_device *dev;
+	struct sbecom_chan_param cp;
+	int         ret;
+
+	if (copy_from_user(&cp, data, sizeof(struct sbecom_chan_param)))
+		return -EFAULT;
+	ci = get_ci_by_dev(ndev);
+	if (!ci)
+		return -EINVAL;
+	dev = create_chan(ndev, ci, &cp);
+	if (!dev)
+		return -EBUSY;
+	ret = mkret(c4_new_chan(ci, cp.port, cp.channum, dev));
+	if (ret)
+	{
+		rtnl_unlock();             /* needed due to Ioctl calling sequence */
+		unregister_hdlc_device(dev);
+		rtnl_lock();               /* needed due to Ioctl calling sequence */
+		free_netdev(dev);
+	}
+	return ret;
 }
 
 static status_t
 do_get_chan_stats(struct net_device *ndev, void *data)
 {
-    struct c4_chan_stats_wrap ccs;
-    int         ret;
-
-    if (copy_from_user(&ccs, data,
-                       sizeof(struct c4_chan_stats_wrap)))
-        return -EFAULT;
-    switch (ret = mkret(c4_get_chan_stats(ccs.channum, &ccs.stats)))
-    {
-    case 0:
-        break;
-    default:
-        return ret;
-    }
-    if (copy_to_user(data, &ccs,
-                     sizeof(struct c4_chan_stats_wrap)))
-        return -EFAULT;
-    return 0;
+	struct c4_chan_stats_wrap ccs;
+	int         ret;
+
+	if (copy_from_user(&ccs, data,
+			   sizeof(struct c4_chan_stats_wrap)))
+		return -EFAULT;
+	switch (ret = mkret(c4_get_chan_stats(ccs.channum, &ccs.stats)))
+	{
+	case 0:
+		break;
+	default:
+		return ret;
+	}
+	if (copy_to_user(data, &ccs,
+			 sizeof(struct c4_chan_stats_wrap)))
+		return -EFAULT;
+	return 0;
 }
 static status_t
 do_set_loglevel(struct net_device *ndev, void *data)
 {
-    unsigned int cxt1e1_log_level;
+	unsigned int cxt1e1_log_level;
 
-    if (copy_from_user(&cxt1e1_log_level, data, sizeof(int)))
-        return -EFAULT;
-    sbecom_set_loglevel(cxt1e1_log_level);
-    return 0;
+	if (copy_from_user(&cxt1e1_log_level, data, sizeof(int)))
+		return -EFAULT;
+	sbecom_set_loglevel(cxt1e1_log_level);
+	return 0;
 }
 
 static status_t
 do_deluser(struct net_device *ndev, int lockit)
 {
-    if (ndev->flags & IFF_UP)
-        return -EBUSY;
-
-    {
-        ci_t       *ci;
-        mch_t      *ch;
-        const struct c4_priv *priv;
-        int         channum;
-
-        priv = (struct c4_priv *)dev_to_hdlc(ndev)->priv;
-        ci = priv->ci;
-        channum = priv->channum;
-
-        ch = c4_find_chan(channum);
-        if (ch == NULL)
-            return -ENOENT;
-	ch->user = NULL;	/* will be freed, below */
-    }
-
-    if (lockit)
-        rtnl_unlock();             /* needed if Ioctl calling sequence */
-    unregister_hdlc_device(ndev);
-    if (lockit)
-        rtnl_lock();               /* needed if Ioctl calling sequence */
-    free_netdev(ndev);
-    return 0;
+	if (ndev->flags & IFF_UP)
+		return -EBUSY;
+
+	{
+		ci_t       *ci;
+		mch_t      *ch;
+		const struct c4_priv *priv;
+		int         channum;
+
+		priv = (struct c4_priv *)dev_to_hdlc(ndev)->priv;
+		ci = priv->ci;
+		channum = priv->channum;
+
+		ch = c4_find_chan(channum);
+		if (ch == NULL)
+			return -ENOENT;
+		ch->user = NULL;	/* will be freed, below */
+	}
+
+	if (lockit)
+		rtnl_unlock();             /* needed if Ioctl calling sequence */
+	unregister_hdlc_device(ndev);
+	if (lockit)
+		rtnl_lock();               /* needed if Ioctl calling sequence */
+	free_netdev(ndev);
+	return 0;
 }
 
 int
 do_del_chan(struct net_device *musycc_dev, void *data)
 {
-    struct sbecom_chan_param cp;
-    char        buf[sizeof(CHANNAME) + 3];
-    struct net_device *dev;
-    int         ret;
-
-    if (copy_from_user(&cp, data,
-                       sizeof(struct sbecom_chan_param)))
-        return -EFAULT;
-    if (cp.channum > 999)
-        return -EINVAL;
-    snprintf(buf, sizeof(buf), CHANNAME "%d", cp.channum);
+	struct sbecom_chan_param cp;
+	char        buf[sizeof(CHANNAME) + 3];
+	struct net_device *dev;
+	int         ret;
+
+	if (copy_from_user(&cp, data,
+			   sizeof(struct sbecom_chan_param)))
+		return -EFAULT;
+	if (cp.channum > 999)
+		return -EINVAL;
+	snprintf(buf, sizeof(buf), CHANNAME "%d", cp.channum);
 	dev = __dev_get_by_name(&init_net, buf);
 	if (!dev)
 		return -ENODEV;
-    ret = do_deluser(dev, 1);
-    if (ret)
-        return ret;
-    return c4_del_chan(cp.channum);
+	ret = do_deluser(dev, 1);
+	if (ret)
+		return ret;
+	return c4_del_chan(cp.channum);
 }
 int c4_reset_board(void *);
 
 int
 do_reset(struct net_device *musycc_dev, void *data)
 {
-    const struct c4_priv *priv;
-    int         i;
-
-    for (i = 0; i < 128; i++)
-    {
-        struct net_device *ndev;
-        char        buf[sizeof(CHANNAME) + 3];
-
-        sprintf(buf, CHANNAME "%d", i);
-	ndev = __dev_get_by_name(&init_net, buf);
-	if (!ndev)
-		continue;
-        priv = dev_to_hdlc(ndev)->priv;
-
-        if ((unsigned long) (priv->ci) ==
-            (unsigned long) (netdev_priv(musycc_dev)))
-        {
-            ndev->flags &= ~IFF_UP;
-            netif_stop_queue(ndev);
-            do_deluser(ndev, 1);
+	const struct c4_priv *priv;
+	int         i;
+
+	for (i = 0; i < 128; i++)
+	{
+		struct net_device *ndev;
+		char        buf[sizeof(CHANNAME) + 3];
+
+		sprintf(buf, CHANNAME "%d", i);
+		ndev = __dev_get_by_name(&init_net, buf);
+		if (!ndev)
+			continue;
+		priv = dev_to_hdlc(ndev)->priv;
+
+		if ((unsigned long) (priv->ci) ==
+			(unsigned long) (netdev_priv(musycc_dev)))
+		{
+			ndev->flags &= ~IFF_UP;
+			netif_stop_queue(ndev);
+			do_deluser(ndev, 1);
+		}
 	}
-    }
-    return 0;
+	return 0;
 }
 
 int
 do_reset_chan_stats(struct net_device *musycc_dev, void *data)
 {
-    struct sbecom_chan_param cp;
+	struct sbecom_chan_param cp;
 
-    if (copy_from_user(&cp, data,
-                       sizeof(struct sbecom_chan_param)))
-        return -EFAULT;
-    return mkret(c4_del_chan_stats(cp.channum));
+	if (copy_from_user(&cp, data,
+			   sizeof(struct sbecom_chan_param)))
+		return -EFAULT;
+	return mkret(c4_del_chan_stats(cp.channum));
 }
 
 static status_t
 c4_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 {
-    ci_t       *ci;
-    void       *data;
-    int         iocmd, iolen;
-    status_t    ret;
-    static struct data
-    {
-        union
-        {
-            u_int8_t c;
-            u_int32_t i;
-            struct sbe_brd_info bip;
-            struct sbe_drv_info dip;
-            struct sbe_iid_info iip;
-            struct sbe_brd_addr bap;
-            struct sbecom_chan_stats stats;
-            struct sbecom_chan_param param;
-            struct temux_card_stats cards;
-            struct sbecom_card_param cardp;
-            struct sbecom_framer_param frp;
-        }           u;
-    }           arg;
-
-
-    if (!capable(CAP_SYS_ADMIN))
-        return -EPERM;
-    if (cmd != SIOCDEVPRIVATE + 15)
-        return -EINVAL;
-    if (!(ci = get_ci_by_dev(ndev)))
-        return -EINVAL;
-    if (ci->state != C_RUNNING)
-        return -ENODEV;
-    if (copy_from_user(&iocmd, ifr->ifr_data, sizeof(iocmd)))
-        return -EFAULT;
+	ci_t       *ci;
+	void       *data;
+	int         iocmd, iolen;
+	status_t    ret;
+	static struct data
+	{
+		union
+		{
+			u_int8_t c;
+			u_int32_t i;
+			struct sbe_brd_info bip;
+			struct sbe_drv_info dip;
+			struct sbe_iid_info iip;
+			struct sbe_brd_addr bap;
+			struct sbecom_chan_stats stats;
+			struct sbecom_chan_param param;
+			struct temux_card_stats cards;
+			struct sbecom_card_param cardp;
+			struct sbecom_framer_param frp;
+		} u;
+	} arg;
+
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (cmd != SIOCDEVPRIVATE + 15)
+		return -EINVAL;
+	if (!(ci = get_ci_by_dev(ndev)))
+		return -EINVAL;
+	if (ci->state != C_RUNNING)
+		return -ENODEV;
+	if (copy_from_user(&iocmd, ifr->ifr_data, sizeof(iocmd)))
+		return -EFAULT;
 #if 0
-    if (copy_from_user(&len, ifr->ifr_data + sizeof(iocmd), sizeof(len)))
-        return -EFAULT;
+	if (copy_from_user(&len, ifr->ifr_data + sizeof(iocmd), sizeof(len)))
+		return -EFAULT;
 #endif
 
 #if 0
-    pr_info("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
-            _IOC_DIR(iocmd), _IOC_TYPE(iocmd), _IOC_NR(iocmd),
-            _IOC_SIZE(iocmd));
+	pr_info("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
+		_IOC_DIR(iocmd), _IOC_TYPE(iocmd), _IOC_NR(iocmd),
+		_IOC_SIZE(iocmd));
 #endif
-    iolen = _IOC_SIZE(iocmd);
-    data = ifr->ifr_data + sizeof(iocmd);
-    if (copy_from_user(&arg, data, iolen))
-        return -EFAULT;
-
-    ret = 0;
-    switch (iocmd)
-    {
-    case SBE_IOC_PORT_GET:
-        //pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
-        ret = do_get_port(ndev, data);
-        break;
-    case SBE_IOC_PORT_SET:
-        //pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
-        ret = do_set_port(ndev, data);
-        break;
-    case SBE_IOC_CHAN_GET:
-        //pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
-        ret = do_get_chan(ndev, data);
-        break;
-    case SBE_IOC_CHAN_SET:
-        //pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
-        ret = do_set_chan(ndev, data);
-        break;
-    case C4_DEL_CHAN:
-        //pr_info(">> C4_DEL_CHAN Ioctl...\n");
-        ret = do_del_chan(ndev, data);
-        break;
-    case SBE_IOC_CHAN_NEW:
-        ret = do_create_chan(ndev, data);
-        break;
-    case SBE_IOC_CHAN_GET_STAT:
-        ret = do_get_chan_stats(ndev, data);
-        break;
-    case SBE_IOC_LOGLEVEL:
-        ret = do_set_loglevel(ndev, data);
-        break;
-    case SBE_IOC_RESET_DEV:
-        ret = do_reset(ndev, data);
-        break;
-    case SBE_IOC_CHAN_DEL_STAT:
-        ret = do_reset_chan_stats(ndev, data);
-        break;
-    case C4_LOOP_PORT:
-        ret = do_port_loop(ndev, data);
-        break;
-    case C4_RW_FRMR:
-        ret = do_framer_rw(ndev, data);
-        break;
-    case C4_RW_MSYC:
-        ret = do_musycc_rw(ndev, data);
-        break;
-    case C4_RW_PLD:
-        ret = do_pld_rw(ndev, data);
-        break;
-    case SBE_IOC_IID_GET:
-        ret = (iolen == sizeof(struct sbe_iid_info)) ? c4_get_iidinfo(ci, &arg.u.iip) : -EFAULT;
-        if (ret == 0)               /* no error, copy data */
-            if (copy_to_user(data, &arg, iolen))
-                return -EFAULT;
-        break;
-    default:
-        //pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
-        ret = -EINVAL;
-        break;
-    }
-    return mkret(ret);
+	iolen = _IOC_SIZE(iocmd);
+	data = ifr->ifr_data + sizeof(iocmd);
+	if (copy_from_user(&arg, data, iolen))
+		return -EFAULT;
+
+	ret = 0;
+	switch (iocmd)
+	{
+	case SBE_IOC_PORT_GET:
+		//pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
+		ret = do_get_port(ndev, data);
+		break;
+	case SBE_IOC_PORT_SET:
+		//pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
+		ret = do_set_port(ndev, data);
+		break;
+	case SBE_IOC_CHAN_GET:
+		//pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
+		ret = do_get_chan(ndev, data);
+		break;
+	case SBE_IOC_CHAN_SET:
+		//pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
+		ret = do_set_chan(ndev, data);
+		break;
+	case C4_DEL_CHAN:
+		//pr_info(">> C4_DEL_CHAN Ioctl...\n");
+		ret = do_del_chan(ndev, data);
+		break;
+	case SBE_IOC_CHAN_NEW:
+		ret = do_create_chan(ndev, data);
+		break;
+	case SBE_IOC_CHAN_GET_STAT:
+		ret = do_get_chan_stats(ndev, data);
+		break;
+	case SBE_IOC_LOGLEVEL:
+		ret = do_set_loglevel(ndev, data);
+		break;
+	case SBE_IOC_RESET_DEV:
+		ret = do_reset(ndev, data);
+		break;
+	case SBE_IOC_CHAN_DEL_STAT:
+		ret = do_reset_chan_stats(ndev, data);
+		break;
+	case C4_LOOP_PORT:
+		ret = do_port_loop(ndev, data);
+		break;
+	case C4_RW_FRMR:
+		ret = do_framer_rw(ndev, data);
+		break;
+	case C4_RW_MSYC:
+		ret = do_musycc_rw(ndev, data);
+		break;
+	case C4_RW_PLD:
+		ret = do_pld_rw(ndev, data);
+		break;
+	case SBE_IOC_IID_GET:
+		ret = (iolen == sizeof(struct sbe_iid_info)) ? c4_get_iidinfo(ci, &arg.u.iip) : -EFAULT;
+		if (ret == 0)               /* no error, copy data */
+			if (copy_to_user(data, &arg, iolen))
+				return -EFAULT;
+		break;
+	default:
+		//pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
+		ret = -EINVAL;
+		break;
+	}
+	return mkret(ret);
 }
 
 static const struct net_device_ops c4_ops = {
-       .ndo_open       = void_open,
-       .ndo_start_xmit = c4_linux_xmit,
-       .ndo_do_ioctl   = c4_ioctl,
+	.ndo_open       = void_open,
+	.ndo_start_xmit = c4_linux_xmit,
+	.ndo_do_ioctl   = c4_ioctl,
 };
 
 static void c4_setup(struct net_device *dev)
 {
-       dev->type = ARPHRD_VOID;
-       dev->netdev_ops = &c4_ops;
+	dev->type = ARPHRD_VOID;
+	dev->netdev_ops = &c4_ops;
 }
 
 struct net_device *__init
 c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
-           int irq0, int irq1)
+	   int irq0, int irq1)
 {
-    struct net_device *ndev;
-    ci_t       *ci;
-
-    ndev = alloc_netdev(sizeof(ci_t), SBE_IFACETMPL, c4_setup);
-    if (!ndev)
-    {
-        pr_warning("%s: no memory for struct net_device !\n", hi->devname);
-        error_flag = ENOMEM;
-	return NULL;
-    }
-    ci = (ci_t *)(netdev_priv(ndev));
-    ndev->irq = irq0;
-
-    ci->hdw_info = hi;
-    ci->state = C_INIT;         /* mark as hardware not available */
-    ci->next = c4_list;
-    c4_list = ci;
-    ci->brdno = ci->next ? ci->next->brdno + 1 : 0;
-
-    if (!CI)
-        CI = ci;                    /* DEBUG, only board 0 usage */
-
-    strcpy(ci->devname, hi->devname);
-    ci->release = &pmcc4_OSSI_release[0];
-
-    /* tasklet */
+	struct net_device *ndev;
+	ci_t       *ci;
+
+	ndev = alloc_netdev(sizeof(ci_t), SBE_IFACETMPL, c4_setup);
+	if (!ndev)
+	{
+		pr_warning("%s: no memory for struct net_device !\n", hi->devname);
+		error_flag = ENOMEM;
+		return NULL;
+	}
+	ci = (ci_t *)(netdev_priv(ndev));
+	ndev->irq = irq0;
+
+	ci->hdw_info = hi;
+	ci->state = C_INIT;         /* mark as hardware not available */
+	ci->next = c4_list;
+	c4_list = ci;
+	ci->brdno = ci->next ? ci->next->brdno + 1 : 0;
+
+	if (!CI)
+		CI = ci;                    /* DEBUG, only board 0 usage */
+
+	strcpy(ci->devname, hi->devname);
+	ci->release = &pmcc4_OSSI_release[0];
+
+	/* tasklet */
 #if defined(SBE_ISR_TASKLET)
-    tasklet_init(&ci->ci_musycc_isr_tasklet,
-                 (void (*) (unsigned long)) musycc_intr_bh_tasklet,
-                 (unsigned long) ci);
+	tasklet_init(&ci->ci_musycc_isr_tasklet,
+		     (void (*) (unsigned long)) musycc_intr_bh_tasklet,
+		     (unsigned long) ci);
 
-    if (atomic_read(&ci->ci_musycc_isr_tasklet.count) == 0)
-        tasklet_disable_nosync(&ci->ci_musycc_isr_tasklet);
+	if (atomic_read(&ci->ci_musycc_isr_tasklet.count) == 0)
+		tasklet_disable_nosync(&ci->ci_musycc_isr_tasklet);
 #elif defined(SBE_ISR_IMMEDIATE)
-    ci->ci_musycc_isr_tq.routine = (void *)(unsigned long)musycc_intr_bh_tasklet;
-    ci->ci_musycc_isr_tq.data = ci;
+	ci->ci_musycc_isr_tq.routine = (void *)(unsigned long)musycc_intr_bh_tasklet;
+	ci->ci_musycc_isr_tq.data = ci;
 #endif
 
 
-    if (register_netdev(ndev) ||
-        (c4_init(ci, (u_char *) f0, (u_char *) f1) != SBE_DRVR_SUCCESS))
-    {
-        OS_kfree(netdev_priv(ndev));
-        OS_kfree(ndev);
-        error_flag = ENODEV;
-	return NULL;
-    }
-    /*************************************************************
-     *  int request_irq(unsigned int irq,
-     *                  void (*handler)(int, void *, struct pt_regs *),
-     *                  unsigned long flags, const char *dev_name, void *dev_id);
-     *  wherein:
-     *  irq      -> The interrupt number that is being requested.
-     *  handler  -> Pointer to handling function being installed.
-     *  flags    -> A bit mask of options related to interrupt management.
-     *  dev_name -> String used in /proc/interrupts to show owner of interrupt.
-     *  dev_id   -> Pointer (for shared interrupt lines) to point to its own
-     *              private data area (to identify which device is interrupting).
-     *
-     *  extern void free_irq(unsigned int irq, void *dev_id);
-     **************************************************************/
-
-    if (request_irq(irq0, &c4_linux_interrupt,
-                    IRQF_SHARED,
-                    ndev->name, ndev))
-    {
-        pr_warning("%s: MUSYCC could not get irq: %d\n", ndev->name, irq0);
-        unregister_netdev(ndev);
-        OS_kfree(netdev_priv(ndev));
-        OS_kfree(ndev);
-        error_flag = EIO;
-	return NULL;
-    }
+	if (register_netdev(ndev) ||
+		(c4_init(ci, (u_char *) f0, (u_char *) f1) != SBE_DRVR_SUCCESS))
+	{
+		OS_kfree(netdev_priv(ndev));
+		OS_kfree(ndev);
+		error_flag = ENODEV;
+		return NULL;
+	}
+	/*************************************************************
+	 *  int request_irq(unsigned int irq,
+	 *                  void (*handler)(int, void *, struct pt_regs *),
+	 *                  unsigned long flags, const char *dev_name, void *dev_id);
+	 *  wherein:
+	 *  irq      -> The interrupt number that is being requested.
+	 *  handler  -> Pointer to handling function being installed.
+	 *  flags    -> A bit mask of options related to interrupt management.
+	 *  dev_name -> String used in /proc/interrupts to show owner of interrupt.
+	 *  dev_id   -> Pointer (for shared interrupt lines) to point to its own
+	 *              private data area (to identify which device is interrupting).
+	 *
+	 *  extern void free_irq(unsigned int irq, void *dev_id);
+	 **************************************************************/
+
+	if (request_irq(irq0, &c4_linux_interrupt,
+			IRQF_SHARED,
+			ndev->name, ndev))
+	{
+		pr_warning("%s: MUSYCC could not get irq: %d\n", ndev->name, irq0);
+		unregister_netdev(ndev);
+		OS_kfree(netdev_priv(ndev));
+		OS_kfree(ndev);
+		error_flag = EIO;
+		return NULL;
+	}
 #ifdef CONFIG_SBE_PMCC4_NCOMM
-    if (request_irq(irq1, &c4_ebus_interrupt, IRQF_SHARED, ndev->name, ndev))
-    {
-        pr_warning("%s: EBUS could not get irq: %d\n", hi->devname, irq1);
-        unregister_netdev(ndev);
-        free_irq(irq0, ndev);
-        OS_kfree(netdev_priv(ndev));
-        OS_kfree(ndev);
-        error_flag = EIO;
-	return NULL;
-    }
+	if (request_irq(irq1, &c4_ebus_interrupt, IRQF_SHARED, ndev->name, ndev))
+	{
+		pr_warning("%s: EBUS could not get irq: %d\n", hi->devname, irq1);
+		unregister_netdev(ndev);
+		free_irq(irq0, ndev);
+		OS_kfree(netdev_priv(ndev));
+		OS_kfree(ndev);
+		error_flag = EIO;
+		return NULL;
+	}
 #endif
 
-    /* setup board identification information */
-
-    {
-        u_int32_t   tmp;
-
-        hdw_sn_get(hi, brdno);     /* also sets PROM format type (promfmt)
-                                     * for later usage */
-
-        switch (hi->promfmt)
-        {
-        case PROM_FORMAT_TYPE1:
-            memcpy(ndev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
-            memcpy(&tmp, (FLD_TYPE1 *) (hi->mfg_info.pft1.Id), 4);     /* unaligned data
-                                                                         * acquisition */
-            ci->brd_id = cpu_to_be32(tmp);
-            break;
-        case PROM_FORMAT_TYPE2:
-            memcpy(ndev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
-            memcpy(&tmp, (FLD_TYPE2 *) (hi->mfg_info.pft2.Id), 4);     /* unaligned data
-                                                                         * acquisition */
-            ci->brd_id = cpu_to_be32(tmp);
-            break;
-        default:
-            ci->brd_id = 0;
-            memset(ndev->dev_addr, 0, 6);
-            break;
-        }
+	/* setup board identification information */
+
+	{
+		u_int32_t   tmp;
+
+		/* also sets PROM format type (promfmt) for later usage */
+		hdw_sn_get(hi, brdno);
+
+		switch (hi->promfmt)
+		{
+		case PROM_FORMAT_TYPE1:
+			memcpy(ndev->dev_addr, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
+			/* unaligned data acquisition */
+			memcpy(&tmp, (FLD_TYPE1 *) (hi->mfg_info.pft1.Id), 4);
+			ci->brd_id = cpu_to_be32(tmp);
+			break;
+		case PROM_FORMAT_TYPE2:
+			memcpy(ndev->dev_addr, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
+			/* unaligned data acquisition */
+			memcpy(&tmp, (FLD_TYPE2 *) (hi->mfg_info.pft2.Id), 4);
+			ci->brd_id = cpu_to_be32(tmp);
+			break;
+		default:
+			ci->brd_id = 0;
+			memset(ndev->dev_addr, 0, 6);
+			break;
+		}
 
 #if 1
-        sbeid_set_hdwbid(ci);      /* requires bid to be preset */
+		/* requires bid to be preset */
+		sbeid_set_hdwbid(ci);
 #else
-        sbeid_set_bdtype(ci);      /* requires hdw_bid to be preset */
+		/* requires hdw_bid to be preset */
+		sbeid_set_bdtype(ci);
 #endif
-
-    }
+	}
 
 #ifdef CONFIG_PROC_FS
-    sbecom_proc_brd_init(ci);
+	sbecom_proc_brd_init(ci);
 #endif
 #if defined(SBE_ISR_TASKLET)
-    tasklet_enable(&ci->ci_musycc_isr_tasklet);
+	tasklet_enable(&ci->ci_musycc_isr_tasklet);
 #endif
 
 
-    if ((error_flag = c4_init2(ci)) != SBE_DRVR_SUCCESS)
-    {
+	if ((error_flag = c4_init2(ci)) != SBE_DRVR_SUCCESS)
+	{
 #ifdef CONFIG_PROC_FS
-        sbecom_proc_brd_cleanup(ci);
+		sbecom_proc_brd_cleanup(ci);
 #endif
-        unregister_netdev(ndev);
-        free_irq(irq1, ndev);
-        free_irq(irq0, ndev);
-        OS_kfree(netdev_priv(ndev));
-        OS_kfree(ndev);
-	return NULL;		/* failure, error_flag is set */
-    }
-    return ndev;
+		unregister_netdev(ndev);
+		free_irq(irq1, ndev);
+		free_irq(irq0, ndev);
+		OS_kfree(netdev_priv(ndev));
+		OS_kfree(ndev);
+		/* failure, error_flag is set */
+		return NULL;
+	}
+	return ndev;
 }
 
 static int  __init
 c4_mod_init(void)
 {
-    int         rtn;
-
-    pr_warning("%s\n", pmcc4_OSSI_release);
-    if ((rtn = c4hw_attach_all()))
-        return -rtn;                /* installation failure - see system log */
-
-    /* housekeeping notifications */
-    if (cxt1e1_log_level != log_level_default)
-        pr_info("NOTE: driver parameter <cxt1e1_log_level> changed from default %d to %d.\n",
-                log_level_default, cxt1e1_log_level);
-       if (cxt1e1_max_mru != max_mru_default)
-               pr_info("NOTE: driver parameter <cxt1e1_max_mru> changed from default %d to %d.\n",
-                               max_mru_default, cxt1e1_max_mru);
-       if (cxt1e1_max_mtu != max_mtu_default)
-               pr_info("NOTE: driver parameter <cxt1e1_max_mtu> changed from default %d to %d.\n",
-                               max_mtu_default, cxt1e1_max_mtu);
-    if (max_rxdesc_used != max_rxdesc_default)
-    {
-        if (max_rxdesc_used > 2000)
-            max_rxdesc_used = 2000; /* out-of-bounds reset */
-        pr_info("NOTE: driver parameter <max_rxdesc_used> changed from default %d to %d.\n",
-                max_rxdesc_default, max_rxdesc_used);
-    }
-    if (max_txdesc_used != max_txdesc_default)
-    {
-        if (max_txdesc_used > 1000)
-            max_txdesc_used = 1000; /* out-of-bounds reset */
-        pr_info("NOTE: driver parameter <max_txdesc_used> changed from default %d to %d.\n",
-                max_txdesc_default, max_txdesc_used);
-    }
-    return 0;                       /* installation success */
+	int         rtn;
+
+	pr_warning("%s\n", pmcc4_OSSI_release);
+	if ((rtn = c4hw_attach_all()))
+		return -rtn;                /* installation failure - see system log */
+
+	/* housekeeping notifications */
+	if (cxt1e1_log_level != log_level_default)
+		pr_info("NOTE: driver parameter <cxt1e1_log_level> changed from default %d to %d.\n",
+			log_level_default, cxt1e1_log_level);
+	if (cxt1e1_max_mru != max_mru_default)
+		pr_info("NOTE: driver parameter <cxt1e1_max_mru> changed from default %d to %d.\n",
+			max_mru_default, cxt1e1_max_mru);
+	if (cxt1e1_max_mtu != max_mtu_default)
+		pr_info("NOTE: driver parameter <cxt1e1_max_mtu> changed from default %d to %d.\n",
+			max_mtu_default, cxt1e1_max_mtu);
+	if (max_rxdesc_used != max_rxdesc_default)
+	{
+		if (max_rxdesc_used > 2000)
+			max_rxdesc_used = 2000; /* out-of-bounds reset */
+		pr_info("NOTE: driver parameter <max_rxdesc_used> changed from default %d to %d.\n",
+			max_rxdesc_default, max_rxdesc_used);
+	}
+	if (max_txdesc_used != max_txdesc_default)
+	{
+		if (max_txdesc_used > 1000)
+			max_txdesc_used = 1000; /* out-of-bounds reset */
+		pr_info("NOTE: driver parameter <max_txdesc_used> changed from default %d to %d.\n",
+			max_txdesc_default, max_txdesc_used);
+	}
+	return 0;                       /* installation success */
 }
 
 
@@ -1140,24 +1148,24 @@ c4_mod_init(void)
 static void __exit
 cleanup_hdlc(void)
 {
-    hdw_info_t *hi;
-    ci_t       *ci;
-    struct net_device *ndev;
-    int         i, j, k;
-
-    for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-    {
-        if (hi->ndev)               /* a board has been attached */
-        {
-            ci = (ci_t *)(netdev_priv(hi->ndev));
-            for (j = 0; j < ci->max_port; j++)
-                for (k = 0; k < MUSYCC_NCHANS; k++)
-                    if ((ndev = ci->port[j].chan[k]->user))
-                    {
-                        do_deluser(ndev, 0);
-                    }
-        }
-    }
+	hdw_info_t *hi;
+	ci_t       *ci;
+	struct net_device *ndev;
+	int         i, j, k;
+
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
+	{
+		if (hi->ndev)               /* a board has been attached */
+		{
+			ci = (ci_t *)(netdev_priv(hi->ndev));
+			for (j = 0; j < ci->max_port; j++)
+				for (k = 0; k < MUSYCC_NCHANS; k++)
+					if ((ndev = ci->port[j].chan[k]->user))
+					{
+						do_deluser(ndev, 0);
+					}
+		}
+	}
 }
 
 
-- 
1.7.4.4


