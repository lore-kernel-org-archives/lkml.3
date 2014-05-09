Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbaEIKKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:10:02 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42229 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbaEIKJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:32 -0400
Date: Fri, 9 May 2014 19:08:59 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: daeseok.youn@gmail.com, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 3/5] staging: cxt1e1: remove redundant curly braces in
 musycc.c
Message-ID: <20140509100859.GA6495@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
I'm not sure about removing "RLD_DUMP_BUFDATA" and "RLD_DEBUG"
definitions.
I think these can be defined temporarily by developer who want to debugging
this module.

 drivers/staging/cxt1e1/musycc.c |  211 +++++++++++++++++++--------------------
 1 files changed, 103 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 91fab77..7a793c3 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -73,6 +73,10 @@ musycc_dump_rxbuffer_ring(mch_t *ch, int lockit)
 	u_int32_t status;
 	int         n;
 
+#ifdef RLD_DUMP_BUFDATA
+	u_int32_t *dp;
+	int len = 0;
+#endif
 	if (lockit)
 		spin_lock_irqsave(&ch->ch_rxlock, flags);
 	if (ch->rxd_num == 0)
@@ -82,45 +86,40 @@ musycc_dump_rxbuffer_ring(mch_t *ch, int lockit)
 		m = &ch->mdr[ch->rxix_irq_srv];
 		for (n = ch->rxd_num; n; n--) {
 			status = le32_to_cpu(m->status);
-			{
-				pr_info("%c  %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
-					(m == &ch->mdr[ch->rxix_irq_srv]) ? 'F' : ' ',
-					(unsigned long) m, n,
-					status,
-					m->data ? (status & HOST_RX_OWNED ? 'H' : 'M') : '-',
-					status & POLL_DISABLED ? 'P' : '-',
-					status & EOBIRQ_ENABLE ? 'b' : '-',
-					status & EOMIRQ_ENABLE ? 'm' : '-',
-					status & LENGTH_MASK,
-					le32_to_cpu(m->data), le32_to_cpu(m->next));
+			pr_info("%c  %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
+				(m == &ch->mdr[ch->rxix_irq_srv]) ? 'F' : ' ',
+				(unsigned long) m, n,
+				status,
+				m->data ? (status & HOST_RX_OWNED ? 'H' : 'M') : '-',
+				status & POLL_DISABLED ? 'P' : '-',
+				status & EOBIRQ_ENABLE ? 'b' : '-',
+				status & EOMIRQ_ENABLE ? 'm' : '-',
+				status & LENGTH_MASK,
+				le32_to_cpu(m->data), le32_to_cpu(m->next));
 #ifdef RLD_DUMP_BUFDATA
-				{
-					u_int32_t  *dp;
-					int         len = status & LENGTH_MASK;
+				len = status & LENGTH_MASK;
 
 #if 1
-					if (m->data && (status & HOST_RX_OWNED))
+				if (m->data && (status & HOST_RX_OWNED))
 #else
-					if (m->data)    /* always dump regardless of valid RX
-							 * data */
+				if (m->data)    /* always dump regardless of valid RX
+						 * data */
 #endif
-					{
-						dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
-						if (len >= 0x10)
-							pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
-								*dp, *(dp + 1), *(dp + 2), *(dp + 3));
-						else if (len >= 0x08)
-							pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
-								*dp, *(dp + 1));
-						else
-							pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
-					}
+				{
+					dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
+					if (len >= 0x10)
+						pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
+							*dp, *(dp + 1), *(dp + 2), *(dp + 3));
+					else if (len >= 0x08)
+						pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
+							*dp, *(dp + 1));
+					else
+						pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
 				}
 #endif
-			}
 			m = m->snext;
 		}
-	}                               /* -for- */
+	}
 	pr_info("\n");
 
 	if (lockit)
@@ -135,6 +134,10 @@ musycc_dump_txbuffer_ring(mch_t *ch, int lockit)
 	unsigned long flags = 0;
 	u_int32_t   status;
 	int         n;
+#ifdef RLD_DUMP_BUFDATA
+	u_int32_t *dp;
+	int len = 0;
+#endif
 
 	if (lockit)
 		spin_lock_irqsave(&ch->ch_txlock, flags);
