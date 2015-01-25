Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbbAYSY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:24:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbbAYSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.18 170/183] bus: omap_l3_noc: Correct returning IRQ_HANDLED unconditionally in the irq handler
Date: Sun, 25 Jan 2015 10:08:12 -0800
Message-Id: <20150125180817.557633457@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keerthy <j-keerthy@ti.com>

commit c4cf0935a2d8fe6d186bf4253ea3c4b4a8a8a710 upstream.

Correct returning IRQ_HANDLED unconditionally in the irq handler.
Return IRQ_NONE for some interrupt which we do not expect to be
handled in this handler. This prevents kernel stalling with back
to back spurious interrupts.

Fixes: 2722e56de6 ("OMAP4: l3: Introduce l3-interconnect error handling driver")
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/omap_l3_noc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -222,10 +222,14 @@ static irqreturn_t l3_interrupt_handler(
 			}
 
 			/* Error found so break the for loop */
-			break;
+			return IRQ_HANDLED;
 		}
 	}
-	return IRQ_HANDLED;
+
+	dev_err(l3->dev, "L3 %s IRQ not handled!!\n",
+		inttype ? "debug" : "application");
+
+	return IRQ_NONE;
 }
 
 static const struct of_device_id l3_noc_match[] = {


