Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab3APNG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:06:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11447 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3APNG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:06:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 16 Jan 2013 05:06:48 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] ARM: tegra: DTS: cardhu: register UARTC
Date: Wed, 16 Jan 2013 18:36:12 +0530
Message-ID: <1358341572-8154-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1358341572-8154-1-git-send-email-ldewangan@nvidia.com>
References: <1358341572-8154-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UARTC is used for the interfacing with bluetooth device.
Register this UART channel as high speed serial channel
so that it can use the APB DMA for data transfer.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The driver file got applied in Greg KH's tty tree.
Tested in linux-next 20121229 with some more changes as
linux-next-20130116 is crashing in pincontrol.

 arch/arm/boot/dts/tegra30-cardhu.dtsi |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index bdb2a66..ff6b68f 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -106,6 +106,15 @@
 				nvidia,slew-rate-rising = <1>;
 				nvidia,slew-rate-falling = <1>;
 			};
+			uart3_txd_pw6 {
+				nvidia,pins =	"uart3_txd_pw6",
+						"uart3_cts_n_pa1",
+						"uart3_rts_n_pc0",
+						"uart3_rxd_pw7";
+				nvidia,function = "uartc";
+				nvidia,pull = <0>;
+				nvidia,tristate = <0>;
+			};
 		};
 	};
 
@@ -114,6 +123,12 @@
 		clock-frequency = <408000000>;
 	};
 
+	serial@70006200 {
+		compatible = "nvidia,tegra30-hsuart";
+		status = "okay";
+		clock-frequency = <408000000>;
+	};
+
 	i2c@7000c000 {
 		status = "okay";
 		clock-frequency = <100000>;
-- 
1.7.1.1

