Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaEIKKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:10:13 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32882 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbaEIKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:10:08 -0400
Date: Fri, 9 May 2014 19:09:35 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: daeseok.youn@gmail.com, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 4/5] staging: cxt1e1: Fix line length over 80 characters in
 musycc.c
Message-ID: <20140509100935.GA6501@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up checkpatch.pl warning:
 WARNING: Line length over 80 characters

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/musycc.c |  312 ++++++++++++++++++++++++---------------
 1 files changed, 196 insertions(+), 116 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 7a793c3..c086c60 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -102,19 +102,24 @@ musycc_dump_rxbuffer_ring(mch_t *ch, int lockit)
 #if 1
 				if (m->data && (status & HOST_RX_OWNED))
 #else
-				if (m->data)    /* always dump regardless of valid RX
-						 * data */
+				/* always dump regardless of valid RX data */
+				if (m->data)
 #endif
 				{
-					dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
+					dp = (u_int32_t *)OS_phystov((void *)(le32_to_cpu(m->data)));
 					if (len >= 0x10)
-						pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
-							*dp, *(dp + 1), *(dp + 2), *(dp + 3));
+						pr_info("    %x[%x]: %08X %08X %08X %08x\n",
+							(u_int32_t)dp, len,
+							*dp, *(dp + 1),
+							*(dp + 2), *(dp + 3));
 					else if (len >= 0x08)
-						pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
+						pr_info("    %x[%x]: %08X %08X\n",
+							(u_int32_t)dp, len,
 							*dp, *(dp + 1));
 					else
-						pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
+						pr_info("    %x[%x]: %08X\n",
+							(u_int32_t)dp,
+							len, *dp);
 				}
 #endif
 			m = m->snext;
@@ -163,15 +168,19 @@ musycc_dump_txbuffer_ring(mch_t *ch, int lockit)
 			len = status & LENGTH_MASK;
 
 			if (m->data) {
-				dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
+				dp = (u_int32_t *)OS_phystov((void *)(le32_to_cpu(m->data)));
 				if (len >= 0x10)
-					pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
-						*dp, *(dp + 1), *(dp + 2), *(dp + 3));
+					pr_info("    %x[%x]: %08X %08X %08X %08x\n",
+						(u_int32_t) dp, len,
+						*dp, *(dp + 1),
+						*(dp + 2), *(dp + 3));
 				else if (len >= 0x08)
-					pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
+					pr_info("    %x[%x]: %08X %08X\n",
+						(u_int32_t)dp, len,
 						*dp, *(dp + 1));
 				else
-					pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
+					pr_info("    %x[%x]: %08X\n",
+						(u_int32_t)dp, len, *dp);
 			}
 #endif
 			m = m->snext;
@@ -212,11 +221,15 @@ musycc_dump_ring(ci_t *ci, unsigned int chan)
 		pr_info(">> musycc_dump_ring: channel %d not up.\n", chan);
 		return ENOENT;
 	}
-	pr_info(">> CI %p CHANNEL %3d @ %p: state %x status/p %x/%x\n", ci, chan, ch, ch->state,
+	pr_info(">> CI %p CHANNEL %3d @ %p: state %x status/p %x/%x\n",
+		ci, chan, ch, ch->state,
 		ch->status, ch->p.status);
-	pr_info("--------------------------------\nTX Buffer Ring - Channel %d, txd_num %d. (bd/ch pend %d %d), TXD required %d, txpkt %lu\n",
+	pr_info("--------------------------------\n");
+	pr_info("TX Buffer Ring - Channel %d, txd_num %d. (bd/ch pend %d %d), TXD required %d, txpkt %lu\n",
 		chan, ch->txd_num,
-		(u_int32_t) atomic_read(&ci->tx_pending), (u_int32_t) atomic_read(&ch->tx_pending), ch->txd_required, ch->s.tx_packets);
+		(u_int32_t)atomic_read(&ci->tx_pending),
+		(u_int32_t)atomic_read(&ch->tx_pending),
+		ch->txd_required, ch->s.tx_packets);
 	pr_info("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
 		ch->user, ch->txd_irq_srv, ch->txd_usr_add,
 		sd_queue_stopped(ch->user),
@@ -311,7 +324,8 @@ musycc_update_tx_thp(mch_t *ch)
 	spin_unlock_irqrestore(&ch->ch_txlock, flags);
 
 #ifdef RLD_TRANS_DEBUG
-	pr_info("++ musycc_update_tx_thp[%d]: setting thp = %p, sts %x\n", ch->channum, md, md->status);
+	pr_info("++ musycc_update_tx_thp[%d]: setting thp = %p, sts %x\n",
+		ch->channum, md, md->status);
 #endif
 }
 
@@ -358,18 +372,20 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 #ifdef RLD_TRANS_DEBUG
 			md = &ch->mdr[ch->rxix_irq_srv];
 			pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
-				ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
-				ch->s.rx_packets);
+				ch->channum, ch->rxix_irq_srv, md,
+				le32_to_cpu(md->status), ch->s.rx_packets);
 #elif defined(RLD_RXACT_DEBUG)
 			md = &ch->mdr[ch->rxix_irq_srv];
 			pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
