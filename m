Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaKKMYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:24:39 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51126 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbaKKMYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:24:37 -0500
Date: Tue, 11 Nov 2014 12:24:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: "airlied@linux.ie" <airlied@linux.ie>,
        "Zubair.Kakakhel@imgtec.com" <Zubair.Kakakhel@imgtec.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "djkurtz@chromium.org" <djkurtz@chromium.org>,
        "ykk@rock-chips.com" <ykk@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 7/7] dt-bindings: add document for dw-hdmi
Message-ID: <20141111122418.GA24306@leverpostej>
References: <1415707952-11415-1-git-send-email-andy.yan@rock-chips.com>
 <1415707952-11415-8-git-send-email-andy.yan@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415707952-11415-8-git-send-email-andy.yan@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:12:32PM +0000, Andy Yan wrote:
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> ---
> 
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  .../devicetree/bindings/drm/bridge/dw-hdmi.txt     | 38 ++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
> 
> diff --git a/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
> new file mode 100644
> index 0000000..aa7ed17
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
> @@ -0,0 +1,38 @@
> +DesignWare HDMI bridge bindings
> +
> +Required properities:
> +- compatibel: platform specific such as "fsl,imx6q-hdmi","fsl,imx6dl-hdmi"
> +	      "rockchip,rk3288-dw-hdmi"

s/compatibel/compatible/

This should include the _precise_ strings you expect. Please format this
as a list, e.g.

- compatible: should contain one of:
  * "fsl,imx6q-hdmi"
  * "fsl,imx6dl-hdmi"
  * "rockchip,rk3288-dw-hdmi"

> +- reg: physical base address of the controller and length
> +- ddc-i2c-bus: the ddc i2c bus
> +- interrupts: The interrupt number to the cpu

Does the device only have one interrupt? Just describe what this
logically is, and don't mention the CPU. It'll be plumbed through an
interrupt controller anyhow.

> +
> +Optional properties
> +- reg-io-width: the width of the reg:1,4, default set to 1 if not present

I don't understand this description. Could you elaborate on this?

> +
> +Example:
> +	hdmi: hdmi@0120000 {
> +		compatible = "fsl,imx6q-hdmi";
> +		reg = <0x00120000 0x9000>;
> +		interrupts = <0 115 0x04>;
> +		gpr = <&gpr>;
> +		clocks = <&clks 123>, <&clks 124>;
> +		clock-names = "iahb", "isfr";

These three properties weren't mentioned in the binding.

> +		ddc-i2c-bus = <&i2c2>;
> +
> +		port@0 {
> +			reg = <0>;
> +
> +			hdmi_mux_0: endpoint {
> +				remote-endpoint = <&ipu1_di0_hdmi>;
> +			};
> +		};

Please mention the graphics bindings that require graph info.

THanks,
Mark.

> +
> +		port@1 {
> +			reg = <1>;
> +
> +			hdmi_mux_1: endpoint {
> +				remote-endpoint = <&ipu1_di1_hdmi>;
> +			};
> +		};
> +	};
> -- 
> 1.9.1
> 
> 
