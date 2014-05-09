Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaEIKGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:06:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36750 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaEIKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:06:39 -0400
Date: Fri, 9 May 2014 19:06:06 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: daeseok.youn@gmail.com, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 2/5] staging: cxt1e1: remove dead code in musycc.c
Message-ID: <20140509100606.GA6479@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes "#if 0" blocks.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
Dan,
 I decided to leave musycc_dump_rxbuffer_ring(ch, 0) which is commented
 out and make a block as "RLD_DEBUG". Because i think this block need to debug
 with define "RLD_DEBUG". If I am wrong, let me know.

 drivers/staging/cxt1e1/musycc.c |  136 ++-------------------------------------
 1 files changed, 5 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 2ddf889..91fab77 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -64,7 +64,6 @@ void        musycc_update_timeslots(mpi_t *);
 
 /*******************************************************************/
 
-#if 1
 static int
 musycc_dump_rxbuffer_ring(mch_t *ch, int lockit)
 {
@@ -128,9 +127,7 @@ musycc_dump_rxbuffer_ring(mch_t *ch, int lockit)
 		spin_unlock_irqrestore(&ch->ch_rxlock, flags);
 	return 0;
 }
-#endif
 
-#if 1
 static int
 musycc_dump_txbuffer_ring(mch_t *ch, int lockit)
 {
@@ -188,8 +185,6 @@ musycc_dump_txbuffer_ring(mch_t *ch, int lockit)
 		spin_unlock_irqrestore(&ch->ch_txlock, flags);
 	return 0;
 }
-#endif
-
 
 /*
  * The following supports a backdoor debug facility which can be used to
@@ -340,9 +335,6 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 	mch_t      *ch;
 	mpi_t      *pi;
 	struct mdesc *md;
-#if 0
-	unsigned long flags;
-#endif
 
 	ch = container_of(arg, struct c4_chan_info, ch_work);
 	pi = ch->up;
@@ -391,22 +383,14 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 		/* find next unprocessed message, then set TX thp to it */
 		musycc_update_tx_thp(ch);
 
-#if 0
-		spin_lock_irqsave(&ch->ch_txlock, flags);
-#endif
 		md = ch->txd_irq_srv;
 		if (!md) {
 #ifdef RLD_TRANS_DEBUG
 			pr_info("-- musycc_wq_chan_restart[%d]: WARNING, starting NULL md\n", ch->channum);
 #endif
-#if 0
-			spin_unlock_irqrestore(&ch->ch_txlock, flags);
-#endif
 		} else if (md->data && ((le32_to_cpu(md->status)) & MUSYCC_TX_OWNED)) {
 			ch->ch_start_tx = 0;
-#if 0
-			spin_unlock_irqrestore(&ch->ch_txlock, flags);   /* allow interrupts for service request */
-#endif
+
 #ifdef RLD_TRANS_DEBUG
 			pr_info("++ musycc_wq_chan_restart() CHAN TX ACTIVATE: chan %d txd_irq_srv %p = sts %x, txpkt %lu\n",
 				ch->channum, ch->txd_irq_srv, ch->txd_irq_srv->status, ch->s.tx_packets);
@@ -421,9 +405,6 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 				le32_to_cpu(md->status),
 				le32_to_cpu(md->data), ch->ch_start_tx);
 			musycc_dump_txbuffer_ring(ch, 0);
-#if 0
-			spin_unlock_irqrestore(&ch->ch_txlock, flags);   /* allow interrupts for service request */
-#endif
 		}
 #endif
 	}
@@ -831,12 +812,6 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 	mch_t      *ch;
 	struct mdesc *md;
 
-#if 0
-#ifndef SBE_ISR_INLINE
-	unsigned long flags;
-
-#endif
-#endif
 	volatile u_int32_t status;
 
 	ch = pi->chan[gchan];
@@ -849,13 +824,6 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 		return;                     /* note: mdt==0 implies a malloc()
 					     * failure w/in chan_up() routine */
 
-#if 0
-#ifdef SBE_ISR_INLINE
-	spin_lock_irq(&ch->ch_txlock);
-#else
-	spin_lock_irqsave(&ch->ch_txlock, flags);
-#endif
-#endif
 	do {
 		FLUSH_MEM_READ();
 		md = ch->txd_irq_srv;
@@ -993,13 +961,6 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 #endif
 
 	FLUSH_MEM_WRITE();
-#if 0
-#ifdef SBE_ISR_INLINE
-	spin_unlock_irq(&ch->ch_txlock);
-#else
-	spin_unlock_irqrestore(&ch->ch_txlock, flags);
-#endif
-#endif
 }
 
 
@@ -1181,11 +1142,6 @@ musycc_intr_th_handler(void *devp)
 			 * walking the chain.  As the chain is walked, the interrupt will
 			 * eventually be serviced by the correct driver/handler.
 			 */
-#if 0
-			/* chained interrupt = not ours */
-			pr_info(">> %s: intCnt NULL, sts %x, possibly a chained interrupt!\n",
-					ci->devname, status);
-#endif
 			return IRQ_NONE;
 		}
 
