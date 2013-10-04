Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3JDKRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:17:55 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:47272 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3JDKRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:17:53 -0400
Date: Fri, 4 Oct 2013 12:21:05 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH] ARM: Dove: fix bad properties of the si5351 clkout2 used by
 Cubox audio
Message-ID: <20131004122105.60f605cd@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As defined in the DT, clkout2 is not allowed to change the pll inside
si5351.

This patch inverts the properties of the clkout{1,2} so that clkout2
may be defined as the external clock of the audio device in the Cubox.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 arch/arm/boot/dts/dove-cubox.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index 022646e..5d1ece1 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -101,16 +101,16 @@
 
 		clkout1 {
 			reg = <1>;
-			silabs,drive-strength = <8>;
 			silabs,multisynth-source = <1>;
 			silabs,clock-source = <0>;
-			silabs,pll-master;
 		};
 
 		clkout2 {
 			reg = <2>;
+			silabs,drive-strength = <8>;
 			silabs,multisynth-source = <1>;
 			silabs,clock-source = <0>;
+			silabs,pll-master;
 		};
 	};
 };

