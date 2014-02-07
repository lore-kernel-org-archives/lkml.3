Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaBGLCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:02:44 -0500
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:60248 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbaBGLCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:02:41 -0500
From: <srinivas.kandagatla@st.com>
To: <netdev@vger.kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>, <davem@davemloft.net>
Subject: [PATCH v2 0/3] net: stmmac: Add STi GMAC ethernet
Date: Fri, 7 Feb 2014 10:54:15 +0000
Message-ID: <1391770455-24291-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391428787-27143-1-git-send-email-srinivas.kandagatla@st.com>
References: <1391428787-27143-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Hi All,

This patch series adds Ethernet support to STi series SOCs STiH415 and STiH416.
STi SOC series integrates dwmac IP from synopsis, however there is a hardware
glue on top of this standard IP, this glue needs to configured before the
actual dwmac can be used.  Also the glue logic needs re-configuring when the
link speed changes, This is because the clk source can change as the link
speed changes.

This patch just adds STi specific callbacks into of_data for configuring the
glue layer.

I have rebased my original patches (http://lkml.org/lkml/2013/11/12/243)
to latest stmmac which updates callbacks to suit glue drivers like this.

These patches are tested on b2000 and B2020 with STiH415 and STiH416.

Changes since v1:
	- fixed multi-line function call format as suggested by David Miller.

Dave, Can I request you to take the first patch via net tree for v3.15, I can
request Arnd or Olof to take the DT patches via the arm-soc tree for v3.15.

Thanks,
srini

Srinivas Kandagatla (3):
  net: stmmac:sti: Add STi SOC glue driver.
  ARM: STi: Add STiH415 ethernet support.
  ARM: STi: Add STiH416 ethernet support.

 .../devicetree/bindings/net/sti-dwmac.txt          |   58 ++++
 arch/arm/boot/dts/stih415-clock.dtsi               |   14 +
 arch/arm/boot/dts/stih415-pinctrl.dtsi             |  121 +++++++
 arch/arm/boot/dts/stih415.dtsi                     |   48 +++
 arch/arm/boot/dts/stih416-clock.dtsi               |   14 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |  109 +++++++
 arch/arm/boot/dts/stih416.dtsi                     |   44 +++
 arch/arm/boot/dts/stih41x-b2000.dtsi               |   22 ++
 arch/arm/boot/dts/stih41x-b2020.dtsi               |   26 ++
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   11 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c    |  331 ++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    3 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    5 +
 14 files changed, 807 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sti-dwmac.txt
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c

-- 
1.7.9.5

