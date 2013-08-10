Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525Ab3HJPkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:40:43 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21362
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934415Ab3HJPke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:40:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="23671835"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] trivial: convert comma to semicolon
Date: Sat, 10 Aug 2013 17:40:25 +0200
Message-Id: <1376149225-3997-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace a comma between expression statements by a semicolon.

These cases have the comma in a single statement if branch, or following a
preprocessor directive.  They mostly needed some manual touching up of
whitespace and newlines.

A simplified version of the semantic patch that performs this
transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression e1,e2,e;
type T;
identifier i;
@@

 e1
-,
+;
 e2;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
v2, more complete than the previous attempt.

 arch/arm/mach-ixp4xx/ixdp425-setup.c |    2 
 drivers/net/wan/sbni.c               |  102 +++++++++++++++++++----------------
 drivers/scsi/arm/cumana_2.c          |   13 ++--
 drivers/scsi/arm/eesox.c             |    9 +--
 drivers/scsi/arm/powertec.c          |    9 +--
 fs/xfs/xfs_attr_remote.c             |    4 -
 6 files changed, 77 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/ixdp425-setup.c b/arch/arm/mach-ixp4xx/ixdp425-setup.c
index 22d688b..d241002 100644
--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
+++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -224,7 +224,7 @@ static void __init ixdp425_init(void)
 
 #if defined(CONFIG_MTD_NAND_PLATFORM) || \
     defined(CONFIG_MTD_NAND_PLATFORM_MODULE)
-	ixdp425_flash_nand_resource.start = IXP4XX_EXP_BUS_BASE(3),
+	ixdp425_flash_nand_resource.start = IXP4XX_EXP_BUS_BASE(3);
 	ixdp425_flash_nand_resource.end   = IXP4XX_EXP_BUS_BASE(3) + 0x10 - 1;
 
 	gpio_line_config(IXDP425_NAND_NCE_PIN, IXP4XX_GPIO_OUT);
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index d43f4ef..54ee5cf 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -262,10 +262,10 @@ static int __init sbni_init(struct net_device *dev)
 		return  sbni_isa_probe( dev );
 	/* otherwise we have to perform search our adapter */
 
-	if( io[ num ] != -1 )
-		dev->base_addr	= io[ num ],
-		dev->irq	= irq[ num ];
-	else if( scandone  ||  io[ 0 ] != -1 )
+	if (io[num] != -1) {
+		dev->base_addr	= io[num];
+		dev->irq	= irq[num];
+	} else if (scandone || io[0] != -1)
 		return  -ENODEV;
 
 	/* if io[ num ] contains non-zero address, then that is on ISA bus */
@@ -401,10 +401,12 @@ sbni_probe1( struct net_device  *dev,  unsigned long  ioaddr,  int  irq )
 	nl->maxframe  = DEFAULT_FRAME_LEN;
 	nl->csr1.rate = baud[ num ];
 
-	if( (nl->cur_rxl_index = rxl[ num ]) == -1 )
+	nl->cur_rxl_index = rxl[num];
+	if (nl->cur_rxl_index == -1) {
 		/* autotune rxl */
-		nl->cur_rxl_index = DEF_RXL,
+		nl->cur_rxl_index = DEF_RXL;
 		nl->delta_rxl = DEF_RXL_DELTA;
+	}
 	else
 		nl->delta_rxl = 0;
 	nl->csr1.rxl  = rxl_tab[ nl->cur_rxl_index ];
@@ -514,13 +516,15 @@ sbni_interrupt( int  irq,  void  *dev_id )
 
 	do {
 		repeat = 0;
-		if( inb( dev->base_addr + CSR0 ) & (RC_RDY | TR_RDY) )
-			handle_channel( dev ),
+		if (inb(dev->base_addr + CSR0) & (RC_RDY | TR_RDY)) {
+			handle_channel(dev);
 			repeat = 1;
-		if( nl->second  && 	/* second channel present */
-		    (inb( nl->second->base_addr+CSR0 ) & (RC_RDY | TR_RDY)) )
-			handle_channel( nl->second ),
+		}
+		if (nl->second  && 	/* second channel present */
+		    (inb(nl->second->base_addr+CSR0) & (RC_RDY | TR_RDY))) {
+			handle_channel(nl->second);
 			repeat = 1;
+		}
 	} while( repeat );
 
 	if( nl->second )
