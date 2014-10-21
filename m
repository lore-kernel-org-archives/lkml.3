Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbaJUObW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:31:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50678 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798AbaJUObT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:31:19 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/3] ARM: dts: dra72-evm: Add power button node
Date: Tue, 21 Oct 2014 09:30:47 -0500
Message-ID: <1413901848-32268-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413901848-32268-1-git-send-email-nm@ti.com>
References: <1413901848-32268-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Commit adff5962fdd2 ("Input: introduce palmas-pwrbutton"), we can
now support tps power button as a event source - This is SW7 (PB/WAKE)
on the J6-evm.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra72-evm.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
index 671e473..1242a17 100644
--- a/arch/arm/boot/dts/dra72-evm.dts
+++ b/arch/arm/boot/dts/dra72-evm.dts
@@ -145,6 +145,14 @@
 				};
 			};
 		};
+
+		tps65917_power_button {
+			compatible = "ti,palmas-pwrbutton";
+			interrupt-parent = <&tps65917>;
+			interrupts = <1 IRQ_TYPE_NONE>;
+			wakeup-source;
+			ti,palmas-long-press-seconds = <6>;
+		};
 	};
 };
 
-- 
1.7.9.5

