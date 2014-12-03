Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaLCJqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:46:36 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:36408 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaLCJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:46:33 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <d4dd3d10ea0311aad39646314c7cd0ac>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547EDBEE.70700@rock-chips.com>
Date: Wed, 03 Dec 2014 17:46:22 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Pawel Moll <pawel.moll@arm.com>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, rmk+kernel@arm.linux.org.uk,
        mark.yao@rock-chips.com, fabio.estevam@freescale.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        vladimir_zapolskiy@mentor.com, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v15 06/12] dt-bindings: add document for dw_hdmi
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com> <1417506124-18626-1-git-send-email-andy.yan@rock-chips.com> <1417544629.3411.15.camel@pengutronix.de>
In-Reply-To: <1417544629.3411.15.camel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年12月03日 02:23, Philipp Zabel wrote:
> Hi Andy,
>
> Am Dienstag, den 02.12.2014, 15:42 +0800 schrieb Andy Yan:
>> diff --git a/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
>> new file mode 100644
>> index 0000000..107c1ca
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
>> @@ -0,0 +1,40 @@
>> +DesignWare HDMI bridge bindings
>> +
>> +Required properities:
>> +- compatible: platform specific such as:
>> +   * "fsl,imx6q-hdmi"
>> +   * "fsl,imx6dl-hdmi"
>> +   * "rockchip,rk3288-dw-hdmi"
> I think we should add a common compatible value "snps,dw-hdmi-tx" here:
>
> 	compatible = "fsl,imx6q-hdmi", "snps,dw-hdmi-tx";
>
>> +- reg: Physical base address and length of the controller's registers.
>> +- ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
> Better make ddc-i2c-bus optional, see the other thread about the ddc i2c
> master.
     I have the same idea too, but the patch about ddc i2c master has not
  landed yet,  can we change the ddc-i2c-bus to optional  after the ddc 
i2c master
  patch land?
>> +- interrupts: The HDMI interrupt number
>> +
>> +Optional properties
>> +- reg-io-width: the width of the reg:1,4, default set to 1 if not present
>> +
>> +Example:
>> +	hdmi: hdmi@0120000 {
>> +		compatible = "fsl,imx6q-hdmi";
>> +		reg = <0x00120000 0x9000>;
>> +		interrupts = <0 115 0x04>;
>> +		gpr = <&gpr>;
>> +		clocks = <&clks 123>, <&clks 124>;
>> +		clock-names = "iahb", "isfr";
>> +		ddc-i2c-bus = <&i2c2>;
>> +
>> +		port@0 {
>> +			reg = <0>;
>> +
>> +			hdmi_mux_0: endpoint {
>> +				remote-endpoint = <&ipu1_di0_hdmi>;
>> +			};
>> +		};
>> +
>> +		port@1 {
>> +			reg = <1>;
>> +
>> +			hdmi_mux_1: endpoint {
>> +				remote-endpoint = <&ipu1_di1_hdmi>;
>> +			};
>> +		};
>> +	};
> regards
> Philipp
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


