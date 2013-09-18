Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3IRMqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:46:22 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15849 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3IRMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:46:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 05:46:19 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <rob.herring@calxeda.com>, <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/2] ARM: tegra: add palmas pincontrol to Dalmore device tree
Date: Wed, 18 Sep 2013 18:37:22 +0530
Message-ID: <1379509642-19227-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1379509642-19227-1-git-send-email-ldewangan@nvidia.com>
References: <1379509642-19227-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Palmas pincontrol to Dalmore device tree and make following
configuration as default:
- Disable DVFS1 and DVFS2.
- Set GPIO6 to gpio mode.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
changes from V1:
- Renames the node name to pinmux as suggested on patch V1.
- Not sure that this will create the issue with other node having same
  name as pinmux in top of the dts file.

 arch/arm/boot/dts/tegra114-dalmore.dts |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 6023028..dc5cdd7 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -1011,6 +1011,19 @@
 				interrupt-parent = <&palmas>;
 				interrupts = <8 0>;
 			};
+
+			pinmux {
+				compatible = "ti,tps65913-pinctrl";
+				pinctrl-names = "default";
+				pinctrl-0 = <&palmas_default>;
+
+				palmas_default: pinmux {
+					pin_gpio6 {
+						pins = "gpio6";
+						function = "gpio";
+					};
+				};
+			};
 		};
 	};
 
-- 
1.7.1.1

