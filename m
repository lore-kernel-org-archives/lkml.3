Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591Ab3JPTZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:25:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3JPTZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:25:19 -0400
Subject: Re: [PATCHv5 2/4] ARM: msm: Add support for APQ8074 Dragonboard
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1381612484-760-1-git-send-email-rvaswani@codeaurora.org>
Date: Wed, 16 Oct 2013 14:25:15 -0500
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9460811C-9EA6-4536-9C8C-3E31FDD36F37@codeaurora.org>
References: <1381612484-760-1-git-send-email-rvaswani@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2013, at 4:14 PM, Rohit Vaswani wrote:

> This patch adds basic board support for APQ8074 Dragonboard
> which belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
> arch/arm/boot/dts/Makefile                     |  3 ++-
> arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  6 +++++
> arch/arm/boot/dts/qcom-msm8974.dtsi            | 35 ++++++++++++++++++++++++++
> arch/arm/mach-msm/Kconfig                      | 13 ++++++++++
> arch/arm/mach-msm/board-dt.c                   |  9 +++++++
> 5 files changed, 65 insertions(+), 1 deletion(-)
> create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
> create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 000cf76..e71a3ec 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -102,7 +102,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
> 	kirkwood-openblocks_a6.dtb
> dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
> dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
> -	msm8960-cdp.dtb
> +	msm8960-cdp.dtb \
> +	qcom-apq8074-dragonboard.dtb
> dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
> 	armada-370-mirabox.dtb \
> 	armada-370-netgear-rn102.dtb \
> diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
> new file mode 100644
> index 0000000..13ac3e2
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
> @@ -0,0 +1,6 @@
> +#include "qcom-msm8974.dtsi"
> +
> +/ {
> +	model = "Qualcomm APQ8074 Dragonboard";
> +	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
> +};
> diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
> new file mode 100644
> index 0000000..e0fd55a
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
> @@ -0,0 +1,35 @@
> +/dts-v1/;
> +
> +#include "skeleton.dtsi"
> +
> +/ {
> +	model = "Qualcomm MSM8974";
> +	compatible = "qcom,msm8974";
> +	interrupt-parent = <&intc>;
> +
> +	soc: soc { };

Was there an answer to Olof's question about:

For files that include this it's ok to use the &phandle syntax, but in this
base dtsi, please use proper structure. In other words, move the contents of
the soc node up above instead.

> +};
> +
> +&soc {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	ranges;
> +	compatible = "simple-bus";
> +
> +	intc: interrupt-controller@f9000000 {
> +		compatible = "qcom,msm-qgic2";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		reg = <0xf9000000 0x1000>,
> +		      <0xf9002000 0x1000>;
> +	};
> +
> +	timer {
> +		compatible = "arm,armv7-timer";
> +		interrupts = <1 2 0xf08>,
> +			     <1 3 0xf08>,
> +			     <1 4 0xf08>,
> +			     <1 1 0xf08>;
> +		clock-frequency = <19200000>;
> +	};
> +};

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