-				ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
+				ch->channum, ch->rxix_irq_srv,
+				md, le32_to_cpu(md->status),
 				ch->s.rx_packets);
 			musycc_dump_rxbuffer_ring(ch, 1);      /* RLD DEBUG */
 #endif
 		}
 #endif
-		musycc_serv_req(pi, SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION | ch->gchan);
+		musycc_serv_req(pi, SR_CHANNEL_ACTIVATE |
+				SR_RX_DIRECTION | ch->gchan);
 	}
 	/**********************************/
 	/** check for TX restart request **/
@@ -382,16 +398,20 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 		md = ch->txd_irq_srv;
 		if (!md) {
 #ifdef RLD_TRANS_DEBUG
-			pr_info("-- musycc_wq_chan_restart[%d]: WARNING, starting NULL md\n", ch->channum);
+			pr_info("-- musycc_wq_chan_restart[%d]: WARNING, starting NULL md\n",
+				ch->channum);
 #endif
-		} else if (md->data && ((le32_to_cpu(md->status)) & MUSYCC_TX_OWNED)) {
+		} else if (md->data && ((le32_to_cpu(md->status)) &
+			   MUSYCC_TX_OWNED)) {
 			ch->ch_start_tx = 0;
 
 #ifdef RLD_TRANS_DEBUG
 			pr_info("++ musycc_wq_chan_restart() CHAN TX ACTIVATE: chan %d txd_irq_srv %p = sts %x, txpkt %lu\n",
-				ch->channum, ch->txd_irq_srv, ch->txd_irq_srv->status, ch->s.tx_packets);
+				ch->channum, ch->txd_irq_srv,
+				ch->txd_irq_srv->status, ch->s.tx_packets);
 #endif
-			musycc_serv_req(pi, SR_CHANNEL_ACTIVATE | SR_TX_DIRECTION | ch->gchan);
+			musycc_serv_req(pi, SR_CHANNEL_ACTIVATE |
+					SR_TX_DIRECTION | ch->gchan);
 		}
 #ifdef RLD_RESTART_DEBUG
 		else {
@@ -422,7 +442,8 @@ musycc_chan_restart(mch_t *ch)
 
 	/* 2.6 - find next unprocessed message, then set TX thp to it */
 #ifdef RLD_RESTART_DEBUG
-	pr_info(">> musycc_chan_restart: scheduling Chan %x workQ @ %p\n", ch->channum, &ch->ch_work);
+	pr_info(">> musycc_chan_restart: scheduling Chan %x workQ @ %p\n",
+		ch->channum, &ch->ch_work);
 #endif
 	c4_wk_chan_restart(ch);        /* work queue mechanism fires off: Ref:
 					* musycc_wq_chan_restart () */
@@ -439,7 +460,8 @@ rld_put_led(mpi_t *pi, u_int32_t ledval)
 	else
 		led |= ledval;
 
-	pci_write_32((u_int32_t *) &pi->up->cpldbase->leds, led);  /* RLD DEBUG TRANHANG */
+	/* RLD DEBUG TRANHANG */
+	pci_write_32((u_int32_t *) &pi->up->cpldbase->leds, led);
 }
 
 
@@ -481,16 +503,21 @@ musycc_serv_req(mpi_t *pi, u_int32_t req)
 #ifdef RLD_TRANS_DEBUG
 			pr_info(">> same CHAN ACT SR, Port %d Req %x => issue SR_NOOP CMD\n", pi->portnum, req);
 #endif
-			SD_SEM_GIVE(&pi->sr_sem_busy);     /* allow this next request */
+			/* allow this next request */
+			SD_SEM_GIVE(&pi->sr_sem_busy);
 			musycc_serv_req(pi, SR_NOOP);
