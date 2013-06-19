Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448Ab3FSLiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 07:38:02 -0400
Received: from 12.mo3.mail-out.ovh.net ([188.165.41.191]:46277 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934022Ab3FSLiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:38:01 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 6/8] ehci-atmel.c: prepare clk before calling enable
Date: Wed, 19 Jun 2013 13:20:09 +0200
Message-Id: <1371640809-9699-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com>
References: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 10673249642098227308
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrjedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/host/ehci-atmel.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 6642009..015ce6e 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -37,15 +37,15 @@ static int clocked;
 
 static void atmel_start_clock(void)
 {
-	clk_enable(iclk);
-	clk_enable(fclk);
+	clk_prepare_enable(iclk);
+	clk_prepare_enable(fclk);
 	clocked = 1;
 }
 
 static void atmel_stop_clock(void)
 {
-	clk_disable(fclk);
-	clk_disable(iclk);
+	clk_disable_unprepare(fclk);
+	clk_disable_unprepare(iclk);
 	clocked = 0;
 }
 
-- 
1.7.9.5