@@ -612,11 +616,12 @@ recv_frame( struct net_device  *dev )
 		nl->state |= FL_PREV_OK;
 		if( framelen > 4 )
 			nl->in_stats.all_rx_number++;
-	} else
-		nl->state &= ~FL_PREV_OK,
-		change_level( dev ),
-		nl->in_stats.all_rx_number++,
+	} else {
+		nl->state &= ~FL_PREV_OK;
+		change_level(dev);
+		nl->in_stats.all_rx_number++;
 		nl->in_stats.bad_rx_number++;
+	}
 
 	return  !frame_ok  ||  framelen > 4;
 }
@@ -691,9 +696,10 @@ download_data( struct net_device  *dev,  u32  *crc_p )
 	*crc_p = calc_crc32( *crc_p, skb->data + nl->outpos, len );
 
 	/* if packet too short we should write some more bytes to pad */
-	for( len = nl->framelen - len;  len--; )
-		outb( 0, dev->base_addr + DAT ),
+	for (len = nl->framelen - len; len--; ) {
+		outb(0, dev->base_addr + DAT);
 		*crc_p = CRC32( 0, *crc_p );
+	}
 }
 
 
@@ -705,9 +711,10 @@ upload_data( struct net_device  *dev,  unsigned  framelen,  unsigned  frameno,
 
 	int  frame_ok;
 
-	if( is_first )
-		nl->wait_frameno = frameno,
+	if (is_first) {
+		nl->wait_frameno = frameno;
 		nl->inppos = 0;
+	}
 
 	if( nl->wait_frameno == frameno ) {
 
@@ -718,35 +725,38 @@ upload_data( struct net_device  *dev,  unsigned  framelen,  unsigned  frameno,
 		 * if CRC is right but framelen incorrect then transmitter
 		 * error was occurred... drop entire packet
 		 */
-		else if( (frame_ok = skip_tail( dev->base_addr, framelen, crc ))
-			 != 0 )
-			nl->wait_frameno = 0,
-			nl->inppos = 0,
+		else {
+			frame_ok = skip_tail(dev->base_addr, framelen, crc);
+			if (frame_ok) {
+				nl->wait_frameno = 0;
+				nl->inppos = 0;
 #ifdef CONFIG_SBNI_MULTILINE
-			nl->master->stats.rx_errors++,
-			nl->master->stats.rx_missed_errors++;
+				nl->master->stats.rx_errors++;
+				nl->master->stats.rx_missed_errors++;
 #else
-		        dev->stats.rx_errors++,
-			dev->stats.rx_missed_errors++;
+				dev->stats.rx_errors++;
+				dev->stats.rx_missed_errors++;
 #endif
-			/* now skip all frames until is_first != 0 */
+				/* now skip all frames until is_first != 0 */
+			}
+		}
 	} else
 		frame_ok = skip_tail( dev->base_addr, framelen, crc );
 
-	if( is_first  &&  !frame_ok )
+	if (is_first  &&  !frame_ok) {
 		/*
 		 * Frame has been broken, but we had already stored
 		 * is_first... Drop entire packet.
 		 */
-		nl->wait_frameno = 0,
+		nl->wait_frameno = 0;
 #ifdef CONFIG_SBNI_MULTILINE
-		nl->master->stats.rx_errors++,
+		nl->master->stats.rx_errors++;
 		nl->master->stats.rx_crc_errors++;
 #else
-		dev->stats.rx_errors++,
+		dev->stats.rx_errors++;
 		dev->stats.rx_crc_errors++;
 #endif
-
+	}
 	return  frame_ok;
 }
 
@@ -788,13 +798,14 @@ interpret_ack( struct net_device  *dev,  unsigned  ack )
 				nl->framelen = min_t(unsigned int,
 						   nl->maxframe,
 						   nl->tx_buf_p->len - nl->outpos);
-			else
-				send_complete( dev ),
+			else {
+				send_complete(dev);
 #ifdef CONFIG_SBNI_MULTILINE
 				netif_wake_queue( nl->master );
 #else
 				netif_wake_queue( dev );
 #endif
+			}
 		}
 	}
 