-			SD_SEM_TAKE(&pi->sr_sem_busy, "serv");     /* relock & continue w/
-								    * original req */
+			/* relock & continue w/ original req */
+			SD_SEM_TAKE(&pi->sr_sem_busy, "serv");
 		} else if (req == SR_NOOP) {
-			/* no need to issue back-to-back SR_NOOP commands at this time */
+			/* no need to issue back-to-back
+			 * SR_NOOP commands at this time
+			 */
 #ifdef RLD_TRANS_DEBUG
-			pr_info(">> same Port SR_NOOP skipped, Port %d\n", pi->portnum);
+			pr_info(">> same Port SR_NOOP skipped, Port %d\n",
+				pi->portnum);
 #endif
-			SD_SEM_GIVE(&pi->sr_sem_busy);     /* allow this next request */
+			/* allow this next request */
+			SD_SEM_GIVE(&pi->sr_sem_busy);
 			return;
 		}
 	}
@@ -508,22 +535,27 @@ rewrite:
 	 * the host follow any SCR write with another operation which reads from
 	 * the same address."
 	 */
-	r = pci_read_32((u_int32_t *) &pi->reg->srd);      /* adhere to write
-							    * timing imposition */
+
+	/* adhere to write timing imposition */
+	r = pci_read_32((u_int32_t *) &pi->reg->srd);
 
 
-	if ((r != req) && (req != SR_CHIP_RESET) && (++rcnt <= MUSYCC_SR_RETRY_CNT)) {
+	if ((r != req) && (req != SR_CHIP_RESET) &&
+	    (++rcnt <= MUSYCC_SR_RETRY_CNT)) {
 		if (cxt1e1_log_level >= LOG_MONITOR)
 			pr_info("%s: %d - reissue srv req/last %x/%x (hdw reads %x), Chan %d.\n",
 				pi->up->devname, rcnt, req, pi->sr_last, r,
 				(pi->portnum * MUSYCC_NCHANS) + (req & 0x1f));
-		OS_uwait_dummy();          /* this delay helps reduce reissue counts
-					    * (reason not yet researched) */
+		/* this delay helps reduce reissue counts
+		 * (reason not yet researched)
+		 */
+		OS_uwait_dummy();
 		goto rewrite;
 	}
 	if (rcnt > MUSYCC_SR_RETRY_CNT) {
 		pr_warning("%s: failed service request (#%d)= %x, group %d.\n",
-			   pi->up->devname, MUSYCC_SR_RETRY_CNT, req, pi->portnum);
+			   pi->up->devname, MUSYCC_SR_RETRY_CNT,
+			   req, pi->portnum);
 		SD_SEM_GIVE(&pi->sr_sem_busy); /* allow any next request */
 		return;
 	}
@@ -538,8 +570,8 @@ rewrite:
 		OS_uwait(100000, "icard"); /* 100ms */
 	} else {
 		FLUSH_MEM_READ();
-		SD_SEM_TAKE(&pi->sr_sem_wait, "sakack");       /* sleep until SACK
-								* interrupt occurs */
+		/* sleep until SACK interrupt occurs */
+		SD_SEM_TAKE(&pi->sr_sem_wait, "sakack");
 	}
 	SD_SEM_GIVE(&pi->sr_sem_busy); /* allow any next request */
 }
@@ -558,15 +590,19 @@ musycc_update_timeslots(mpi_t *pi)
 		u_int8_t lastval = 0;
 
 		if (((i == 0) && e1mode) || /* disable if  E1 mode */
-		    ((i == 16) && ((pi->p.port_mode == CFG_FRAME_E1CRC_CAS) || (pi->p.port_mode == CFG_FRAME_E1CRC_CAS_AMI)))
-		    || ((i > 23) && (!e1mode))) /* disable if T1 mode */
-			pi->tsm[i] = 0xff;      /* make tslot unavailable for this mode */
+		    ((i == 16) && ((pi->p.port_mode == CFG_FRAME_E1CRC_CAS) ||
+		    (pi->p.port_mode == CFG_FRAME_E1CRC_CAS_AMI))) ||
+		    ((i > 23) && (!e1mode))) /* disable if T1 mode */
+			/* make tslot unavailable for this mode */
+			pi->tsm[i] = 0xff;
 		else
