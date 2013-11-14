Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3KNLH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:07:27 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:25375
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab3KNLHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:07:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <timur@tabi.org>, <shawn.guo@linaro.org>, <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <linux@arm.linux.org.uk>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>
Subject: [PATCH 1/2] ARM: dts: imx: specify the value of audmux pinctrl instead of 0x80000000
Date: Thu, 14 Nov 2013 19:07:09 +0800
Message-ID: <1384427230-979-2-git-send-email-b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1384427230-979-1-git-send-email-b42378@freescale.com>
References: <1384427230-979-1-git-send-email-b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must specify the value of audmux pinctrl if we want to use pinctrl_pm().
Thus change bypass value 0x80000000 to what we exactly need.

This patch also seperately unset PUE bit for TXD so that IOMUX won't pull
up/down the pin after turning into tristate. When we use SSI normal mode to
playback monaural audio via I2S signal, there'd be a pulled curve occur to
its signal at the second slot if setting PUE bit for TXD. And it will make
the second channel to play a constant noise. So by keeping the signal level
in the second slot, we can get a constant high level signal (-1) or a low
level one (0).

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 6e096ca..6b76e55 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -601,27 +601,27 @@
 				audmux {
 					pinctrl_audmux_1: audmux-1 {
 						fsl,pins = <
-							MX6QDL_PAD_SD2_DAT0__AUD4_RXD  0x80000000
-							MX6QDL_PAD_SD2_DAT3__AUD4_TXC  0x80000000
-							MX6QDL_PAD_SD2_DAT2__AUD4_TXD  0x80000000
-							MX6QDL_PAD_SD2_DAT1__AUD4_TXFS 0x80000000
+							MX6QDL_PAD_SD2_DAT0__AUD4_RXD  0x130b0
+							MX6QDL_PAD_SD2_DAT3__AUD4_TXC  0x130b0
+							MX6QDL_PAD_SD2_DAT2__AUD4_TXD  0x110b0
+							MX6QDL_PAD_SD2_DAT1__AUD4_TXFS 0x130b0
 						>;
 					};
 
 					pinctrl_audmux_2: audmux-2 {
 						fsl,pins = <
-							MX6QDL_PAD_CSI0_DAT7__AUD3_RXD  0x80000000
-							MX6QDL_PAD_CSI0_DAT4__AUD3_TXC  0x80000000
-							MX6QDL_PAD_CSI0_DAT5__AUD3_TXD  0x80000000
-							MX6QDL_PAD_CSI0_DAT6__AUD3_TXFS 0x80000000
+							MX6QDL_PAD_CSI0_DAT7__AUD3_RXD  0x130b0
+							MX6QDL_PAD_CSI0_DAT4__AUD3_TXC  0x130b0
+							MX6QDL_PAD_CSI0_DAT5__AUD3_TXD  0x110b0
+							MX6QDL_PAD_CSI0_DAT6__AUD3_TXFS 0x130b0
 						>;
 					};
 
 					pinctrl_audmux_3: audmux-3 {
 						fsl,pins = <
-							MX6QDL_PAD_DISP0_DAT16__AUD5_TXC  0x80000000
-							MX6QDL_PAD_DISP0_DAT18__AUD5_TXFS 0x80000000
-							MX6QDL_PAD_DISP0_DAT19__AUD5_RXD  0x80000000
+							MX6QDL_PAD_DISP0_DAT16__AUD5_TXC  0x130b0
+							MX6QDL_PAD_DISP0_DAT18__AUD5_TXFS 0x130b0
+							MX6QDL_PAD_DISP0_DAT19__AUD5_RXD  0x130b0
 						>;
 					};
 				};
-- 
1.8.4


