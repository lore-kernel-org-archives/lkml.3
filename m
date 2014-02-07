Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaBGMr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:47:59 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58771 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaBGMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:47:57 -0500
Date: Fri, 7 Feb 2014 18:17:52 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 24/26] drivers: isdn: Move prototype declaration to header
 file hisax.h from config.c
Message-ID: <7a100c457a882b2de084a50bdbd8b65827dc7aaf.1390408519.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of functions to header file hisax/hisax.h
because they are used by more than one file.

This eliminates the following warnings:
drivers/isdn/hisax/teles3.c:273:5: warning: no previous prototype for ‘setup_teles3’ [-Wmissing-prototypes]
drivers/isdn/hisax/telespci.c:288:5: warning: no previous prototype for ‘setup_telespci’ [-Wmissing-prototypes]
drivers/isdn/hisax/s0box.c:213:5: warning: no previous prototype for ‘setup_s0box’ [-Wmissing-prototypes]
drivers/isdn/hisax/avm_a1p.c:216:5: warning: no previous prototype for ‘setup_avm_a1_pcmcia’ [-Wmissing-prototypes]
drivers/isdn/hisax/avm_pci.c:870:5: warning: no previous prototype for ‘setup_avm_pcipnp’ [-Wmissing-prototypes]
drivers/isdn/hisax/elsa.c:1209:5: warning: no previous prototype for ‘setup_elsa’ [-Wmissing-prototypes]
drivers/isdn/hisax/diva.c:1241:5: warning: no previous prototype for ‘setup_diva’ [-Wmissing-prototypes]
drivers/isdn/hisax/sedlbauer.c:674:5: warning: no previous prototype for ‘setup_sedlbauer’ [-Wmissing-prototypes]
drivers/isdn/hisax/nj_s.c:258:5: warning: no previous prototype for ‘setup_netjet_s’ [-Wmissing-prototypes]
drivers/isdn/hisax/nj_u.c:221:5: warning: no previous prototype for ‘setup_netjet_u’ [-Wmissing-prototypes]
drivers/isdn/hisax/hfc_pci.c:1638:1: warning: no previous prototype for ‘setup_hfcpci’ [-Wmissing-prototypes]
drivers/isdn/hisax/hfc_sx.c:1395:5: warning: no previous prototype for ‘setup_hfcsx’ [-Wmissing-prototypes]
drivers/isdn/hisax/niccy.c:229:5: warning: no previous prototype for ‘setup_niccy’ [-Wmissing-prototypes]
drivers/isdn/hisax/bkm_a4t.c:325:5: warning: no previous prototype for ‘setup_bkm_a4t’ [-Wmissing-prototypes]
drivers/isdn/hisax/bkm_a8.c:276:5: warning: no previous prototype for ‘setup_sct_quadro’ [-Wmissing-prototypes]
drivers/isdn/hisax/gazel.c:623:5: warning: no previous prototype for ‘setup_gazel’ [-Wmissing-prototypes]
drivers/isdn/hisax/w6692.c:996:5: warning: no previous prototype for ‘setup_w6692’ [-Wmissing-prototypes]
drivers/isdn/hisax/enternow_pci.c:387:5: warning: no previous prototype for ‘setup_enternow_pci’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hisax/config.c |   72 -------------------------------------------
 drivers/isdn/hisax/hisax.h  |   71 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 72 deletions(-)

diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index b33f53b..196cbb8 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -460,42 +460,14 @@ __setup("hisax=", HiSax_setup);
 extern int setup_teles0(struct IsdnCard *card);
 #endif
 
-#if CARD_TELES3
-extern int setup_teles3(struct IsdnCard *card);
-#endif
-
-#if CARD_S0BOX
-extern int setup_s0box(struct IsdnCard *card);
-#endif
-
-#if CARD_TELESPCI
-extern int setup_telespci(struct IsdnCard *card);
-#endif
-
 #if CARD_AVM_A1
 extern int setup_avm_a1(struct IsdnCard *card);
 #endif
 
-#if CARD_AVM_A1_PCMCIA
-extern int setup_avm_a1_pcmcia(struct IsdnCard *card);
-#endif
-
-#if CARD_FRITZPCI
-extern int setup_avm_pcipnp(struct IsdnCard *card);
-#endif
-
-#if CARD_ELSA
-extern int setup_elsa(struct IsdnCard *card);
-#endif
-
 #if CARD_IX1MICROR2
 extern int setup_ix1micro(struct IsdnCard *card);
 #endif
 
-#if CARD_DIEHLDIVA
-extern int setup_diva(struct IsdnCard *card);
-#endif
-
 #if CARD_ASUSCOM
 extern int setup_asuscom(struct IsdnCard *card);
 #endif
