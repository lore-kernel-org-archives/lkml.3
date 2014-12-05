Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaLENzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:55:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53438 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaLENzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:55:43 -0500
Message-ID: <1417787693.3227.9.camel@pengutronix.de>
Subject: Re: [PATCH v18 06/12] dt-bindings: add document for dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk, Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com
Date: Fri, 05 Dec 2014 14:54:53 +0100
In-Reply-To: <1417760834-17141-1-git-send-email-andy.yan@rock-chips.com>
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com>
	 <1417760834-17141-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 05.12.2014, 14:27 +0800 schrieb Andy Yan:
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

This binding is mostly a copy of the existing
Documentation/devicetree/bindings/drm/imx/hdmi.txt, but there is a new
reg-io-width property to configure the register access bus width and we
have added new compatibles "rockchip,rk3288-dw-hdmi" and the common
"snps,dw-hdmi-tx". Could we get an Ack for this and patch 11 by the
device tree maintainers?

regards
Philipp

> ---
> 
> Changes in v18:
> - add port bindings
> - correct some spelling mistakes in dw_hdmi bindings doc
> 
> Changes in v17: None
> Changes in v16:
> - describe ddc-i2c-bus as optional
> - add common clocks bindings
> 
> Changes in v15: None
> Changes in v14: None
> Changes in v13: None
> Changes in v12: None
> Changes in v11: None
> Changes in v10: None
> Changes in v9: None
> Changes in v8:
> - correct some spelling mistake
> - modify ddc-i2c-bus and interrupt description
> 
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> 
>  .../devicetree/bindings/drm/bridge/dw_hdmi.txt     | 50 ++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
> 
> diff --git a/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
> new file mode 100644
> index 0000000..a905c14
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
> @@ -0,0 +1,50 @@
> +DesignWare HDMI bridge bindings
> +
> +Required properties:
> +- compatible: platform specific such as:
> +   * "snps,dw-hdmi-tx"
> +   * "fsl,imx6q-hdmi"
> +   * "fsl,imx6dl-hdmi"
> +   * "rockchip,rk3288-dw-hdmi"
> +- reg: Physical base address and length of the controller's registers.
> +- interrupts: The HDMI interrupt number
> +- clocks, clock-names : must have the phandles to the HDMI iahb and isfr clocks,
> +  as described in Documentation/devicetree/bindings/clock/clock-bindings.txt,
> +  the clocks are soc specific, the clock-names should be "iahb", "isfr"
> +-port@[X]: SoC specific port nodes with endpoint definitions as defined
> +   in Documentation/devicetree/bindings/media/video-interfaces.txt,
> +   please refer to the SoC specific binding document:
> +    * Documentation/devicetree/bindings/drm/imx/hdmi.txt
> +    * Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt
> +
> +Optional properties
> +- reg-io-width: the width of the reg:1,4, default set to 1 if not present
> +- ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
> +- clocks, clock-names: phandle to the HDMI CEC clock, name should be "cec"
> +
> +Example:
> +	hdmi: hdmi@0120000 {
> +		compatible = "fsl,imx6q-hdmi";
> +		reg = <0x00120000 0x9000>;
> +		interrupts = <0 115 0x04>;
> +		gpr = <&gpr>;
> +		clocks = <&clks 123>, <&clks 124>;
> +		clock-names = "iahb", "isfr";
> +		ddc-i2c-bus = <&i2c2>;
> +
> +		port@0 {
> +			reg = <0>;
> +
> +			hdmi_mux_0: endpoint {
> +				remote-endpoint = <&ipu1_di0_hdmi>;
> +			};
> +		};
> +
> +		port@1 {
> +			reg = <1>;
> +
> +			hdmi_mux_1: endpoint {
> +				remote-endpoint = <&ipu1_di1_hdmi>;
> +			};
> +		};
> +	};


