Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3HTIzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:55:14 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:43846
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab3HTIzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:55:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <kernel@pengutronix.de>
CC: <gregkh@linuxfoundation.org>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: [PATCH 0/3] refactor some ldb related clocks
Date: Tue, 20 Aug 2013 16:38:49 +0800
Message-ID: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ldb_di[0/1]_ipu_div clock dividers in the CSCMR2 register
of i.MX53, i.MX6Q and i.MX6DL SoCs can be configured to a 1/3.5
drivider or a 1/7 divider. The common clock framework cannot
deal with the two dividers directly even with the divider table
which only supports integral dividers. So, the idea is to take
the 1/3.5 and 1/7 dividers as separate fixed factor dividers and
introduce a new multiplexer clock to be derived from the them.
Then, the ldb display clock trees can be setup correctly.
This series contains the necessary clock driver changes, dts code
changes and imx-drm/ldb driver changes to fullfill the task.

Liu Ying (3):
  ARM: imx6q: refactor some ldb related clocks
  ARM: dts: imx6q/imx6dl: add necessary clocks for ldb node
  staging: drm/imx: ldb: correct the ldb di clock trees

 .../devicetree/bindings/clock/imx6q-clock.txt      |    6 ++--
 arch/arm/boot/dts/imx6dl.dtsi                      |    8 +++--
 arch/arm/boot/dts/imx6q.dtsi                       |    8 +++--
 arch/arm/mach-imx/clk-imx6q.c                      |   25 +++++++------
 drivers/staging/imx-drm/imx-ldb.c                  |   38 +++++++++++++++-----
 5 files changed, 61 insertions(+), 24 deletions(-)

-- 
1.7.9.5