-			pi->tsm[i] = 0x00;      /* make tslot available for assignment */
+			/* make tslot available for assignment */
+			pi->tsm[i] = 0x00;
 		for (j = 0; j < 8; j++)
 			bits[j] = -1;
 		for (ch = 0; ch < MUSYCC_NCHANS; ch++) {
-			if ((pi->chan[ch]->state == UP) && (pi->chan[ch]->p.bitmask[i])) {
+			if ((pi->chan[ch]->state == UP) &&
+			    (pi->chan[ch]->p.bitmask[i])) {
 				usedby++;
 				last = ch;
 				lastval = pi->chan[ch]->p.bitmask[i];
@@ -590,8 +626,10 @@ musycc_update_timeslots(mpi_t *pi)
 			else
 				ts = (7 << 5) | (idx = bits[0]);
 			for (j = 1; j < 8; j++) {
-				pi->regram->rscm[idx * 8 + j] = (bits[j] < 0) ? 0 : (0x80 | bits[j]);
-				pi->regram->tscm[idx * 8 + j] = (bits[j] < 0) ? 0 : (0x80 | bits[j]);
+				pi->regram->rscm[idx * 8 + j] =
+					(bits[j] < 0) ? 0 : (0x80 | bits[j]);
+				pi->regram->tscm[idx * 8 + j] =
+					(bits[j] < 0) ? 0 : (0x80 | bits[j]);
 			}
 		}
 		pi->regram->rtsm[i] = ts;
@@ -624,7 +662,8 @@ musycc_update_timeslots(mpi_t *pi)
 	hmask = (0x1f << hyperdummy) & 0x1f;
 #endif
 	for (i = 0; i < 128; i++) {
-		gchan = ((pi->portnum * MUSYCC_NCHANS) + (i & hmask)) % MUSYCC_NCHANS;
+		gchan = ((pi->portnum * MUSYCC_NCHANS) +
+			(i & hmask)) % MUSYCC_NCHANS;
 		ch = pi->chan[gchan];
 		if (ch->p.mode_56k)
 			tsen = MODE_56KBPS;
@@ -711,7 +750,7 @@ musycc_init(ci_t *ci)
 	char       *regaddr;        /* temp for address boundary calculations */
 	int         i, gchan;
 
-	OS_sem_init(&ci->sem_wdbusy, SEM_AVAILABLE);       /* watchdog exclusion */
+	OS_sem_init(&ci->sem_wdbusy, SEM_AVAILABLE); /* watchdog exclusion */
 
 	/*
 	 * Per MUSYCC manual, Section 6.3.4 - "The host must allocate a dword
@@ -725,9 +764,9 @@ musycc_init(ci_t *ci)
 	if (!regaddr)
 		return -ENOMEM;
 	ci->iqd_p_saved = regaddr;      /* save orig value for free's usage */
-	ci->iqd_p = (u_int32_t *) ((unsigned long) (regaddr + INT_QUEUE_BOUNDARY - 1) &
-			(~(INT_QUEUE_BOUNDARY - 1)));    /* this calculates
-							  * closest boundary */
+	/* this calculates closest boundary */
+	ci->iqd_p = (u_int32_t *) ((unsigned long)(regaddr + INT_QUEUE_BOUNDARY - 1) &
+				   (~(INT_QUEUE_BOUNDARY - 1)));
 
 	for (i = 0; i < INT_QUEUE_SIZE; i++)
 		ci->iqd_p[i] = __constant_cpu_to_le32(INT_EMPTY_ENTRY);
@@ -753,9 +792,9 @@ musycc_init(ci_t *ci)
 			return -ENOMEM;
 		}
 		pi->regram_saved = regaddr; /* save orig value for free's usage */
-		pi->regram = (struct musycc_groupr *) ((unsigned long) (regaddr + GROUP_BOUNDARY - 1) &
-				(~(GROUP_BOUNDARY - 1)));        /* this calculates
-								  * closest boundary */
+		/* this calculates closest boundary */
+		pi->regram = (struct musycc_groupr *) ((unsigned long)(regaddr + GROUP_BOUNDARY - 1) &
+				(~(GROUP_BOUNDARY - 1)));
 	}
 
 	/* any board centric MUSYCC commands will use group ZERO as its "home" */
@@ -768,7 +807,8 @@ musycc_init(ci_t *ci)
 	ci->regram->__glcd = __constant_cpu_to_le32(GCD_MAGIC);
 #else
 	/* standard driver POLLS for INTB via CPLD register */
-	ci->regram->__glcd = __constant_cpu_to_le32(GCD_MAGIC | MUSYCC_GCD_INTB_DISABLE);
+	ci->regram->__glcd = __constant_cpu_to_le32(GCD_MAGIC |
+						    MUSYCC_GCD_INTB_DISABLE);
 #endif
 
 	ci->regram->__iqp = cpu_to_le32(OS_vtophys(&ci->iqd_p[0]));
@@ -779,7 +819,7 @@ musycc_init(ci_t *ci)
 	ci->state = C_RUNNING;          /* mark as full interrupt processing
 					 * available */
 
-	musycc_serv_req(&ci->port[0], SR_GLOBAL_INIT);     /* FIRST INTERRUPT ! */
+	musycc_serv_req(&ci->port[0], SR_GLOBAL_INIT); /* FIRST INTERRUPT ! */
 
 	/* sanity check settable parameters */
 
@@ -844,42 +884,49 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 			readCount = 0;
 			while (status & MUSYCC_TX_OWNED) {
 				for (loopCount = 0; loopCount < 0x30; loopCount++)
-					OS_uwait_dummy();  /* use call to avoid optimization
-							    * removal of dummy delay */
+					/* use call to avoid optimization
+					 * removal of dummy delay */
+					OS_uwait_dummy();
 				FLUSH_MEM_READ();
 				status = le32_to_cpu(md->status);
 				if (readCount++ > 40)
-					break;          /* don't wait any longer */
+					break; /* don't wait any longer */
 			}
 			if (status & MUSYCC_TX_OWNED) {
 				if (cxt1e1_log_level >= LOG_MONITOR) {
 					pr_info("%s: Port %d Chan %2d - unexpected TX msg ownership intr (md %p sts %x)\n",
-						pi->up->devname, pi->portnum, ch->channum,
-						md, status);
+						pi->up->devname, pi->portnum,
+						ch->channum, md, status);
 					pr_info("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
-						ch->user, ch->txd_irq_srv, ch->txd_usr_add,
+						ch->user, ch->txd_irq_srv,
+						ch->txd_usr_add,
 						sd_queue_stopped(ch->user),
-						ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
+						ch->ch_start_tx, ch->tx_full,
+						ch->txd_free, ch->p.chan_mode);
 					musycc_dump_txbuffer_ring(ch, 0);
 				}
 				break;              /* Not our mdesc, done */
 			} else {
 				if (cxt1e1_log_level >= LOG_MONITOR)
 					pr_info("%s: Port %d Chan %2d - recovered TX msg ownership [%d] (md %p sts %x)\n",
-						pi->up->devname, pi->portnum, ch->channum, readCount, md, status);
+						pi->up->devname, pi->portnum,
+						ch->channum, readCount,
+						md, status);
 			}
 		}
 		ch->txd_irq_srv = md->snext;
 
 		md->data = 0;
