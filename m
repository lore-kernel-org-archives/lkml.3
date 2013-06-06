Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3FFU4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:56:43 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54566 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab3FFUzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:55:54 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 8/8] isdn: clean up debug format string usage
Date: Thu,  6 Jun 2013 13:52:25 -0700
Message-Id: <1370551945-8444-9-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370551945-8444-1-git-send-email-keescook@chromium.org>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid unneeded local string buffers for constructing debug output. Also
cleans up debug calls that contain a single parameter so that they cannot
be accidentally parsed as format strings.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/hisax/amd7930_fn.c   |    4 +--
 drivers/isdn/hisax/avm_pci.c      |    4 +--
 drivers/isdn/hisax/config.c       |    2 +-
 drivers/isdn/hisax/diva.c         |    4 +--
 drivers/isdn/hisax/elsa.c         |    2 +-
 drivers/isdn/hisax/elsa_ser.c     |    2 +-
 drivers/isdn/hisax/hfc_pci.c      |    2 +-
 drivers/isdn/hisax/hfc_sx.c       |    2 +-
 drivers/isdn/hisax/hscx_irq.c     |    4 +--
 drivers/isdn/hisax/icc.c          |    4 +--
 drivers/isdn/hisax/ipacx.c        |    8 +++---
 drivers/isdn/hisax/isac.c         |    4 +--
 drivers/isdn/hisax/isar.c         |    6 ++---
 drivers/isdn/hisax/jade.c         |   18 ++++---------
 drivers/isdn/hisax/jade_irq.c     |    4 +--
 drivers/isdn/hisax/l3_1tr6.c      |   50 +++++++++++++------------------------
 drivers/isdn/hisax/netjet.c       |    2 +-
 drivers/isdn/hisax/q931.c         |    6 ++---
 drivers/isdn/hisax/w6692.c        |    8 +++---
 drivers/isdn/mISDN/dsp_pipeline.c |    2 +-
 20 files changed, 58 insertions(+), 80 deletions(-)

diff --git a/drivers/isdn/hisax/amd7930_fn.c b/drivers/isdn/hisax/amd7930_fn.c
index 1063bab..36817e0 100644
--- a/drivers/isdn/hisax/amd7930_fn.c
+++ b/drivers/isdn/hisax/amd7930_fn.c
@@ -314,7 +314,7 @@ Amd7930_empty_Dfifo(struct IsdnCardState *cs, int flag)
 
 							t += sprintf(t, "Amd7930: empty_Dfifo cnt: %d |", cs->rcvidx);
 							QuickHex(t, cs->rcvbuf, cs->rcvidx);
-							debugl1(cs, cs->dlog);
+							debugl1(cs, "%s", cs->dlog);
 						}
 						/* moves received data in sk-buffer */
 						memcpy(skb_put(skb, cs->rcvidx), cs->rcvbuf, cs->rcvidx);
