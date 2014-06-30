Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaF3Rhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:37:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34920 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaF3Rhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:37:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [Patch v7 3/3] usb: dwc3: qcom: Add device tree binding
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1404144233-17222-4-git-send-email-agross@codeaurora.org>
Date: Mon, 30 Jun 2014 12:37:33 -0500
Cc: Felipe Balbi <balbi@ti.com>, linux-usb <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        linux-arm-kernel@lists.infradead.org, jackp@codeaurora.org,
        linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <28407117-A323-4664-B10C-17EBE857FB6A@codeaurora.org>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org> <1404144233-17222-4-git-send-email-agross@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 30, 2014, at 11:03 AM, Andy Gross <agross@codeaurora.org> wrote:

> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> QCOM USB3.0 core wrapper consist of USB3.0 IP from Synopsys
> (SNPS) and HS, SS PHY's control and configuration registers.
> 
> It could operate in device mode (SS, HS, FS) and host
> mode (SS, HS, FS, LS).
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
> .../devicetree/bindings/usb/qcom,dwc3.txt          |  104 ++++++++++++++++++++
> 1 file changed, 104 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/usb/qcom,dwc3.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/qcom,dwc3.txt b/Documentation/devicetree/bindings/usb/qcom,dwc3.txt
> new file mode 100644
> index 0000000..105b6b7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/qcom,dwc3.txt
> @@ -0,0 +1,104 @@
> +Qualcomm SuperSpeed DWC3 USB SoC controller
> +
> +
> +QCOM DWC3 Highspeed USB PHY
> +========================
> +Required properities:
> +- compatible:	should contain "qcom,dwc3-hsphy";
> +- reg:			offset and length of the register set in the memory map
> +- clocks:		A list of phandle + clock-specifier pairs for the
> +				clocks listed in clock-names
> +- clock-names:	Should contain the following:
> +  "utmi"		UTMI clock
> +- v1p8-supply:	phandle to the regulator for the 1.8v supply to HSPHY.
> +- v3p3-supply:	phandle to the regulator for the 3.3v supply to HSPHY.
> +- vbus-supply:	phandle to the regulator for the vbus supply for host
> +		mode.
> +- vddcx-supply: phandle to the regulator for the vdd supply for HSPHY
> +                digital circuit operation.
> +
> +Optional clocks:
> +  "xo"			External reference clock
> +
> +
> +QCOM DWC3 Superspeed USB PHY
> +=========================
> +Required properities:
> +- compatible:	should contain "qcom,dwc3-ssphy";
> +- reg:			offset and length of the register set in the memory map
> +- clocks:		A list of phandle + clock-specifier pairs for the
> +				clocks listed in clock-names
> +- clock-names:	Should contain the following:
> +  "ref"			Reference clock used in host mode.
> +- v1p8-supply:	phandle to the regulator for the 1.8v supply to HSPHY.
> +- vddcx-supply: phandle to the regulator for the vdd supply for HSPHY
> +                digital circuit operation.
> +
> +Optional clocks:
> +  "xo"			External reference clock
> +
> +QCOM DWC3 controller wrapper
> +===========================
> +Required properties:
> +- compatible:	should contain "qcom,dwc3"
> +- clocks:		A list of phandle + clock-specifier pairs for the
> +				clocks listed in clock-names
> +- clock-names:	Should contain the following:
> +  "core"		Master/Core clock, have to be >= 125 MHz for SS
> +				operation and >= 60MHz for HS operation
> +
> +Optional clocks:
> +  "iface"		System bus AXI clock.  Not present on all platforms
> +  "sleep"		Sleep clock, used when USB3 core goes into low
> +				power mode (U3).

We should encode the an optional port number here in the cases that we have multiple controllers and need to know about it so we can set TCSR correctly.

> +
> +Optional regulator:
> +- gdsc-supply:	phandle to the regulator from globally distributed
> +				switch controller
> +
> +Required child node:
> +A child node must exist to represent the core DWC3 IP block. The name of
> +the node is not important. The content of the node is defined in dwc3.txt.
> +
> +Example device nodes:
> +
> +		hs_phy_0: phy@110f8800 {
> +			compatible = "qcom,dwc3-hsphy";
> +			reg = <0x110f8800 0x30>;
> +			clocks = <&gcc USB30_0_UTMI_CLK>;
> +			clock-names = "utmi";
> +
> +			status = "disabled";
> +		};
> +
> +		ss_phy_0: phy@110f8830 {
> +			compatible = "qcom,dwc3-ssphy";
> +			reg = <0x110f8830 0x30>;
> +
> +			clocks = <&gcc USB30_0_MASTER_CLK>;
> +			clock-names = "ref";
> +
> +			status = "disabled";
> +		};
> +
> +		usb3_0: usb30@0 {
> +			compatible = "qcom,dwc3";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			clocks = <&gcc USB30_0_MASTER_CLK>;
> +			clock-names = "core";
> +
> +			ranges;
> +
> +			status = "disabled";
> +
> +			dwc3@11000000 {
> +				compatible = "snps,dwc3";
> +				reg = <0x11000000 0xcd00>;
> +				interrupts = <0 110 0x4>;
> +				usb-phy = <&hs_phy_0>, <&ss_phy_0>;
> +				phy-names = "usb2-phy", "usb3-phy";
> +				tx-fifo-resize;
> +				dr_mode = "host";
> +			};
> +		};
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