-		if (md->mem_token)	{
+		if (md->mem_token) {
 #ifdef CONFIG_SBE_WAN256T3_NCOMM
 			int hdlcnum = 0;
 #endif
 			/* upcount channel */
-			atomic_sub(OS_mem_token_tlen(md->mem_token), &ch->tx_pending);
+			atomic_sub(OS_mem_token_tlen(md->mem_token),
+				   &ch->tx_pending);
 			/* upcount card */
-			atomic_sub(OS_mem_token_tlen(md->mem_token), &pi->up->tx_pending);
+			atomic_sub(OS_mem_token_tlen(md->mem_token),
+				   &pi->up->tx_pending);
 #ifdef SBE_WAN256T3_ENABLE
 			if (!atomic_read(&pi->up->tx_pending))
 				wan256t3_led(pi->up, LED_TX, 0);
@@ -894,7 +941,7 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 					(*nciProcess_TX_complete) (hdlcnum,
 							getuserbychan(gchan));
 			}
-#endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
+#endif /* CONFIG_SBE_WAN256T3_NCOMM */
 
 			OS_mem_token_free_irq(md->mem_token);
 			md->mem_token = NULL;
@@ -908,14 +955,17 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 		++ch->txd_free;
 		FLUSH_MEM_WRITE();
 
-		if ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && (status & EOBIRQ_ENABLE)) {
+		if ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) &&
+		    (status & EOBIRQ_ENABLE)) {
 			if (cxt1e1_log_level >= LOG_MONITOR)
 				pr_info("%s: Mode (%x) incorrect EOB status (%x)\n",
-					pi->up->devname, ch->p.chan_mode, status);
+					pi->up->devname, ch->p.chan_mode,
+					status);
 			if ((status & EOMIRQ_ENABLE) == 0)
 				break;
 		}
-	} while ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && ((status & EOMIRQ_ENABLE) == 0));
+	} while ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) &&
+		 ((status & EOMIRQ_ENABLE) == 0));
 	/*
 	 * NOTE: (The above 'while' is coupled w/ previous 'do', way above.) Each
 	 * Transparent data buffer has the EOB bit, and NOT the EOM bit, set and
@@ -944,8 +994,8 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 #endif
 			ch->tx_full = 0;
 			ch->txd_required = 0;
-			sd_enable_xmit(ch->user);  /* re-enable to catch flow controlled
-						    * channel */
+			/* re-enable to catch flow controlled channel */
+			sd_enable_xmit(ch->user);
 		}
 	}
 #ifdef RLD_TXFULL_DEBUG
