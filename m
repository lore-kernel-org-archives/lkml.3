Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab3HMUFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:05:17 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62711 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab3HMUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:05:12 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: [PATCH 2/4] input: ti_am335x_tsc: Increase sequencer delay time
Date: Tue, 13 Aug 2013 21:05:01 +0100
Message-Id: <1376424303-22740-3-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before checking PEN UP event, IRQ delays for this amount
of time to let FSM stabilize. Previously, with only the
TSC driver in IRQ mode, this delay was sufficient.

The delay is increased slightly to accomodate if the ADC
is also being used simultaneously in continuous mode.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index e165fcb..766bc7e 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -31,7 +31,7 @@
 #include <linux/mfd/ti_am335x_tscadc.h>
 
 #define ADCFSM_STEPID		0x10
-#define SEQ_SETTLE		275
+#define SEQ_SETTLE		350
 #define MAX_12BIT		((1 << 12) - 1)
 
 static const int config_pins[] = {
-- 
1.7.9.5

