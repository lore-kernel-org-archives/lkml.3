Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaBSIrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:47:18 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:43567
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbaBSIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:47:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z551bizb922lzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux-arm-kernel@lists.infradead.org>, <shawn.guo@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 2/4] ARM: dts: vf610-twr: Enable SAI ALSA SoC DAI device
Date: Wed, 19 Feb 2014 15:42:29 +0800
Message-ID: <1392795751-13351-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392795751-13351-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392795751-13351-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds and enables the SAI device.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/boot/dts/vf610-twr.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/vf610-twr.dts b/arch/arm/boot/dts/vf610-twr.dts
index e3a3805..bcee3bb 100644
--- a/arch/arm/boot/dts/vf610-twr.dts
+++ b/arch/arm/boot/dts/vf610-twr.dts
@@ -121,6 +121,18 @@
 			>;
 		};
 
+		pinctrl_sai2: sai2grp {
+		      fsl,pins = <
+				VF610_PAD_PTA16__SAI2_TX_BCLK		0x02ed
+				VF610_PAD_PTA18__SAI2_TX_DATA		0x02ee
+				VF610_PAD_PTA19__SAI2_TX_SYNC		0x02ed
+				VF610_PAD_PTA21__SAI2_RX_BCLK		0x02ed
+				VF610_PAD_PTA22__SAI2_RX_DATA		0x02ed
+				VF610_PAD_PTA23__SAI2_RX_SYNC		0x02ed
+				VF610_PAD_PTB18__EXT_AUDIO_MCLK		0x02ed
+			>;
+		};
+
 		pinctrl_uart1: uart1grp {
 			fsl,pins = <
 				VF610_PAD_PTB4__UART1_TX		0x21a2
@@ -130,6 +142,12 @@
 	};
 };
 
+&sai2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_sai2>;
+	status = "okay";
+};
+
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
-- 
1.8.4