@@ -998,7 +1048,9 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
 			 */
 			if (hdlcnum >= 228) {
 				if (nciProcess_RX_packet)
-					(*nciProcess_RX_packet) (hdlcnum, status & 0x3fff, m, ch->user);
+					(*nciProcess_RX_packet)(hdlcnum,
+								status & 0x3fff,
+								m, ch->user);
 			} else
 #endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
 
@@ -1011,7 +1063,8 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
 							       OS_mem_token_data(m2)));
 
 					/* pass the received mbuf upward */
-					sd_recv_consume(m, status & LENGTH_MASK, ch->user);
+					sd_recv_consume(m, status & LENGTH_MASK,
+							ch->user);
 					ch->s.rx_packets++;
 					ch->s.rx_bytes += status & LENGTH_MASK;
 				} else
@@ -1092,7 +1145,8 @@ musycc_intr_th_handler(void *devp)
 		if (cxt1e1_log_level >= LOG_MONITOR) {
 			pr_info("%s: note - updated ISD from %08x to %08x\n",
 				ci->devname, status,
-				(status & (~INTRPTS_NEXTINT_M)) | ci->intlog.this_status_new);
+				(status & (~INTRPTS_NEXTINT_M)) |
+				ci->intlog.this_status_new);
 		}
 		/*
 		 * Replace bogus status with software corrected value.
@@ -1100,7 +1154,8 @@ musycc_intr_th_handler(void *devp)
 		 * It's not known whether, during this problem occurrence, if the
 		 * INTFULL bit is correctly reported or not.
 		 */
-		status = (status & (~INTRPTS_NEXTINT_M)) | (ci->intlog.this_status_new);
+		status = (status & (~INTRPTS_NEXTINT_M)) |
+			 (ci->intlog.this_status_new);
 		nextInt = INTRPTS_NEXTINT(status);
 	}
 	/**********************************************/
@@ -1149,11 +1204,13 @@ musycc_intr_th_handler(void *devp)
 	ci->intlog.this_status_new = currInt;
 
 	if ((cxt1e1_log_level >= LOG_WARN) && (status & INTRPTS_INTFULL_M))
-		pr_info("%s: Interrupt queue full condition occurred\n", ci->devname);
+		pr_info("%s: Interrupt queue full condition occurred\n",
+			ci->devname);
 	if (cxt1e1_log_level >= LOG_DEBUG)
 		pr_info("%s: interrupts pending, isd @ 0x%p: %x curr %d cnt %d NEXT %d\n",
 			ci->devname, &ci->reg->isd,
-			status, nextInt, intCnt, (intCnt + nextInt) & (INT_QUEUE_SIZE - 1));
+			status, nextInt, intCnt,
+			(intCnt + nextInt) & (INT_QUEUE_SIZE - 1));
 
 	FLUSH_MEM_WRITE();
 #if defined(SBE_ISR_TASKLET)
@@ -1242,16 +1299,18 @@ musycc_intr_bh_tasklet(ci_t *ci)
 
 		while ((currInt == badInt) || (currInt == badInt2)) {
 			for (loopCount = 0; loopCount < 0x30; loopCount++)
-				OS_uwait_dummy();  /* use call to avoid optimization removal
-						    * of dummy delay */
+				/* use call to avoid optimization
+				 * removal of dummy delay
+				 */
+				OS_uwait_dummy();
 			FLUSH_MEM_READ();
 			currInt = le32_to_cpu(ci->iqd_p[headx]);
 			if (readCount++ > 20)
 				break;
 		}
 
-		if ((currInt == badInt) || (currInt == badInt2)) {      /* catch failure of Bug
-									 * Fix checking */
+		/* catch failure of Bug Fix checking */
+		if ((currInt == badInt) || (currInt == badInt2)) {
 			if (cxt1e1_log_level >= LOG_WARN)
 				pr_info("%s: Illegal Interrupt Detected @ 0x%p, mod %d.)\n",
 					ci->devname, &ci->iqd_p[headx], headx);
@@ -1270,7 +1329,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 				ci->iqd_p[headx] = __constant_cpu_to_le32(INT_EMPTY_ENTRY2);
 			else
 				ci->iqd_p[headx] = __constant_cpu_to_le32(INT_EMPTY_ENTRY);
-			ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1); /* insure wrapness */
+			/* insure wrapness */
+			ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);
 			FLUSH_MEM_WRITE();
 			FLUSH_MEM_READ();
 			continue;
