Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaLBSYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:24:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33295 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbaLBSYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:24:22 -0500
Message-ID: <1417544629.3411.15.camel@pengutronix.de>
Subject: Re: [PATCH v15 06/12] dt-bindings: add document for dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
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
        Mark Rutland <mark.rutland@arm.com>, vladimir_zapolskiy@mentor.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Date: Tue, 02 Dec 2014 19:23:49 +0100
In-Reply-To: <1417506124-18626-1-git-send-email-andy.yan@rock-chips.com>
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>
	 <1417506124-18626-1-git-send-email-andy.yan@rock-chips.com>
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

Hi Andy,

Am Dienstag, den 02.12.2014, 15:42 +0800 schrieb Andy Yan:
> diff --git a/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
> new file mode 100644
> index 0000000..107c1ca
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
> @@ -0,0 +1,40 @@
> +DesignWare HDMI bridge bindings
> +
> +Required properities:
> +- compatible: platform specific such as:
> +   * "fsl,imx6q-hdmi"
> +   * "fsl,imx6dl-hdmi"
> +   * "rockchip,rk3288-dw-hdmi"

I think we should add a common compatible value "snps,dw-hdmi-tx" here:

	compatible = "fsl,imx6q-hdmi", "snps,dw-hdmi-tx";

> +- reg: Physical base address and length of the controller's registers.
> +- ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing

Better make ddc-i2c-bus optional, see the other thread about the ddc i2c
master.

> +- interrupts: The HDMI interrupt number
> +
> +Optional properties
> +- reg-io-width: the width of the reg:1,4, default set to 1 if not present
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

regards
Philipp

