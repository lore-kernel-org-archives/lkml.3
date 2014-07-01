Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaGAFE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:04:58 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52659 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaGAFE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:04:56 -0400
MIME-Version: 1.0
In-Reply-To: <1404144233-17222-4-git-send-email-agross@codeaurora.org>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org> <1404144233-17222-4-git-send-email-agross@codeaurora.org>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 1 Jul 2014 00:04:35 -0500
Message-ID: <CAL_JsqJTO4htxHMVtMG6mGLmgRtQ7igE1OCX_jXM4xabN76ntg@mail.gmail.com>
Subject: Re: [Patch v7 3/3] usb: dwc3: qcom: Add device tree binding
To: Andy Gross <agross@codeaurora.org>
Cc: Felipe Balbi <balbi@ti.com>, jackp@codeaurora.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:03 AM, Andy Gross <agross@codeaurora.org> wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Please copy the right lists and maintainers.

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
>  .../devicetree/bindings/usb/qcom,dwc3.txt          |  104 ++++++++++++++++++++
>  1 file changed, 104 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/qcom,dwc3.txt
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
> +- compatible:  should contain "qcom,dwc3-hsphy";
> +- reg:                 offset and length of the register set in the memory map
> +- clocks:              A list of phandle + clock-specifier pairs for the
> +                               clocks listed in clock-names
> +- clock-names: Should contain the following:
> +  "utmi"               UTMI clock
> +- v1p8-supply: phandle to the regulator for the 1.8v supply to HSPHY.
> +- v3p3-supply: phandle to the regulator for the 3.3v supply to HSPHY.
> +- vbus-supply: phandle to the regulator for the vbus supply for host
> +               mode.
> +- vddcx-supply: phandle to the regulator for the vdd supply for HSPHY
> +                digital circuit operation.
> +
> +Optional clocks:
> +  "xo"                 External reference clock
> +
> +
> +QCOM DWC3 Superspeed USB PHY
> +=========================
> +Required properities:
> +- compatible:  should contain "qcom,dwc3-ssphy";
> +- reg:                 offset and length of the register set in the memory map
> +- clocks:              A list of phandle + clock-specifier pairs for the
> +                               clocks listed in clock-names
> +- clock-names: Should contain the following:
> +  "ref"                        Reference clock used in host mode.
> +- v1p8-supply: phandle to the regulator for the 1.8v supply to HSPHY.
> +- vddcx-supply: phandle to the regulator for the vdd supply for HSPHY
> +                digital circuit operation.
> +
> +Optional clocks:
> +  "xo"                 External reference clock
> +
> +QCOM DWC3 controller wrapper
> +===========================
> +Required properties:
> +- compatible:  should contain "qcom,dwc3"
> +- clocks:              A list of phandle + clock-specifier pairs for the
> +                               clocks listed in clock-names
> +- clock-names: Should contain the following:
> +  "core"               Master/Core clock, have to be >= 125 MHz for SS
> +                               operation and >= 60MHz for HS operation
> +
> +Optional clocks:
> +  "iface"              System bus AXI clock.  Not present on all platforms

Really?, some platforms have a clockless bus?

> +  "sleep"              Sleep clock, used when USB3 core goes into low
> +                               power mode (U3).
> +
> +Optional regulator:
> +- gdsc-supply: phandle to the regulator from globally distributed
> +                               switch controller

The name should reflect the name of the input, not the source.

> +
> +Required child node:
> +A child node must exist to represent the core DWC3 IP block. The name of
> +the node is not important. The content of the node is defined in dwc3.txt.
> +
> +Example device nodes:
> +
> +               hs_phy_0: phy@110f8800 {
> +                       compatible = "qcom,dwc3-hsphy";
> +                       reg = <0x110f8800 0x30>;
> +                       clocks = <&gcc USB30_0_UTMI_CLK>;
> +                       clock-names = "utmi";
> +
> +                       status = "disabled";
> +               };
> +
> +               ss_phy_0: phy@110f8830 {
> +                       compatible = "qcom,dwc3-ssphy";
> +                       reg = <0x110f8830 0x30>;
> +
> +                       clocks = <&gcc USB30_0_MASTER_CLK>;
> +                       clock-names = "ref";
> +
> +                       status = "disabled";
> +               };
> +
> +               usb3_0: usb30@0 {
> +                       compatible = "qcom,dwc3";
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +                       clocks = <&gcc USB30_0_MASTER_CLK>;
> +                       clock-names = "core";
> +
> +                       ranges;
> +
> +                       status = "disabled";
> +
> +                       dwc3@11000000 {
> +                               compatible = "snps,dwc3";

This sub-node is just wrong. Why can't you have a single node with '
"qcom,dwc3", "snps,dwc3" ' for the compatible property? All you are
adding here is clocks. Does the Synopsys block have no clocks?

I guess this is copied from other broken dwc3 bindings... That doesn't
mean you have to copy it.

Rob