@@ -1291,8 +1351,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 			pr_info("+ interrupt event: %d, grp: %d, chan: %2d, side: %cX\n",
 				event, group, gchan, tx ? 'T' : 'R');
 		}
-		pi = &ci->port[group];      /* notice that here we assume 1-1 group -
-					     * port mapping */
+		/* notice that here we assume 1-1 group - port mapping */
+		pi = &ci->port[group];
 		ch = pi->chan[gchan];
 		switch (event) {
 		case EVE_SACK:              /* Service Request Acknowledge */
@@ -1300,15 +1360,17 @@ musycc_intr_bh_tasklet(ci_t *ci)
 				volatile u_int32_t r;
 
 				r = pci_read_32((u_int32_t *) &pi->reg->srd);
-				pr_info("- SACK cmd: %08x (hdw= %08x)\n", pi->sr_last, r);
+				pr_info("- SACK cmd: %08x (hdw= %08x)\n",
+					pi->sr_last, r);
 			}
-			SD_SEM_GIVE(&pi->sr_sem_wait);     /* wake up waiting process */
+			/* wake up waiting process */
+			SD_SEM_GIVE(&pi->sr_sem_wait);
 			break;
-		case EVE_CHABT:     /* Change To Abort Code (0x7e -> 0xff) */
-		case EVE_CHIC:              /* Change To Idle Code (0xff -> 0x7e) */
+		case EVE_CHABT: /* Change To Abort Code (0x7e -> 0xff) */
+		case EVE_CHIC:  /* Change To Idle Code (0xff -> 0x7e) */
 			break;
-		case EVE_EOM:               /* End Of Message */
-		case EVE_EOB:               /* End Of Buffer (Transparent mode) */
+		case EVE_EOM:   /* End Of Message */
+		case EVE_EOB:   /* End Of Buffer (Transparent mode) */
 			if (tx)
 				musycc_bh_tx_eom(pi, gchan);
 			else
@@ -1365,14 +1427,21 @@ musycc_intr_bh_tasklet(ci_t *ci)
 #endif
 				{
 					pr_info("%s: TX buffer underflow [ONR] on channel %d, mode %x QStopped %x free %d\n",
-						ci->devname, ch->channum, ch->p.chan_mode, sd_queue_stopped(ch->user), ch->txd_free);
+						ci->devname, ch->channum,
+						ch->p.chan_mode,
+						sd_queue_stopped(ch->user),
+						ch->txd_free);
 #ifdef RLD_DEBUG
-					if (ch->p.chan_mode == 2) {     /* problem = ONR on HDLC
-									 * mode */
+					/* problem = ONR on HDLC mode */
+					if (ch->p.chan_mode == 2) {
 						pr_info("++ Failed Last %x Next %x QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
-							(u_int32_t) ch->txd_irq_srv, (u_int32_t) ch->txd_usr_add,
+							(u_int32_t)ch->txd_irq_srv,
+							(u_int32_t)ch->txd_usr_add,
 							sd_queue_stopped(ch->user),
-							ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
+							ch->ch_start_tx,
+							ch->tx_full,
+							ch->txd_free,
+							ch->p.chan_mode);
 						musycc_dump_txbuffer_ring(ch, 0);
 					}
 #endif
@@ -1390,7 +1459,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 
 				if (cxt1e1_log_level >= LOG_WARN) {
 					pr_info("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
-						ci->devname, ch->channum, ch->p.chan_mode);
+						ci->devname, ch->channum,
+						ch->p.chan_mode);
 #ifdef RLD_DEBUG
 					musycc_dump_rxbuffer_ring(ch, 0);
 #endif
@@ -1408,7 +1478,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 				 */
 				if (cxt1e1_log_level >= LOG_MONITOR)
 					pr_info("%s: TX buffer underrun [BUFF] on channel %d, mode %x\n",
-						ci->devname, ch->channum, ch->p.chan_mode);
+						ci->devname, ch->channum,
+						ch->p.chan_mode);
 			} else {                 /* RX buffer overrun */
 				ch->s.rx_over_errors++;
 				/*
@@ -1420,7 +1491,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 				 */
 				if (cxt1e1_log_level >= LOG_WARN)
 					pr_info("%s: RX buffer overrun [BUFF] on channel %d, mode %x\n",
-						ci->devname, ch->channum, ch->p.chan_mode);
+						ci->devname, ch->channum,
+						ch->p.chan_mode);
 				/*
 				 * Per MUSYCC manual, Section 6.4.9.4 [Receive Errors],
 				 * Transparent mode DOES require recovery for the RX BUFF
@@ -1440,14 +1512,17 @@ musycc_intr_bh_tasklet(ci_t *ci)
 		}                           /* switch on err */
 
 		/* Check for interrupt lost condition */