@@ -874,17 +885,17 @@ drop_xmit_queue( struct net_device  *dev )
 {
 	struct net_local  *nl = netdev_priv(dev);
 
-	if( nl->tx_buf_p )
-		dev_kfree_skb_any( nl->tx_buf_p ),
-		nl->tx_buf_p = NULL,
+	if (nl->tx_buf_p) {
+		dev_kfree_skb_any(nl->tx_buf_p);
+		nl->tx_buf_p = NULL;
 #ifdef CONFIG_SBNI_MULTILINE
-		nl->master->stats.tx_errors++,
+		nl->master->stats.tx_errors++;
 		nl->master->stats.tx_carrier_errors++;
 #else
-		dev->stats.tx_errors++,
+		dev->stats.tx_errors++;
 		dev->stats.tx_carrier_errors++;
 #endif
-
+	}
 	nl->tx_frameno	= 0;
 	nl->framelen	= 0;
 	nl->outpos	= 0;
@@ -1335,12 +1346,13 @@ sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 
 		spin_lock( &nl->lock );
 		flags = *(struct sbni_flags*) &ifr->ifr_ifru;
-		if( flags.fixed_rxl )
-			nl->delta_rxl = 0,
+		if (flags.fixed_rxl) {
+			nl->delta_rxl = 0;
 			nl->cur_rxl_index = flags.rxl;
-		else
-			nl->delta_rxl = DEF_RXL_DELTA,
+		} else {
+			nl->delta_rxl = DEF_RXL_DELTA;
 			nl->cur_rxl_index = DEF_RXL;
+		}
 
 		nl->csr1.rxl = rxl_tab[ nl->cur_rxl_index ];
 		nl->csr1.rate = flags.rate;
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 58915f2..6784332 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -169,14 +169,15 @@ cumanascsi_2_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 
 		bufs = copy_SCp_to_sg(&info->sg[0], SCp, NR_SG);
 
-		if (direction == DMA_OUT)
-			map_dir = DMA_TO_DEVICE,
-			dma_dir = DMA_MODE_WRITE,
+		if (direction == DMA_OUT) {
+			map_dir = DMA_TO_DEVICE;
+			dma_dir = DMA_MODE_WRITE;
 			alatch_dir = ALATCH_DMA_OUT;
-		else
-			map_dir = DMA_FROM_DEVICE,
-			dma_dir = DMA_MODE_READ,
+		} else {
+			map_dir = DMA_FROM_DEVICE;
+			dma_dir = DMA_MODE_READ;
 			alatch_dir = ALATCH_DMA_IN;
+		}
 
 		dma_map_sg(dev, info->sg, bufs, map_dir);
 
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 5bf3c0d..975c022 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -168,12 +168,13 @@ eesoxscsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 
 		bufs = copy_SCp_to_sg(&info->sg[0], SCp, NR_SG);
 
-		if (direction == DMA_OUT)
-			map_dir = DMA_TO_DEVICE,
+		if (direction == DMA_OUT) {
+			map_dir = DMA_TO_DEVICE;
 			dma_dir = DMA_MODE_WRITE;
-		else
-			map_dir = DMA_FROM_DEVICE,
+		} else {
+			map_dir = DMA_FROM_DEVICE;
 			dma_dir = DMA_MODE_READ;
+		}
 
 		dma_map_sg(dev, info->sg, bufs, map_dir);
 
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index abc9593..e07ceed 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -141,12 +141,13 @@ powertecscsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 
 		bufs = copy_SCp_to_sg(&info->sg[0], SCp, NR_SG);
 
-		if (direction == DMA_OUT)
-			map_dir = DMA_TO_DEVICE,
+		if (direction == DMA_OUT) {
+			map_dir = DMA_TO_DEVICE;
 			dma_dir = DMA_MODE_WRITE;
-		else
-			map_dir = DMA_FROM_DEVICE,
+		} else {
+			map_dir = DMA_FROM_DEVICE;
 			dma_dir = DMA_MODE_READ;
+		}
 
 		dma_map_sg(dev, info->sg, bufs, map_dir);
 
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index ef6b0c1..ef43b8d 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -500,7 +500,7 @@ xfs_attr_rmtval_set(
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
 
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
 		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, 0);
@@ -570,7 +570,7 @@ xfs_attr_rmtval_remove(
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
 
-		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
+		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
 		/*
