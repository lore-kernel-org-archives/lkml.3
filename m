Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaEIBkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:40:22 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49668 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaEIBkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:40:21 -0400
Date: Fri, 9 May 2014 10:39:48 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: daeseok.youn@gmail.com, himangi774@gmail.com,
        peter.p.waskiewicz.jr@intel.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging: cxt1e1: Fix line length over 80 characters in
 musycc.c
Message-ID: <20140509013948.GA30935@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up checkpatch.pl warning
 WARNING: Line length over 80 characters

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/musycc.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 71bcef3..89f905d 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -392,7 +392,8 @@ musycc_wq_chan_restart(void *arg)      /* channel private structure */
 #endif
 		}
 #endif
-		musycc_serv_req(pi, SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION | ch->gchan);
+		musycc_serv_req(pi, SR_CHANNEL_ACTIVATE |
+				SR_RX_DIRECTION | ch->gchan);
 	}
 
 	/* check for TX restart request */
@@ -816,9 +817,10 @@ musycc_init(ci_t *ci)
 		}
 		/* save orig value for free's usage */
 		pi->regram_saved = regaddr;
-		pi->regram = (struct musycc_groupr *)((unsigned long)(regaddr + GROUP_BOUNDARY - 1) &
-				(~(GROUP_BOUNDARY - 1)));        /* this calculates
-								  * closest boundary */
+		/* this calculates closest boundary */
+		pi->regram = (struct musycc_groupr *)((unsigned long)(regaddr +
+						      GROUP_BOUNDARY - 1) &
+						      (~(GROUP_BOUNDARY - 1)));
 	}
 
 	/* any board centric MUSYCC commands will use group ZERO as its "home" */
@@ -1100,7 +1102,9 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
 			 */
 			if (hdlcnum >= 228) {
 				if (nciProcess_RX_packet)
-					(*nciProcess_RX_packet) (hdlcnum, status & 0x3fff, m, ch->user);
+					(*nciProcess_RX_packet)(hdlcnum, status &
+								0x3fff, m,
+								ch->user);
 			} else
 #endif /* CONFIG_SBE_WAN256T3_NCOMM */
 			{
@@ -1379,7 +1383,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 			else
 				ci->iqd_p[headx] =
 					__constant_cpu_to_le32(INT_EMPTY_ENTRY);
-			ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1); /* insure wrapness */
+			/* insure wrapness */
+			ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);
 			FLUSH_MEM_WRITE();
 			FLUSH_MEM_READ();
 			continue;
@@ -1516,7 +1521,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 					pr_info("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
 						ci->devname, ch->channum,
 						ch->p.chan_mode);
-					//musycc_dump_rxbuffer_ring (ch, 0);        /* RLD DEBUG */
+					/* RLD DEBUG */
+					//musycc_dump_rxbuffer_ring (ch, 0);
 				}
 			}
 			musycc_chan_restart(ch);
@@ -1573,7 +1579,8 @@ musycc_intr_bh_tasklet(ci_t *ci)
 		} /* switch on err */
 
 		/* Check for interrupt lost condition */
-		if ((currInt & INTRPT_ILOST_M) && (cxt1e1_log_level >= LOG_ERROR))
+		if ((currInt & INTRPT_ILOST_M) &&
+		    (cxt1e1_log_level >= LOG_ERROR))
 			pr_info("%s: Interrupt queue overflow - ILOST asserted\n",
 				ci->devname);
 		/* insure wrapness */
@@ -1684,7 +1691,8 @@ musycc_del_chan(ci_t *ci, int channum)
 {
 	mch_t      *ch;
 
-	if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))  /* sanity chk param */
+	/* sanity chk param */
+	if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))
 		return ECHRNG;
 	ch = sd_find_chan(ci, channum);
 	if (!ch)
@@ -1749,7 +1757,8 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	{
 		pr_info("++ start_xmt[%d]: state %x start %x full %d free %d required %d stopped %x\n",
 			channum, ch->state, ch->ch_start_tx, ch->tx_full,
-			ch->txd_free, ch->txd_required, sd_queue_stopped(ch->user));
+			ch->txd_free, ch->txd_required,
+			sd_queue_stopped(ch->user));
 	}
 
 	/* Determine total amount of data to be sent */
-- 
1.7.1