-		if ((currInt & INTRPT_ILOST_M) && (cxt1e1_log_level >= LOG_ERROR))
+		if ((currInt & INTRPT_ILOST_M) &&
+		    (cxt1e1_log_level >= LOG_ERROR))
 			pr_info("%s: Interrupt queue overflow - ILOST asserted\n",
 				ci->devname);
-		ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);     /* insure wrapness */
+		/* insure wrapness */
+		ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);
 		FLUSH_MEM_WRITE();
 		FLUSH_MEM_READ();
 	}                               /* while */
-	if ((cxt1e1_log_level >= LOG_MONITOR2) && (ci->iqp_headx != ci->iqp_tailx)) {
+	if ((cxt1e1_log_level >= LOG_MONITOR2) &&
+	    (ci->iqp_headx != ci->iqp_tailx)) {
 		int         bh;
 
 		bh = atomic_read(&CI->bh_pending);
@@ -1525,13 +1600,15 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	if (!ch)
 		return -ENOENT;
 
-	if (ci->state != C_RUNNING)     /* full interrupt processing available */
+	/* full interrupt processing available */
+	if (ci->state != C_RUNNING)
 		return -EINVAL;
 	if (ch->state != UP)
 		return -EINVAL;
 
+	/* how else to flag unwritable state ? */
 	if (!(ch->status & TX_ENABLED))
-		return -EROFS;               /* how else to flag unwritable state ? */
+		return -EROFS;
 
 #ifdef RLD_TRANS_DEBUG
 	if (1 || cxt1e1_log_level >= LOG_MONITOR2)
@@ -1541,7 +1618,8 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	{
 		pr_info("++ start_xmt[%d]: state %x start %x full %d free %d required %d stopped %x\n",
 			channum, ch->state, ch->ch_start_tx, ch->tx_full,
-			ch->txd_free, ch->txd_required, sd_queue_stopped(ch->user));
+			ch->txd_free, ch->txd_required,
+			sd_queue_stopped(ch->user));
 	}
 	/***********************************************/
 	/** Determine total amount of data to be sent **/
@@ -1558,7 +1636,8 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 
 	if (txd_need_cnt == 0) {
 		if (cxt1e1_log_level >= LOG_MONITOR2)
-			pr_info("%s channel %d: no TX data in User buffer\n", ci->devname, channum);
+			pr_info("%s channel %d: no TX data in User buffer\n",
+				ci->devname, channum);
 		OS_mem_token_free(mem_token);
 		return 0;                   /* no data to send */
 	}
@@ -1581,7 +1660,8 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	if (txd_need_cnt > ch->txd_free) {
 		if (cxt1e1_log_level >= LOG_MONITOR2)
 			pr_info("start_xmit[%d]: EBUSY - need more descriptors, have %d of %d need %d\n",
-				channum, ch->txd_free, ch->txd_num, txd_need_cnt);
+				channum, ch->txd_free,
+				ch->txd_num, txd_need_cnt);
 		ch->tx_full = 1;
 		ch->txd_required = txd_need_cnt;
 		sd_disable_xmit(ch->user);
@@ -1605,7 +1685,8 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		 * after ALL subsequent chunks are setup.
 		 */
 		if (md != ch->txd_usr_add)  /* not first chunk */
-			u |= MUSYCC_TX_OWNED;   /* transfer ownership from HOST to MUSYCC */
+			/* transfer ownership from HOST to MUSYCC */
+			u |= MUSYCC_TX_OWNED;
 
 		if (len)                    /* not last chunk */
 			u |= EOBIRQ_ENABLE;
@@ -1625,12 +1706,11 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		if (ch->p.pad_fill_count) {
 			u |= (PADFILL_ENABLE | (ch->p.pad_fill_count << EXTRA_FLAGS));
 		}
-		md->mem_token = len ? NULL : mem_token;    /* Fill in mds on last
-							    * segment, others set ZERO
-							    * so that entire token is
-							    * removed ONLY when ALL
-							    * segments have been
-							    * transmitted. */
+		/* Fill in mds on last segment, others set ZERO
+		 * so that entire token is removed ONLY when ALL
+		 * segments have been transmitted.
+		 */
+		md->mem_token = len ? NULL : mem_token;
 
 		md->data = cpu_to_le32(OS_vtophys(OS_mem_token_data(m2)));
 		FLUSH_MEM_WRITE();
-- 
1.7.1