@@ -145,37 +148,32 @@ musycc_dump_txbuffer_ring(mch_t *ch, int lockit)
 		m = ch->txd_irq_srv;
 		for (n = ch->txd_num; n; n--) {
 			status = le32_to_cpu(m->status);
-			{
-				pr_info("%c%c %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
-					(m == ch->txd_usr_add) ? 'F' : ' ',
-					(m == ch->txd_irq_srv) ? 'L' : ' ',
-					(unsigned long) m, n,
-					status,
-					m->data ? (status & MUSYCC_TX_OWNED ? 'M' : 'H') : '-',
-					status & POLL_DISABLED ? 'P' : '-',
-					status & EOBIRQ_ENABLE ? 'b' : '-',
-					status & EOMIRQ_ENABLE ? 'm' : '-',
-					status & LENGTH_MASK,
-					le32_to_cpu(m->data), le32_to_cpu(m->next));
+			pr_info("%c%c %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
+				(m == ch->txd_usr_add) ? 'F' : ' ',
+				(m == ch->txd_irq_srv) ? 'L' : ' ',
+				(unsigned long) m, n,
+				status,
+				m->data ? (status & MUSYCC_TX_OWNED ? 'M' : 'H') : '-',
+				status & POLL_DISABLED ? 'P' : '-',
+				status & EOBIRQ_ENABLE ? 'b' : '-',
+				status & EOMIRQ_ENABLE ? 'm' : '-',
+				status & LENGTH_MASK,
+				le32_to_cpu(m->data), le32_to_cpu(m->next));
 #ifdef RLD_DUMP_BUFDATA
-				{
-					u_int32_t  *dp;
-					int         len = status & LENGTH_MASK;
-
-					if (m->data) {
-						dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
-						if (len >= 0x10)
-							pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
-								*dp, *(dp + 1), *(dp + 2), *(dp + 3));
-						else if (len >= 0x08)
-							pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
-								*dp, *(dp + 1));
-						else
-							pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
-					}
-				}
-#endif
+			len = status & LENGTH_MASK;
+
+			if (m->data) {
+				dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
+				if (len >= 0x10)
+					pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
+						*dp, *(dp + 1), *(dp + 2), *(dp + 3));
+				else if (len >= 0x08)
+					pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
+						*dp, *(dp + 1));
+				else
+					pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
 			}
+#endif
 			m = m->snext;
 		}
 	}                               /* -for- */
@@ -195,21 +193,19 @@ status_t
 musycc_dump_ring(ci_t *ci, unsigned int chan)
 {
 	mch_t      *ch;
+	int bh;
 
 	if (chan >= MAX_CHANS_USED)
 		return SBE_DRVR_FAIL;       /* E2BIG */
-	{
-		int         bh;
 
-		bh = atomic_read(&ci->bh_pending);
-		pr_info(">> bh_pend %d [%d] ihead %d itail %d [%d] th_cnt %d bh_cnt %d wdcnt %d note %d\n",
-			bh, max_bh, ci->iqp_headx, ci->iqp_tailx, max_intcnt,
-			ci->intlog.drvr_intr_thcount,
-			ci->intlog.drvr_intr_bhcount,
-			ci->wdcount, ci->wd_notify);
-		max_bh = 0;                 /* reset counter */
-		max_intcnt = 0;             /* reset counter */
-	}
+	bh = atomic_read(&ci->bh_pending);
+	pr_info(">> bh_pend %d [%d] ihead %d itail %d [%d] th_cnt %d bh_cnt %d wdcnt %d note %d\n",
+		bh, max_bh, ci->iqp_headx, ci->iqp_tailx, max_intcnt,
+		ci->intlog.drvr_intr_thcount,
+		ci->intlog.drvr_intr_bhcount,
+		ci->wdcount, ci->wd_notify);
+	max_bh = 0;                 /* reset counter */
+	max_intcnt = 0;             /* reset counter */
 
 	ch = sd_find_chan(dummy, chan);
 	if (!ch) {
@@ -336,6 +332,10 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 	mpi_t      *pi;
 	struct mdesc *md;
 
+#if defined(RLD_TRANS_DEBUG) || defined(RLD_RXACT_DEBUG)
+	static int hereb4 = 7;
+#endif
+
 	ch = container_of(arg, struct c4_chan_info, ch_work);
 	pi = ch->up;
 
@@ -353,24 +353,20 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 
 		ch->ch_start_rx = 0;
 #if defined(RLD_TRANS_DEBUG) || defined(RLD_RXACT_DEBUG)
-		{
-			static int  hereb4 = 7;
-
-			if (hereb4) {            /* RLD DEBUG */
-				hereb4--;
+		if (hereb4) {            /* RLD DEBUG */
+			hereb4--;
 #ifdef RLD_TRANS_DEBUG
-				md = &ch->mdr[ch->rxix_irq_srv];
-				pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
-					ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
-					ch->s.rx_packets);
+			md = &ch->mdr[ch->rxix_irq_srv];
+			pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
+				ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
+				ch->s.rx_packets);
 #elif defined(RLD_RXACT_DEBUG)
-				md = &ch->mdr[ch->rxix_irq_srv];
-				pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
-					ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
-					ch->s.rx_packets);
-				musycc_dump_rxbuffer_ring(ch, 1);      /* RLD DEBUG */
+			md = &ch->mdr[ch->rxix_irq_srv];
+			pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
+				ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
+				ch->s.rx_packets);
+			musycc_dump_rxbuffer_ring(ch, 1);      /* RLD DEBUG */
 #endif
-			}
 		}
 #endif
 		musycc_serv_req(pi, SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION | ch->gchan);