@@ -406,7 +406,7 @@ Amd7930_fill_Dfifo(struct IsdnCardState *cs)
 
 		t += sprintf(t, "Amd7930: fill_Dfifo cnt: %d |", count);
 		QuickHex(t, deb_ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 	/* AMD interrupts on */
 	AmdIrqOn(cs);
diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index ee9b9a0..d1427bd 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -285,7 +285,7 @@ hdlc_empty_fifo(struct BCState *bcs, int count)
 		t += sprintf(t, "hdlc_empty_fifo %c cnt %d",
 			     bcs->channel ? 'B' : 'A', count);
 		QuickHex(t, p, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
@@ -345,7 +345,7 @@ hdlc_fill_fifo(struct BCState *bcs)
 		t += sprintf(t, "hdlc_fill_fifo %c cnt %d",
 			     bcs->channel ? 'B' : 'A', count);
 		QuickHex(t, p, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index bf04d2a..b33f53b 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1896,7 +1896,7 @@ static void EChannel_proc_rcv(struct hisax_d_if *d_if)
 				ptr--;
 				*ptr++ = '\n';
 				*ptr = 0;
-				HiSax_putstatus(cs, NULL, cs->dlog);
+				HiSax_putstatus(cs, NULL, "%s", cs->dlog);
 			} else
 				HiSax_putstatus(cs, "LogEcho: ",
 						"warning Frame too big (%d)",
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 8d0cf6e..4fc90de6 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -427,7 +427,7 @@ Memhscx_empty_fifo(struct BCState *bcs, int count)
 		t += sprintf(t, "hscx_empty_fifo %c cnt %d",
 			     bcs->hw.hscx.hscx ? 'B' : 'A', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
@@ -469,7 +469,7 @@ Memhscx_fill_fifo(struct BCState *bcs)
 		t += sprintf(t, "hscx_fill_fifo %c cnt %d",
 			     bcs->hw.hscx.hscx ? 'B' : 'A', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 1df6f9a..2be1c8a 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -535,7 +535,7 @@ check_arcofi(struct IsdnCardState *cs)
 		t = tmp;
 		t += sprintf(tmp, "Arcofi data");
 		QuickHex(t, p, cs->dc.isac.mon_rxp);
-		debugl1(cs, tmp);
+		debugl1(cs, "%s", tmp);
 		if ((cs->dc.isac.mon_rxp == 2) && (cs->dc.isac.mon_rx[0] == 0xa0)) {
 			switch (cs->dc.isac.mon_rx[1]) {
 			case 0x80:
diff --git a/drivers/isdn/hisax/elsa_ser.c b/drivers/isdn/hisax/elsa_ser.c
index d4c98d3..3f84dd8 100644
--- a/drivers/isdn/hisax/elsa_ser.c
+++ b/drivers/isdn/hisax/elsa_ser.c
@@ -344,7 +344,7 @@ static inline void receive_chars(struct IsdnCardState *cs,
 
 		t += sprintf(t, "modem read cnt %d", cs->hw.elsa.rcvcnt);
 		QuickHex(t, cs->hw.elsa.rcvbuf, cs->hw.elsa.rcvcnt);
-		debugl1(cs, tmp);
+		debugl1(cs, "%s", tmp);
 	}
 	cs->hw.elsa.rcvcnt = 0;
 }
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 3ccd724..497bd02 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -901,7 +901,7 @@ Begin:
 					ptr--;
 					*ptr++ = '\n';
 					*ptr = 0;
-					HiSax_putstatus(cs, NULL, cs->dlog);
+					HiSax_putstatus(cs, NULL, "%s", cs->dlog);
 				} else
 					HiSax_putstatus(cs, "LogEcho: ", "warning Frame too big (%d)", total - 3);
 			}
diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index dc4574f..fa1fefd 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -674,7 +674,7 @@ receive_emsg(struct IsdnCardState *cs)
 					ptr--;
 					*ptr++ = '\n';
 					*ptr = 0;
-					HiSax_putstatus(cs, NULL, cs->dlog);
+					HiSax_putstatus(cs, NULL, "%s", cs->dlog);
 				} else
 					HiSax_putstatus(cs, "LogEcho: ", "warning Frame too big (%d)", skb->len);
 			}
diff --git a/drivers/isdn/hisax/hscx_irq.c b/drivers/isdn/hisax/hscx_irq.c
index f398d48..a8d6188 100644
--- a/drivers/isdn/hisax/hscx_irq.c
+++ b/drivers/isdn/hisax/hscx_irq.c
@@ -75,7 +75,7 @@ hscx_empty_fifo(struct BCState *bcs, int count)
 		t += sprintf(t, "hscx_empty_fifo %c cnt %d",
 			     bcs->hw.hscx.hscx ? 'B' : 'A', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
@@ -115,7 +115,7 @@ hscx_fill_fifo(struct BCState *bcs)
 		t += sprintf(t, "hscx_fill_fifo %c cnt %d",
 			     bcs->hw.hscx.hscx ? 'B' : 'A', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
diff --git a/drivers/isdn/hisax/icc.c b/drivers/isdn/hisax/icc.c
index db5321f..51dae91 100644
--- a/drivers/isdn/hisax/icc.c
+++ b/drivers/isdn/hisax/icc.c
@@ -134,7 +134,7 @@ icc_empty_fifo(struct IsdnCardState *cs, int count)
 
 		t += sprintf(t, "icc_empty_fifo cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
@@ -176,7 +176,7 @@ icc_fill_fifo(struct IsdnCardState *cs)
 
 		t += sprintf(t, "icc_fill_fifo cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
diff --git a/drivers/isdn/hisax/ipacx.c b/drivers/isdn/hisax/ipacx.c
index 74feb5c..5faa5de 100644
--- a/drivers/isdn/hisax/ipacx.c
+++ b/drivers/isdn/hisax/ipacx.c
@@ -260,7 +260,7 @@ dch_empty_fifo(struct IsdnCardState *cs, int count)
 
 		t += sprintf(t, "dch_empty_fifo() cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
@@ -307,7 +307,7 @@ dch_fill_fifo(struct IsdnCardState *cs)
 
 		t += sprintf(t, "dch_fill_fifo() cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
@@ -539,7 +539,7 @@ bch_empty_fifo(struct BCState *bcs, int count)
 
 		t += sprintf(t, "bch_empty_fifo() B-%d cnt %d", hscx, count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
@@ -582,7 +582,7 @@ bch_fill_fifo(struct BCState *bcs)
 
 		t += sprintf(t, "chb_fill_fifo() B-%d cnt %d", hscx, count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
diff --git a/drivers/isdn/hisax/isac.c b/drivers/isdn/hisax/isac.c
index a365ccc..7fdf78f 100644
--- a/drivers/isdn/hisax/isac.c
+++ b/drivers/isdn/hisax/isac.c
@@ -137,7 +137,7 @@ isac_empty_fifo(struct IsdnCardState *cs, int count)
 
 		t += sprintf(t, "isac_empty_fifo cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
@@ -179,7 +179,7 @@ isac_fill_fifo(struct IsdnCardState *cs)
 
 		t += sprintf(t, "isac_fill_fifo cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
diff --git a/drivers/isdn/hisax/isar.c b/drivers/isdn/hisax/isar.c
index 7fdf347..f4956c7 100644
--- a/drivers/isdn/hisax/isar.c
+++ b/drivers/isdn/hisax/isar.c
@@ -74,7 +74,7 @@ sendmsg(struct IsdnCardState *cs, u_char his, u_char creg, u_char len,
 				t = tmp;
 				t += sprintf(t, "sendmbox cnt %d", len);
 				QuickHex(t, &msg[len-i], (i > 64) ? 64 : i);
-				debugl1(cs, tmp);
+				debugl1(cs, "%s", tmp);
 				i -= 64;
 			}
 		}
@@ -105,7 +105,7 @@ rcv_mbox(struct IsdnCardState *cs, struct isar_reg *ireg, u_char *msg)
 				t = tmp;
 				t += sprintf(t, "rcv_mbox cnt %d", ireg->clsb);
 				QuickHex(t, &msg[ireg->clsb - i], (i > 64) ? 64 : i);
-				debugl1(cs, tmp);
+				debugl1(cs, "%s", tmp);
 				i -= 64;
 			}
 		}
@@ -1248,7 +1248,7 @@ isar_int_main(struct IsdnCardState *cs)
 			tp += sprintf(debbuf, "msg iis(%x) msb(%x)",
 				      ireg->iis, ireg->cmsb);
 			QuickHex(tp, (u_char *)ireg->par, ireg->clsb);
-			debugl1(cs, debbuf);
+			debugl1(cs, "%s", debbuf);
 		}
 		break;
 	case ISAR_IIS_INVMSG:
diff --git a/drivers/isdn/hisax/jade.c b/drivers/isdn/hisax/jade.c
index f946c58..e2ae787 100644
--- a/drivers/isdn/hisax/jade.c
+++ b/drivers/isdn/hisax/jade.c
@@ -81,10 +81,7 @@ modejade(struct BCState *bcs, int mode, int bc)
 	int jade = bcs->hw.hscx.hscx;
 
 	if (cs->debug & L1_DEB_HSCX) {
-		char tmp[40];
-		sprintf(tmp, "jade %c mode %d ichan %d",
-			'A' + jade, mode, bc);
-		debugl1(cs, tmp);
+		debugl1(cs, "jade %c mode %d ichan %d", 'A' + jade, mode, bc);
 	}
 	bcs->mode = mode;
 	bcs->channel = bc;
@@ -257,23 +254,18 @@ void
 clear_pending_jade_ints(struct IsdnCardState *cs)
 {
 	int val;
-	char tmp[64];
 
 	cs->BC_Write_Reg(cs, 0, jade_HDLC_IMR, 0x00);
 	cs->BC_Write_Reg(cs, 1, jade_HDLC_IMR, 0x00);
 
 	val = cs->BC_Read_Reg(cs, 1, jade_HDLC_ISR);
-	sprintf(tmp, "jade B ISTA %x", val);
-	debugl1(cs, tmp);
+	debugl1(cs, "jade B ISTA %x", val);
 	val = cs->BC_Read_Reg(cs, 0, jade_HDLC_ISR);
-	sprintf(tmp, "jade A ISTA %x", val);
-	debugl1(cs, tmp);
+	debugl1(cs, "jade A ISTA %x", val);
 	val = cs->BC_Read_Reg(cs, 1, jade_HDLC_STAR);
-	sprintf(tmp, "jade B STAR %x", val);
-	debugl1(cs, tmp);
+	debugl1(cs, "jade B STAR %x", val);
 	val = cs->BC_Read_Reg(cs, 0, jade_HDLC_STAR);
-	sprintf(tmp, "jade A STAR %x", val);
-	debugl1(cs, tmp);
+	debugl1(cs, "jade A STAR %x", val);
 	/* Unmask ints */
 	cs->BC_Write_Reg(cs, 0, jade_HDLC_IMR, 0xF8);
 	cs->BC_Write_Reg(cs, 1, jade_HDLC_IMR, 0xF8);
diff --git a/drivers/isdn/hisax/jade_irq.c b/drivers/isdn/hisax/jade_irq.c
index f521fc8..b930da9 100644
--- a/drivers/isdn/hisax/jade_irq.c
+++ b/drivers/isdn/hisax/jade_irq.c
@@ -65,7 +65,7 @@ jade_empty_fifo(struct BCState *bcs, int count)
 		t += sprintf(t, "jade_empty_fifo %c cnt %d",
 			     bcs->hw.hscx.hscx ? 'B' : 'A', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
@@ -105,7 +105,7 @@ jade_fill_fifo(struct BCState *bcs)
 		t += sprintf(t, "jade_fill_fifo %c cnt %d",
 			     bcs->hw.hscx.hscx ? 'B' : 'A', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
diff --git a/drivers/isdn/hisax/l3_1tr6.c b/drivers/isdn/hisax/l3_1tr6.c
index 4c1bca5..875402e 100644
--- a/drivers/isdn/hisax/l3_1tr6.c
+++ b/drivers/isdn/hisax/l3_1tr6.c
@@ -63,7 +63,7 @@ l3_1tr6_error(struct l3_process *pc, u_char *msg, struct sk_buff *skb)
 {
 	dev_kfree_skb(skb);
 	if (pc->st->l3.debug & L3_DEB_WARN)
-		l3_debug(pc->st, msg);
+		l3_debug(pc->st, "%s", msg);
 	l3_1tr6_release_req(pc, 0, NULL);
 }
 
@@ -161,7 +161,6 @@ l3_1tr6_setup(struct l3_process *pc, u_char pr, void *arg)
 {
 	u_char *p;
 	int bcfound = 0;
-	char tmp[80];
 	struct sk_buff *skb = arg;
 
 	/* Channel Identification */
@@ -214,10 +213,9 @@ l3_1tr6_setup(struct l3_process *pc, u_char pr, void *arg)
 	/* Signal all services, linklevel takes care of Service-Indicator */
 	if (bcfound) {
 		if ((pc->para.setup.si1 != 7) && (pc->st->l3.debug & L3_DEB_WARN)) {
-			sprintf(tmp, "non-digital call: %s -> %s",
+			l3_debug(pc->st, "non-digital call: %s -> %s",
 				pc->para.setup.phone,
 				pc->para.setup.eazmsn);
-			l3_debug(pc->st, tmp);
 		}
 		newl3state(pc, 6);
 		pc->st->l3.l3l4(pc->st, CC_SETUP | INDICATION, pc);
@@ -301,7 +299,7 @@ l3_1tr6_info(struct l3_process *pc, u_char pr, void *arg)
 {
 	u_char *p;
 	int i, tmpcharge = 0;
-	char a_charge[8], tmp[32];
+	char a_charge[8];
 	struct sk_buff *skb = arg;
 
 	p = skb->data;
@@ -316,8 +314,8 @@ l3_1tr6_info(struct l3_process *pc, u_char pr, void *arg)
 			pc->st->l3.l3l4(pc->st, CC_CHARGE | INDICATION, pc);
 		}
 		if (pc->st->l3.debug & L3_DEB_CHARGE) {
-			sprintf(tmp, "charging info %d", pc->para.chargeinfo);
-			l3_debug(pc->st, tmp);
+			l3_debug(pc->st, "charging info %d",
+				 pc->para.chargeinfo);
 		}
 	} else if (pc->st->l3.debug & L3_DEB_CHARGE)
 		l3_debug(pc->st, "charging info not found");
@@ -399,7 +397,7 @@ l3_1tr6_disc(struct l3_process *pc, u_char pr, void *arg)
 	struct sk_buff *skb = arg;
 	u_char *p;
 	int i, tmpcharge = 0;
-	char a_charge[8], tmp[32];
+	char a_charge[8];
 
 	StopAllL3Timer(pc);
 	p = skb->data;
@@ -414,8 +412,8 @@ l3_1tr6_disc(struct l3_process *pc, u_char pr, void *arg)
 			pc->st->l3.l3l4(pc->st, CC_CHARGE | INDICATION, pc);
 		}
 		if (pc->st->l3.debug & L3_DEB_CHARGE) {
-			sprintf(tmp, "charging info %d", pc->para.chargeinfo);
-			l3_debug(pc->st, tmp);
+			l3_debug(pc->st, "charging info %d",
+				 pc->para.chargeinfo);
 		}
 	} else if (pc->st->l3.debug & L3_DEB_CHARGE)
 		l3_debug(pc->st, "charging info not found");
@@ -746,7 +744,6 @@ up1tr6(struct PStack *st, int pr, void *arg)
 	int i, mt, cr;
 	struct l3_process *proc;
 	struct sk_buff *skb = arg;
-	char tmp[80];
 
 	switch (pr) {
 	case (DL_DATA | INDICATION):
@@ -762,26 +759,23 @@ up1tr6(struct PStack *st, int pr, void *arg)
 	}
 	if (skb->len < 4) {
 		if (st->l3.debug & L3_DEB_PROTERR) {
-			sprintf(tmp, "up1tr6 len only %d", skb->len);
-			l3_debug(st, tmp);
+			l3_debug(st, "up1tr6 len only %d", skb->len);
 		}
 		dev_kfree_skb(skb);
 		return;
 	}
 	if ((skb->data[0] & 0xfe) != PROTO_DIS_N0) {
 		if (st->l3.debug & L3_DEB_PROTERR) {
-			sprintf(tmp, "up1tr6%sunexpected discriminator %x message len %d",
+			l3_debug(st, "up1tr6%sunexpected discriminator %x message len %d",
 				(pr == (DL_DATA | INDICATION)) ? " " : "(broadcast) ",
 				skb->data[0], skb->len);
-			l3_debug(st, tmp);
 		}
 		dev_kfree_skb(skb);
 		return;
 	}
 	if (skb->data[1] != 1) {
 		if (st->l3.debug & L3_DEB_PROTERR) {
-			sprintf(tmp, "up1tr6 CR len not 1");
-			l3_debug(st, tmp);
+			l3_debug(st, "up1tr6 CR len not 1");
 		}
 		dev_kfree_skb(skb);
 		return;
@@ -791,9 +785,8 @@ up1tr6(struct PStack *st, int pr, void *arg)
 	if (skb->data[0] == PROTO_DIS_N0) {
 		dev_kfree_skb(skb);
 		if (st->l3.debug & L3_DEB_STATE) {
-			sprintf(tmp, "up1tr6%s N0 mt %x unhandled",
+			l3_debug(st, "up1tr6%s N0 mt %x unhandled",
 				(pr == (DL_DATA | INDICATION)) ? " " : "(broadcast) ", mt);
-			l3_debug(st, tmp);
 		}
 	} else if (skb->data[0] == PROTO_DIS_N1) {
 		if (!(proc = getl3proc(st, cr))) {
@@ -801,8 +794,7 @@ up1tr6(struct PStack *st, int pr, void *arg)
 				if (cr < 128) {
 					if (!(proc = new_l3_process(st, cr))) {
 						if (st->l3.debug & L3_DEB_PROTERR) {
-							sprintf(tmp, "up1tr6 no roc mem");
-							l3_debug(st, tmp);
+							l3_debug(st, "up1tr6 no roc mem");
 						}
 						dev_kfree_skb(skb);
 						return;
@@ -821,8 +813,7 @@ up1tr6(struct PStack *st, int pr, void *arg)
 			} else {
 				if (!(proc = new_l3_process(st, cr))) {
 					if (st->l3.debug & L3_DEB_PROTERR) {
-						sprintf(tmp, "up1tr6 no roc mem");
-						l3_debug(st, tmp);
+						l3_debug(st, "up1tr6 no roc mem");
 					}
 					dev_kfree_skb(skb);
 					return;
@@ -837,18 +828,16 @@ up1tr6(struct PStack *st, int pr, void *arg)
 		if (i == ARRAY_SIZE(datastln1)) {
 			dev_kfree_skb(skb);
 			if (st->l3.debug & L3_DEB_STATE) {
-				sprintf(tmp, "up1tr6%sstate %d mt %x unhandled",
+				l3_debug(st, "up1tr6%sstate %d mt %x unhandled",
 					(pr == (DL_DATA | INDICATION)) ? " " : "(broadcast) ",
 					proc->state, mt);
-				l3_debug(st, tmp);
 			}
 			return;
 		} else {
 			if (st->l3.debug & L3_DEB_STATE) {
-				sprintf(tmp, "up1tr6%sstate %d mt %x",
+				l3_debug(st, "up1tr6%sstate %d mt %x",
 					(pr == (DL_DATA | INDICATION)) ? " " : "(broadcast) ",
 					proc->state, mt);
-				l3_debug(st, tmp);
 			}
 			datastln1[i].rout(proc, pr, skb);
 		}
@@ -861,7 +850,6 @@ down1tr6(struct PStack *st, int pr, void *arg)
 	int i, cr;
 	struct l3_process *proc;
 	struct Channel *chan;
-	char tmp[80];
 
 	if ((DL_ESTABLISH | REQUEST) == pr) {
 		l3_msg(st, pr, NULL);
@@ -888,15 +876,13 @@ down1tr6(struct PStack *st, int pr, void *arg)
 			break;
 	if (i == ARRAY_SIZE(downstl)) {
 		if (st->l3.debug & L3_DEB_STATE) {
-			sprintf(tmp, "down1tr6 state %d prim %d unhandled",
+			l3_debug(st, "down1tr6 state %d prim %d unhandled",
 				proc->state, pr);
-			l3_debug(st, tmp);
 		}
 	} else {
 		if (st->l3.debug & L3_DEB_STATE) {
-			sprintf(tmp, "down1tr6 state %d prim %d",
+			l3_debug(st, "down1tr6 state %d prim %d",
 				proc->state, pr);
-			l3_debug(st, tmp);
 		}
 		downstl[i].rout(proc, pr, arg);
 	}
diff --git a/drivers/isdn/hisax/netjet.c b/drivers/isdn/hisax/netjet.c
index b646eed..233e432 100644
--- a/drivers/isdn/hisax/netjet.c
+++ b/drivers/isdn/hisax/netjet.c
@@ -176,7 +176,7 @@ static void printframe(struct IsdnCardState *cs, u_char *buf, int count, char *s
 		else
 			j = i;
 		QuickHex(t, p, j);
-		debugl1(cs, tmp);
+		debugl1(cs, "%s", tmp);
 		p += j;
 		i -= j;
 		t = tmp;
diff --git a/drivers/isdn/hisax/q931.c b/drivers/isdn/hisax/q931.c
index 041bf52..af1b020 100644
--- a/drivers/isdn/hisax/q931.c
+++ b/drivers/isdn/hisax/q931.c
@@ -1179,7 +1179,7 @@ LogFrame(struct IsdnCardState *cs, u_char *buf, int size)
 		dp--;
 		*dp++ = '\n';
 		*dp = 0;
-		HiSax_putstatus(cs, NULL, cs->dlog);
+		HiSax_putstatus(cs, NULL, "%s", cs->dlog);
 	} else
 		HiSax_putstatus(cs, "LogFrame: ", "warning Frame too big (%d)", size);
 }
@@ -1246,7 +1246,7 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 	}
 	if (finish) {
 		*dp = 0;
-		HiSax_putstatus(cs, NULL, cs->dlog);
+		HiSax_putstatus(cs, NULL, "%s", cs->dlog);
 		return;
 	}
 	if ((0xfe & buf[0]) == PROTO_DIS_N0) {	/* 1TR6 */
@@ -1509,5 +1509,5 @@ dlogframe(struct IsdnCardState *cs, struct sk_buff *skb, int dir)
 		dp += sprintf(dp, "Unknown protocol %x!", buf[0]);
 	}
 	*dp = 0;
-	HiSax_putstatus(cs, NULL, cs->dlog);
+	HiSax_putstatus(cs, NULL, "%s", cs->dlog);
 }
diff --git a/drivers/isdn/hisax/w6692.c b/drivers/isdn/hisax/w6692.c
index d8cac69..a858955 100644
--- a/drivers/isdn/hisax/w6692.c
+++ b/drivers/isdn/hisax/w6692.c
@@ -154,7 +154,7 @@ W6692_empty_fifo(struct IsdnCardState *cs, int count)
 
 		t += sprintf(t, "W6692_empty_fifo cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
@@ -196,7 +196,7 @@ W6692_fill_fifo(struct IsdnCardState *cs)
 
 		t += sprintf(t, "W6692_fill_fifo cnt %d", count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, cs->dlog);
+		debugl1(cs, "%s", cs->dlog);
 	}
 }
 
@@ -226,7 +226,7 @@ W6692B_empty_fifo(struct BCState *bcs, int count)
 		t += sprintf(t, "W6692B_empty_fifo %c cnt %d",
 			     bcs->channel + '1', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
@@ -264,7 +264,7 @@ W6692B_fill_fifo(struct BCState *bcs)
 		t += sprintf(t, "W6692B_fill_fifo %c cnt %d",
 			     bcs->channel + '1', count);
 		QuickHex(t, ptr, count);
-		debugl1(cs, bcs->blog);
+		debugl1(cs, "%s", bcs->blog);
 	}
 }
 
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 8b1a66c..88305c9 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -102,7 +102,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	entry->dev.class = elements_class;
 	entry->dev.release = mISDN_dsp_dev_release;
 	dev_set_drvdata(&entry->dev, elem);
-	dev_set_name(&entry->dev, "%s", elem->name);
+	dev_set_name(&entry->dev, elem->name);
 	ret = device_register(&entry->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register %s\n",
-- 
1.7.9.5