@@ -1360,15 +1316,11 @@ musycc_intr_bh_tasklet(ci_t *ci)
 				musycc_bh_tx_eom(pi, gchan);
 			else
 				musycc_bh_rx_eom(pi, gchan);
-#if 0
-			break;
-#else
 			/*
 			 * MUSYCC Interrupt Descriptor section states that EOB and EOM
 			 * can be combined with the NONE error (as well as others).  So
 			 * drop thru to catch this...
 			 */
-#endif
 		case EVE_NONE:
 			if (err == ERR_SHT)
 				ch->s.rx_length_errors++;
@@ -1444,7 +1396,9 @@ musycc_intr_bh_tasklet(ci_t *ci)
 				if (cxt1e1_log_level >= LOG_WARN) {
 					pr_info("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
 						ci->devname, ch->channum, ch->p.chan_mode);
-					//musycc_dump_rxbuffer_ring (ch, 0);        /* RLD DEBUG */
+#ifdef RLD_DEBUG
+					musycc_dump_rxbuffer_ring(ch, 0);
+#endif
 				}
 			}
 			musycc_chan_restart(ch);
@@ -1511,35 +1465,6 @@ musycc_intr_bh_tasklet(ci_t *ci)
 	/* else, nothing returned */
 }
 
-#if 0
-	int         __init
-musycc_new_chan(ci_t *ci, int channum, void *user)
-{
-	mch_t      *ch;
-
-	ch = ci->port[channum / MUSYCC_NCHANS].chan[channum % MUSYCC_NCHANS];
-
-	if (ch->state != UNASSIGNED)
-		return EEXIST;
-	/* NOTE: mch_t already cleared during OS_kmalloc() */
-	ch->state = DOWN;
-	ch->user = user;
-#if 0
-	ch->status = 0;
-	ch->p.status = 0;
-	ch->p.intr_mask = 0;
-#endif
-	ch->p.chan_mode = CFG_CH_PROTO_HDLC_FCS16;
-	ch->p.idlecode = CFG_CH_FLAG_7E;
-	ch->p.pad_fill_count = 2;
-	spin_lock_init(&ch->ch_rxlock);
-	spin_lock_init(&ch->ch_txlock);
-
-	return 0;
-}
-#endif
-
-
 #ifdef SBE_PMCC4_ENABLE
 	status_t
 musycc_chan_down(ci_t *dummy, int channum)
@@ -1592,52 +1517,12 @@ musycc_chan_down(ci_t *dummy, int channum)
 }
 #endif
 
-
-#if 0
-/* TODO: determine if these functions will not be needed and can be removed */
-int
-musycc_del_chan(ci_t *ci, int channum)
-{
-	mch_t      *ch;
-
-	if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))  /* sanity chk param */
-		return ECHRNG;
-	ch = sd_find_chan(ci, channum);
-	if (!ch)
-		return ENOENT;
-	if (ch->state == UP)
-		musycc_chan_down(ci, channum);
-	ch->state = UNASSIGNED;
-	return 0;
-}
-
-
-int
-musycc_del_chan_stats(ci_t *ci, int channum)
-{
-	mch_t      *ch;
-
-	if (channum < 0 || channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS))      /* sanity chk param */
-		return ECHRNG;
-	ch = sd_find_chan(ci, channum);
-	if (!ch)
-		return ENOENT;
-
-	memset(&ch->s, 0, sizeof(struct sbecom_chan_stats));
-	return 0;
-}
-#endif
-
-
 int
 musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 {
 	mch_t      *ch;
 	struct mdesc *md;
 	void       *m2;
-#if 0
-	unsigned long flags;
-#endif
 	int         txd_need_cnt;
 	u_int32_t   len;
 
@@ -1694,9 +1579,7 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		OS_mem_token_free(mem_token);
 		return 0;
 	}
-#if 0
-	spin_lock_irqsave(&ch->ch_txlock, flags);
-#endif
+
 	/************************************************************/
 	/** flow control the line if not enough descriptors remain **/
 	/************************************************************/
@@ -1707,9 +1590,6 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		ch->tx_full = 1;
 		ch->txd_required = txd_need_cnt;
 		sd_disable_xmit(ch->user);
-#if 0
-		spin_unlock_irqrestore(&ch->ch_txlock, flags);
-#endif
 		return -EBUSY;               /* tell user to try again later */
 	}
 	/**************************************************/
@@ -1748,12 +1628,6 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		/* last chunk in hdlc mode */
 		u |= (ch->p.idlecode << IDLE_CODE);
 		if (ch->p.pad_fill_count) {
-#if 0
-			/* NOOP NOTE: u_int8_t cannot be > 0xFF */
-			/* sanitize pad_fill_count for maximums allowed by hardware */
-			if (ch->p.pad_fill_count > EXTRA_FLAGS_MASK)
-				ch->p.pad_fill_count = EXTRA_FLAGS_MASK;
-#endif
 			u |= (PADFILL_ENABLE | (ch->p.pad_fill_count << EXTRA_FLAGS));
 		}
 		md->mem_token = len ? NULL : mem_token;    /* Fill in mds on last
-- 
1.7.1

