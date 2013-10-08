Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3JHSRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:17:10 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:58146 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab3JHSRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:17:04 -0400
Date: Tue, 8 Oct 2013 20:20:27 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2] ARM: Dove: fix bad properties of the si5351 clkout2 used
 by Cubox audio
Message-ID: <20131008202027.6d9f0bd2@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.21; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As defined in the DT, clkout2 is not allowed to change the pll inside
si5351.

This patch extends the properties of clkout2 so that it works as the
external clock of the audio device in the Cubox.

Also, as the second si5351 clock is not used in the Cubox, its
definition is removed.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
v2:
- remove clkout1 which is not used in the Cubox (Sebastian Hesselbarth)
---
 arch/arm/boot/dts/dove-cubox.dts | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index bb38a24..3dd8844 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -99,18 +99,12 @@
 			silabs,pll-master;
 		};
 
-		clkout1 {
-			reg = <1>;
-			silabs,drive-strength = <8>;
-			silabs,multisynth-source = <1>;
-			silabs,clock-source = <0>;
-			silabs,pll-master;
-		};
-
 		clkout2 {
 			reg = <2>;
+			silabs,drive-strength = <8>;
 			silabs,multisynth-source = <1>;
 			silabs,clock-source = <0>;
+			silabs,pll-master;
 		};
 	};
 };


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