@@ -877,6 +873,9 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 
 		md->data = 0;
 		if (md->mem_token)	{
+#ifdef CONFIG_SBE_WAN256T3_NCOMM
+			int hdlcnum = 0;
+#endif
 			/* upcount channel */
 			atomic_sub(OS_mem_token_tlen(md->mem_token), &ch->tx_pending);
 			/* upcount card */
@@ -888,14 +887,12 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 
 #ifdef CONFIG_SBE_WAN256T3_NCOMM
 			/* callback that our packet was sent */
-			{
-				int         hdlcnum = (pi->portnum * 32 + gchan);
+			hdlcnum = (pi->portnum * 32 + gchan);
 
-				if (hdlcnum >= 228) {
-					if (nciProcess_TX_complete)
-						(*nciProcess_TX_complete) (hdlcnum,
-								getuserbychan(gchan));
-				}
+			if (hdlcnum >= 228) {
+				if (nciProcess_TX_complete)
+					(*nciProcess_TX_complete) (hdlcnum,
+							getuserbychan(gchan));
 			}
 #endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
 
@@ -1361,26 +1358,24 @@ musycc_intr_bh_tasklet(ci_t *ci)
 				 */
 				ch->ch_start_tx = CH_START_TX_ONR;
 
-				{
 #ifdef RLD_TRANS_DEBUG
-					if (1 || cxt1e1_log_level >= LOG_MONITOR)
+				if (1 || cxt1e1_log_level >= LOG_MONITOR)
 #else
-					if (cxt1e1_log_level >= LOG_MONITOR)
+				if (cxt1e1_log_level >= LOG_MONITOR)
 #endif
-					{
-						pr_info("%s: TX buffer underflow [ONR] on channel %d, mode %x QStopped %x free %d\n",
-							ci->devname, ch->channum, ch->p.chan_mode, sd_queue_stopped(ch->user), ch->txd_free);
+				{
+					pr_info("%s: TX buffer underflow [ONR] on channel %d, mode %x QStopped %x free %d\n",
+						ci->devname, ch->channum, ch->p.chan_mode, sd_queue_stopped(ch->user), ch->txd_free);
 #ifdef RLD_DEBUG
-						if (ch->p.chan_mode == 2) {     /* problem = ONR on HDLC
-										 * mode */
-							pr_info("++ Failed Last %x Next %x QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
-								(u_int32_t) ch->txd_irq_srv, (u_int32_t) ch->txd_usr_add,
-								sd_queue_stopped(ch->user),
-								ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
-							musycc_dump_txbuffer_ring(ch, 0);
-						}
-#endif
+					if (ch->p.chan_mode == 2) {     /* problem = ONR on HDLC
+									 * mode */
+						pr_info("++ Failed Last %x Next %x QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
+							(u_int32_t) ch->txd_irq_srv, (u_int32_t) ch->txd_usr_add,
+							sd_queue_stopped(ch->user),
+							ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
+						musycc_dump_txbuffer_ring(ch, 0);
 					}
+#endif
 				}
 			} else {                 /* RX buffer overrun */
 				/*
-- 
1.7.1

