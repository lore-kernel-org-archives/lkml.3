Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbbAGDAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:00:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbbAGBwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.18 37/84] ARM: mvebu: remove conflicting muxing on Armada 370 DB
Date: Tue,  6 Jan 2015 17:49:40 -0800
Message-Id: <20150107014030.229521927@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit b4607572ef86b288a856b9df410ea593c5371dec upstream.

Back when audio was enabled, the muxing of some MPP pins was causing
problems. However, since commit fea038ed55ae ("ARM: mvebu: Add proper
pin muxing on the Armada 370 DB board"), those problematic MPP pins
have been assigned a proper muxing for the Ethernet interfaces. This
proper muxing is now conflicting with the hog pins muxing that had
been added as part of 249f3822509b ("ARM: mvebu: add audio support to
Armada 370 DB").

Therefore, this commit simply removes the hog pins muxing, which
solves a warning a boot time due to the conflicting muxing
requirements.

Fixes: fea038ed55ae ("ARM: mvebu: Add proper pin muxing on the Armada 370 DB board")
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lkml.kernel.org/r/1414512524-24466-5-git-send-email-thomas.petazzoni@free-electrons.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-370-db.dts |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -102,30 +102,6 @@
 				broken-cd;
 			};
 
-			pinctrl {
-				/*
-				 * These pins might be muxed as I2S by
-				 * the bootloader, but it conflicts
-				 * with the real I2S pins that are
-				 * muxed using i2s_pins. We must mux
-				 * those pins to a function other than
-				 * I2S.
-				 */
-				pinctrl-0 = <&hog_pins1 &hog_pins2>;
-				pinctrl-names = "default";
-
-				hog_pins1: hog-pins1 {
-					marvell,pins = "mpp6",  "mpp8", "mpp10",
-						       "mpp12", "mpp13";
-					marvell,function = "gpio";
-				};
-
-				hog_pins2: hog-pins2 {
-					marvell,pins = "mpp5", "mpp7", "mpp9";
-					marvell,function = "gpo";
-				};
-			};
-
 			usb@50000 {
 				status = "okay";
 			};


