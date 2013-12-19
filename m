Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LSQ0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:26:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:54435 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3LSQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:26:16 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/2] input: ti_am33x_tsc: make the documentation for the ti,wire-config parameter clear
Date: Thu, 19 Dec 2013 17:25:51 +0100
Message-Id: <1387470351-4696-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387470351-4696-1-git-send-email-bigeasy@linutronix.de>
References: <1387470351-4696-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The document says "first four bits" and means the upper nibble. Most
people would probably agree that the first four bits are bits 0…3 and
that is the lower nibble.
This patch updates the documentation so it is clear what is meant.

Acked-by: Kumar Gala <galak@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../devicetree/bindings/input/touchscreen/ti-tsc-adc.txt    | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
index 878549b..fa15500 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
@@ -17,13 +17,16 @@
 				remaining 4 can be used by the ADC.
 	ti,wire-config: Different boards could have a different order for
 			connecting wires on touchscreen. We need to provide an
-			8 bit number where in the 1st four bits represent the
-			analog lines and the next 4 bits represent positive/
-			negative terminal on that input line. Notations to
-			represent the input lines and terminals resoectively
-			is as follows:
+			8 bit number where the most significant nibble represent
+			the analog lines and the least significant nibble
+			represent positive/ negative terminal on that input
+			line. Notations to represent the input lines and
+			terminals resoectively is as follows:
 			AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
 			XP  = 0, XN = 1, YP = 2, YN = 3.
+
+			Example: ti,wire-config = <0x71>;
+			=> line AIN7, configuration XN
 - child "adc"
 	ti,adc-channels: List of analog inputs available for ADC.
 			 AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
-- 
1.8.5.1