@@ -504,10 +476,6 @@ extern int setup_asuscom(struct IsdnCard *card);
 extern int setup_TeleInt(struct IsdnCard *card);
 #endif
 
-#if CARD_SEDLBAUER
-extern int setup_sedlbauer(struct IsdnCard *card);
-#endif
-
 #if CARD_SPORTSTER
 extern int setup_sportster(struct IsdnCard *card);
 #endif
@@ -516,26 +484,10 @@ extern int setup_sportster(struct IsdnCard *card);
 extern int setup_mic(struct IsdnCard *card);
 #endif
 
-#if CARD_NETJET_S
-extern int setup_netjet_s(struct IsdnCard *card);
-#endif
-
 #if CARD_HFCS
 extern int setup_hfcs(struct IsdnCard *card);
 #endif
 
-#if CARD_HFC_PCI
-extern int setup_hfcpci(struct IsdnCard *card);
-#endif
-
-#if CARD_HFC_SX
-extern int setup_hfcsx(struct IsdnCard *card);
-#endif
-
-#if CARD_NICCY
-extern int setup_niccy(struct IsdnCard *card);
-#endif
-
 #if CARD_ISURF
 extern int setup_isurf(struct IsdnCard *card);
 #endif
@@ -544,30 +496,6 @@ extern int setup_isurf(struct IsdnCard *card);
 extern int setup_saphir(struct IsdnCard *card);
 #endif
 
-#if CARD_BKM_A4T
-extern int setup_bkm_a4t(struct IsdnCard *card);
-#endif
-
-#if CARD_SCT_QUADRO
-extern int setup_sct_quadro(struct IsdnCard *card);
-#endif
-
-#if CARD_GAZEL
-extern int setup_gazel(struct IsdnCard *card);
-#endif
-
-#if CARD_W6692
-extern int setup_w6692(struct IsdnCard *card);
-#endif
-
-#if CARD_NETJET_U
-extern int setup_netjet_u(struct IsdnCard *card);
-#endif
-
-#if CARD_FN_ENTERNOW_PCI
-extern int setup_enternow_pci(struct IsdnCard *card);
-#endif
-
 /*
  * Find card with given driverId
  */
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index 6ead6314..90d68d1 100644
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -1327,6 +1327,77 @@ void release_tei(struct IsdnCardState *cs);
 char *HiSax_getrev(const char *revision);
 int TeiNew(void);
 void TeiFree(void);
+#if CARD_TELES3
+int setup_teles3(struct IsdnCard *card);
+#endif
+
+#if CARD_TELESPCI
+extern int setup_telespci(struct IsdnCard *card);
+#endif
+
+#if CARD_S0BOX
+extern int setup_s0box(struct IsdnCard *card);
+#endif
+
+#if CARD_AVM_A1_PCMCIA
+extern int setup_avm_a1_pcmcia(struct IsdnCard *card);
+#endif
+
+#if CARD_FRITZPCI
+extern int setup_avm_pcipnp(struct IsdnCard *card);
+#endif
+
+#if CARD_ELSA
+extern int setup_elsa(struct IsdnCard *card);
+#endif
+
+#if CARD_DIEHLDIVA
+extern int setup_diva(struct IsdnCard *card);
+#endif
+
+#if CARD_SEDLBAUER
+extern int setup_sedlbauer(struct IsdnCard *card);
+#endif
+
+#if CARD_NETJET_S
+extern int setup_netjet_s(struct IsdnCard *card);
+#endif
+
+#if CARD_HFC_PCI
+extern int setup_hfcpci(struct IsdnCard *card);
+#endif
+
+#if CARD_HFC_SX
+extern int setup_hfcsx(struct IsdnCard *card);
+#endif
+
+#if CARD_NICCY
+extern int setup_niccy(struct IsdnCard *card);
+#endif
+
+#if CARD_BKM_A4T
+extern int setup_bkm_a4t(struct IsdnCard *card);
+#endif
+
+#if CARD_SCT_QUADRO
+extern int setup_sct_quadro(struct IsdnCard *card);
+#endif
+
+#if CARD_GAZEL
+extern int setup_gazel(struct IsdnCard *card);
+#endif
+
+#if CARD_W6692
+extern int setup_w6692(struct IsdnCard *card);
+#endif
+
+#if CARD_NETJET_U
+extern int setup_netjet_u(struct IsdnCard *card);
+#endif
+
+#if CARD_FN_ENTERNOW_PCI
+extern int setup_enternow_pci(struct IsdnCard *card);
+#endif
 
 #ifdef CONFIG_PCI
 
-- 
1.7.9.5

