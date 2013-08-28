Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3H1Jeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:34:36 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:55616 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3H1Jee convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:34:34 -0400
Date: Wed, 28 Aug 2013 11:35:21 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Message-ID: <20130828113521.35c53365@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch activates the audio device of the Cubox and sets the i2s
and S/PDIF pins.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 arch/arm/boot/dts/dove-cubox.dts                  | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index 4af59b6..003d95b 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -132,3 +132,16 @@
 		reg = <0>;
 	};
 };
+
+&pinctrl {
+	pmx_audio1_i2s1_spdifo: pmx-audio1-i2s1-spdifo {
+		marvell,pins = "mpp_audio1";
+		marvell,function = "i2s1/spdifo";
+	};
+};
+
+&i2s1 {
+	status = "okay";
+	pinctrl-0 = <&pmx_audio1_i2s1_spdifo>;
+	pinctrl-names = "default";
+};


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
