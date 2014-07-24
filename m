Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbaGXXBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:01:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934669AbaGXXBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:22 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 10/11] ARM: dts: zynq: Add SPDIF for Parallella
Date: Fri, 25 Jul 2014 01:00:19 +0200
Message-Id: <1406242820-20140-11-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v2: New
 
 arch/arm/boot/dts/zynq-parallella.dts | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
index 8beaacc..65fbd8b 100644
--- a/arch/arm/boot/dts/zynq-parallella.dts
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -56,6 +56,21 @@
 				xlnx,genlock-mode = <0>;
 			};
 		};
+
+		audio_clock: audio-clock {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <12288000>;
+		};
+
+		axi-spdif-tx@0x75c00000 {
+			compatible = "adi,axi-spdif-tx-1.00.a";
+			reg = <0x75c00000 0x1000>;
+			clocks = <&clkc 15>, <&audio_clock>;
+			clock-names = "axi", "ref";
+			dmas = <&dmac_s 0>;
+			dma-names = "tx";
+		};
 	};
 };
 
-- 
1.9.3

