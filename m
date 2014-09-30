Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaI3USQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:18:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40582 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaI3USM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:18:12 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        dmitry.torokhov@gmail.com
Cc: hns@goldelico.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/3] Documentation: dt: input: tsc2007: Document new parameters
Date: Tue, 30 Sep 2014 22:17:33 +0200
Message-Id: <1412108254-19234-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412108254-19234-1-git-send-email-marek@goldelico.com>
References: <1412108254-19234-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 .../devicetree/bindings/input/touchscreen/tsc2007.txt   | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/touchscreen/tsc2007.txt b/Documentation/devicetree/bindings/input/touchscreen/tsc2007.txt
index ec365e1..46b086c 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/tsc2007.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/tsc2007.txt
@@ -13,14 +13,25 @@ Optional properties:
   (see interrupt binding[0]).
 - interrupts: (gpio) interrupt to which the chip is connected
   (see interrupt binding[0]).
-- ti,max-rt: maximum pressure.
+- ti,swap-xy: if present, swap x and y values. Rotation left/right is
+  achieved by combination with flipping of x or y.
+- ti,min-x: minimum x (default 0). Use this for a coarse calibration of the
+  touch if there is no user space option (e.g. Android, X11).
+- ti,max-x: maximum x (default 4095). If max-x is smaller than min-x the
+  axis is swapped.
+- ti,min-y: minimum y (default 0).
+- ti,max-y: maximum y (default 4095).
+- ti,min-rt: minimum pressure (default 0).
+- ti,max-rt: maximum pressure (default 4095). Depending on your needs, you
+  can also invert the pressure value since the raw rt value  reports the
+  resistance and not the "pressure" (i.e. becomes lower for higher pressure).
 - ti,fuzzx: specifies the absolute input fuzz x value.
   If set, it will permit noise in the data up to +- the value given to the fuzz
-  parameter, that is used to filter noise from the event stream.
+  parameter, that is used to filter noise from the event stream (default 0).
 - ti,fuzzy: specifies the absolute input fuzz y value.
 - ti,fuzzz: specifies the absolute input fuzz z value.
 - ti,poll-period: how much time to wait (in milliseconds) before reading again the
-  values from the tsc2007.
+  values from the tsc2007 (default 1).
 
 [0]: Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
 [1]: Documentation/devicetree/bindings/gpio/gpio.txt
-- 
1.9.3

