Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3HUMSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:18:22 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19401 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3HUMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:18:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Aug 2013 05:18:20 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: add Palmas pincontrol to Dalmore device tree
Date: Wed, 21 Aug 2013 18:04:21 +0530
Message-ID: <1377088461-9499-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1377088461-9499-1-git-send-email-ldewangan@nvidia.com>
References: <1377088461-9499-1-git-send-email-ldewangan@nvidia.com>
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
 arch/arm/boot/dts/tegra114-dalmore.dts |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index 45056a2..44413dd 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -1009,6 +1009,19 @@
 				interrupt-parent = <&palmas>;
 				interrupts = <8 0>;
 			};
+
+			palmas_pinctrl {
+				compatible = "ti,tps65913-pinctrl";
+				pinctrl-names = "default";
+				pinctrl-0 = <&palmas_default>;
+
+				palmas_default: palams_pinctrl {
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

