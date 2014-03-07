Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaCGAB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:01:57 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52701 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaCGABz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:01:55 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shaun@xresource.ca, sachin.kamat@linaro.org,
        dulshani.gunawardhana89@gmail.com, ying.xue@windriver.com,
        dan.carpenter@oracle.com, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: cxt1e1: fix checkpatch errors with open brace '{'
Date: Fri, 07 Mar 2014 09:01:51 +0900
Message-ID: <2470694.qI6ANDm9f8@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up checkpatch.pl error in linux.c:
 ERROR: that open brace { should be on the previous line

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |   67 ++++++++++++---------------------------
 1 files changed, 21 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 4eadd29..549efd1 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -241,8 +241,7 @@ c4_wq_port_cleanup(mpi_t *pi)
 	 * PORT POINT: cannot call this if WQ is statically allocated w/in
 	 * structure since it calls kfree(wq);
 	 */
-	if (pi->wq_port)
-	{
+	if (pi->wq_port) {
 		destroy_workqueue(pi->wq_port);        /* this also calls
 							* flush_workqueue() */
 		pi->wq_port = NULL;
@@ -432,15 +431,13 @@ create_chan(struct net_device *ndev, ci_t *ci,
 
 		/* allocate then fill in private data structure */
 		priv = OS_kmalloc(sizeof(struct c4_priv));
-		if (!priv)
-		{
+		if (!priv) {
 			pr_warning("%s: no memory for net_device !\n",
 				   ci->devname);
 			return NULL;
 		}
 		dev = alloc_hdlcdev(priv);
-		if (!dev)
-		{
+		if (!dev) {
 			pr_warning("%s: no memory for hdlc_device !\n",
 				   ci->devname);
 			OS_kfree(priv);
@@ -458,10 +455,8 @@ create_chan(struct net_device *ndev, ci_t *ci,
 	*dev->name = 0;                 /* default ifconfig name = "hdlc" */
 
 	hi = (hdw_info_t *)ci->hdw_info;
-	if (hi->mfg_info_sts == EEPROM_OK)
-	{
-		switch (hi->promfmt)
-		{
+	if (hi->mfg_info_sts == EEPROM_OK) {
+		switch (hi->promfmt) {
 		case PROM_FORMAT_TYPE1:
 			memcpy(dev->dev_addr,
 			       (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
@@ -475,9 +470,7 @@ create_chan(struct net_device *ndev, ci_t *ci,
 			break;
 		}
 	} else
-	{
 		memset(dev->dev_addr, 0, 6);
-	}
 
 	hdlc->xmit = c4_linux_xmit;
 
@@ -501,8 +494,7 @@ create_chan(struct net_device *ndev, ci_t *ci,
 
 	/* needed due to Ioctl calling sequence */
 	rtnl_lock();
-	if (ret)
-	{
+	if (ret) {
 		if (cxt1e1_log_level >= LOG_WARN)
 			pr_info("%s: create_chan[%d] registration error = %d.\n",
 				ci->devname, cp->channum, ret);
@@ -697,8 +689,7 @@ do_create_chan(struct net_device *ndev, void *data)
 	if (!dev)
 		return -EBUSY;
 	ret = mkret(c4_new_chan(ci, cp.port, cp.channum, dev));
-	if (ret)
-	{
+	if (ret) {
 		/* needed due to Ioctl calling sequence */
 		rtnl_unlock();
 		unregister_hdlc_device(dev);
@@ -804,8 +795,7 @@ do_reset(struct net_device *musycc_dev, void *data)
 	const struct c4_priv *priv;
 	int         i;
 
-	for (i = 0; i < 128; i++)
-	{
+	for (i = 0; i < 128; i++) {
 		struct net_device *ndev;
 		char        buf[sizeof(CHANNAME) + 3];
 
@@ -816,8 +806,7 @@ do_reset(struct net_device *musycc_dev, void *data)
 		priv = dev_to_hdlc(ndev)->priv;
 
 		if ((unsigned long) (priv->ci) ==
-			(unsigned long) (netdev_priv(musycc_dev)))
-		{
+			(unsigned long) (netdev_priv(musycc_dev))) {
 			ndev->flags &= ~IFF_UP;
 			netif_stop_queue(ndev);
 			do_deluser(ndev, 1);
@@ -844,10 +833,8 @@ c4_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 	void       *data;
 	int         iocmd, iolen;
 	status_t    ret;
-	static struct data
-	{
-		union
-		{
+	static struct data {
+		union {
 			u_int8_t c;
 			u_int32_t i;
 			struct sbe_brd_info bip;
@@ -890,8 +877,7 @@ c4_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 		return -EFAULT;
 
 	ret = 0;
-	switch (iocmd)
-	{
+	switch (iocmd) {
 	case SBE_IOC_PORT_GET:
 		//pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
 		ret = do_get_port(ndev, data);
@@ -974,8 +960,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 	ci_t       *ci;
 
 	ndev = alloc_netdev(sizeof(ci_t), SBE_IFACETMPL, c4_setup);
-	if (!ndev)
-	{
+	if (!ndev) {
 		pr_warning("%s: no memory for struct net_device !\n",
 			   hi->devname);
 		error_flag = ENOMEM;
@@ -1010,8 +995,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 
 
 	if (register_netdev(ndev) ||
-		(c4_init(ci, (u_char *) f0, (u_char *) f1) != SBE_DRVR_SUCCESS))
-	{
+		(c4_init(ci, (u_char *) f0, (u_char *) f1) != SBE_DRVR_SUCCESS)) {
 		OS_kfree(netdev_priv(ndev));
 		OS_kfree(ndev);
 		error_flag = ENODEV;
@@ -1034,8 +1018,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 
 	if (request_irq(irq0, &c4_linux_interrupt,
 			IRQF_SHARED,
-			ndev->name, ndev))
-	{
+			ndev->name, ndev)) {
 		pr_warning("%s: MUSYCC could not get irq: %d\n",
 			   ndev->name, irq0);
 		unregister_netdev(ndev);
@@ -1045,8 +1028,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		return NULL;
 	}
 #ifdef CONFIG_SBE_PMCC4_NCOMM
-	if (request_irq(irq1, &c4_ebus_interrupt, IRQF_SHARED, ndev->name, ndev))
-	{
+	if (request_irq(irq1, &c4_ebus_interrupt, IRQF_SHARED, ndev->name, ndev)) {
 		pr_warning("%s: EBUS could not get irq: %d\n", hi->devname, irq1);
 		unregister_netdev(ndev);
 		free_irq(irq0, ndev);
@@ -1065,8 +1047,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		/* also sets PROM format type (promfmt) for later usage */
 		hdw_sn_get(hi, brdno);
 
-		switch (hi->promfmt)
-		{
+		switch (hi->promfmt) {
 		case PROM_FORMAT_TYPE1:
 			memcpy(ndev->dev_addr,
 			       (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
@@ -1138,15 +1119,13 @@ c4_mod_init(void)
 	if (cxt1e1_max_mtu != max_mtu_default)
 		pr_info("NOTE: driver parameter <cxt1e1_max_mtu> changed from default %d to %d.\n",
 			max_mtu_default, cxt1e1_max_mtu);
-	if (max_rxdesc_used != max_rxdesc_default)
-	{
+	if (max_rxdesc_used != max_rxdesc_default) {
 		if (max_rxdesc_used > 2000)
 			max_rxdesc_used = 2000; /* out-of-bounds reset */
 		pr_info("NOTE: driver parameter <max_rxdesc_used> changed from default %d to %d.\n",
 			max_rxdesc_default, max_rxdesc_used);
 	}
-	if (max_txdesc_used != max_txdesc_default)
-	{
+	if (max_txdesc_used != max_txdesc_default) {
 		if (max_txdesc_used > 1000)
 			max_txdesc_used = 1000; /* out-of-bounds reset */
 		pr_info("NOTE: driver parameter <max_txdesc_used> changed from default %d to %d.\n",
@@ -1169,18 +1148,14 @@ cleanup_hdlc(void)
 	struct net_device *ndev;
 	int         i, j, k;
 
-	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
-	{
-		if (hi->ndev)               /* a board has been attached */
-		{
+	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++) {
+		if (hi->ndev) {          /* a board has been attached */
 			ci = (ci_t *)(netdev_priv(hi->ndev));
 			for (j = 0; j < ci->max_port; j++)
 				for (k = 0; k < MUSYCC_NCHANS; k++) {
 					ndev = ci->port[j].chan[k]->user;
 					if (ndev)
-					{
 						do_deluser(ndev, 0);
-					}
 				}
 		}
 	}
-- 
1.7.4.4


