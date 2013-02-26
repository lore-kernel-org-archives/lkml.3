Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab3BZWy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:54:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33111 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab3BZWy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:54:26 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ruslan Ruslichenko <x0191366@ti.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 01/15] staging: omap-thermal: Add print when TSHUT temperature reached
Date: Tue, 26 Feb 2013 18:53:24 -0400
Message-ID: <1361919218-9788-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ruslan Ruslichenko <x0191366@ti.com>

To indicate that board was shut down due to TSHUT temperature reached
it is good to print some information message before shutting down.

Signed-off-by: Ruslan Ruslichenko <x0191366@ti.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index dcc1448..35b9915 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -133,6 +133,9 @@ static irqreturn_t talert_irq_handler(int irq, void *data)
 /* This is the Tshut handler. Call it only if HAS(TSHUT) is set */
 static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 {
+	pr_emerg("%s: TSHUT temperature reached. Needs shut down...\n",
+		 __func__);
+
 	orderly_poweroff(true);
 
 	return IRQ_HANDLED;
-- 
1.7.7.1.488.ge8e1c

