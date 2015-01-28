Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbbA1UOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:14:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54228 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbbA1UOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:08 -0500
Date: Wed, 28 Jan 2015 10:35:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: marcel@holtmann.org
Subject: [PATCH] Devicetree binding for omap3-serial & bcm2048 combination
Message-ID: <20150128093501.GA17338@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nokia N900 contains bluetooth module connected on serial
port. Unfortunately, serial and bluetooth are rather closely coupled,
so standard serial driver can not be used, and we really don't want
/dev/ttyS1 to be published for internal port of bluetooth
stack... Hence solution below.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/devicetree/bindings/serial/omap_serial.txt b/Documentation/devicetree/bindings/serial/omap_serial.txt
index 342eedd..e9fde42 100644
--- a/Documentation/devicetree/bindings/serial/omap_serial.txt
+++ b/Documentation/devicetree/bindings/serial/omap_serial.txt
@@ -4,7 +4,14 @@ Required properties:
 - compatible : should be "ti,omap2-uart" for OMAP2 controllers
 - compatible : should be "ti,omap3-uart" for OMAP3 controllers
 - compatible : should be "ti,omap4-uart" for OMAP4 controllers
+- compatible : should be "ti+brcm,omap3-uart,bcm2048" for bcm2048
+	       bluetooth connected to OMAP3 serial
 - ti,hwmods : Must be "uart<n>", n being the instance number (1-based)
 
 Optional properties:
 - clock-frequency : frequency of the clock input to the UART
+
+Required properties for ti+brcm,omap3-uart,bcm2048:
+- reset-gpios : gpio for reset pin
+- host-wakeup-gpios : gpio for host wakeup
+- bluetooth-wakeup-gpios : gpio for bluetooth wakeup

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
