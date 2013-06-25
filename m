Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3FYIUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:20:48 -0400
Received: from 11.mo1.mail-out.ovh.net ([188.165.48.29]:40044 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292Ab3FYIUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:20:46 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2013 04:20:46 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 4/4] at91/avr32/atmel_lcdfb: prepare clk before calling enable
Date: Tue, 25 Jun 2013 10:14:13 +0200
Message-Id: <1372148053-4477-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372147702-4074-1-git-send-email-b.brezillon@overkiz.com>
References: <1372147702-4074-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 5888456514879846508
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/video/atmel_lcdfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 540909d..8525457 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -893,14 +893,14 @@ static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
 
 static void atmel_lcdfb_start_clock(struct atmel_lcdfb_info *sinfo)
 {
-	clk_enable(sinfo->bus_clk);
-	clk_enable(sinfo->lcdc_clk);
+	clk_prepare_enable(sinfo->bus_clk);
+	clk_prepare_enable(sinfo->lcdc_clk);
 }
 
 static void atmel_lcdfb_stop_clock(struct atmel_lcdfb_info *sinfo)
 {
-	clk_disable(sinfo->bus_clk);
-	clk_disable(sinfo->lcdc_clk);
+	clk_disable_unprepare(sinfo->bus_clk);
+	clk_disable_unprepare(sinfo->lcdc_clk);
 }
 
 
-- 
1.7.9.5

