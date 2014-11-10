Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaKJJRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:17:42 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:6286 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaKJJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:17:38 -0500
Message-ID: <546082A9.5050203@imgtec.com>
Date: Mon, 10 Nov 2014 09:17:29 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, <djkurtz@google.com>,
        <ykk@rock-chips.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <devel@driverdev.osuosl.org>,
        <devicetree@vger.kernel.org>, <linux-rockchip@lists.infradead.org>,
        <jay.xu@rock-chips.com>
Subject: Re: [PATCH V5 7/7] dt-bindings: add document for dw-hdmi
References: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com> <1415424767-7761-1-git-send-email-andy.yan@rock-chips.com>
In-Reply-To: <1415424767-7761-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice work.

This patch should move the binding from

Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
to the location instead of making a new file and leaving the old
one in place.

And use git format-patch -M to highlight any changes.

Regards
ZubairLK

On 08/11/14 05:32, Andy Yan wrote:
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> ---
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
> +- reg: physical base address of the controller and length
> +- ddc-i2c-bus: the ddc i2c bus
> +- interrupts: The interrupt number to the cpu
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
> 
