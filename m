Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaETI3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:29:06 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54008 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaETI3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:29:04 -0400
Date: Tue, 20 May 2014 09:28:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [STLinux Kernel] [PATCH 3/4] ARM: DT: STi: Add DT node for
 MiPHY365x
Message-ID: <20140520082858.GF20874@lee--X1>
References: <1398756095-32542-1-git-send-email-lee.jones@linaro.org>
 <1398756095-32542-4-git-send-email-lee.jones@linaro.org>
 <537A265E.8080407@st.com>
 <20140519155106.GR4978@lee--X1>
 <537B01E9.8020507@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537B01E9.8020507@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> >>>devices. It has 2 ports which it can use for either; both SATA, both
> >>>PCIe or one of each in any configuration.
> >>>
> >>>Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >>>Acked-by: Mark Rutland <mark.rutland@arm.com>
> >>>Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> >>>Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>>---
> >>>  arch/arm/boot/dts/stih416-b2020-revE.dts | 22 ++++++++++++++++++++++
> >>>  arch/arm/boot/dts/stih416-b2020.dts      |  6 ++++++
> >>>  arch/arm/boot/dts/stih416.dtsi           | 14 ++++++++++++++
> >>>  3 files changed, 42 insertions(+)
> >>>  create mode 100644 arch/arm/boot/dts/stih416-b2020-revE.dts
> >>>
> >>>diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
> >>>new file mode 100644
> >>>index 0000000..23fdaf7
> >>>--- /dev/null
> >>>+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
> >>>@@ -0,0 +1,22 @@
> >>>+/*
> >>>+ * Copyright (C) 2014 STMicroelectronics Limited.
> >>>+ * Author: Lee Jones <lee.jones@linaro.org>
> >>>+ *
> >>>+ * This program is free software; you can redistribute it and/or modify
> >>>+ * it under the terms of the GNU General Public License version 2 as
> >>>+ * publishhed by the Free Software Foundation.
> >>>+ */
> >>>+/dts-v1/;
> >>>+#include "stih416.dtsi"
> >>>+#include "stih41x-b2020.dtsi"
> >>>+/ {
> >>>+        model = "STiH416 B2020 REV-E";
> >>>+	compatible = "st,stih416-b2020", "st,stih416";
> >>>+
> >>>+	soc {
> >>>+		miphy365x_phy: miphy365x@fe382000 {
> >>>+			st,pcie-tx-pol-inv;
> >>>+			st,sata-gen = <3>;
> >>>+		};
> >>>+	};
> >>>+};
> >>Shouldn't this new board being added in a separate patch?
> >
> >I certainly can do that, but I don't think that it's necessary?
> 
> I think it is, as you introduce a new board.

Introducing an empty dts file just so you can say "this is a new
board" seems odd to me, but I'll go with whatever you feel it right.

> Moreover, the miphy description being the same as in
> stih416-b2020.dts, so I don't understand why you introduce this
> board for this feature.

It's historical.  There are other differences between rev-E and the
other reversions, such as; gpio-leds (red, green) and the reset GPIO
for ethernet.  As these are dts files (rather than dtsi) files, you
can only use one at a time.

> >>>diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
> >>>index 276f28d..172f222 100644
> >>>--- a/arch/arm/boot/dts/stih416-b2020.dts
> >>>+++ b/arch/arm/boot/dts/stih416-b2020.dts
> >>>@@ -13,4 +13,10 @@
> >>>  	model = "STiH416 B2020";
> >>>  	compatible = "st,stih416", "st,stih416-b2020";
> >>>
> >>>+	soc {
> >>>+		miphy365x_phy: miphy365x@fe382000 {
> >>>+			st,pcie-tx-pol-inv;
> >>>+			st,sata-gen = <3>;
> >>>+		};
> >>>+	};
> >>>  };
> >>...
> >

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
