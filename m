Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaKKOxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:53:33 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:52301 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaKKOx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:53:28 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <6e09401bf04e072f862317b3752edfd4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <546222DE.4020803@rock-chips.com>
Date: Tue, 11 Nov 2014 22:53:18 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
CC: devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>,
        djkurtz@google.com, Philipp Zabel <p.zabel@pengutronix.de>,
        ykk@rock-chips.com, Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Shawn Guo <shawn.guo@linaro.org>,
        jay.xu@rock-chips.com, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v7 7/7] dt-bindings: add document for dw-hdmi
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com> <1415710486-12263-1-git-send-email-andy.yan@rock-chips.com> <54621FCB.1050208@imgtec.com>
In-Reply-To: <54621FCB.1050208@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月11日 22:40, Zubair Lutfullah Kakakhel wrote:
> Hi Andy,
>
> Some minor comments inline.
>
> On 11/11/14 12:54, Andy Yan wrote:
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>> ---
>>
>> Changes in v7: None
>> Changes in v6: None
>> Changes in v5: None
>> Changes in v4: None
>> Changes in v3: None
>> Changes in v2: None
>>
>>   .../devicetree/bindings/drm/bridge/dw-hdmi.txt     | 38 ++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
>>
>> diff --git a/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
>> new file mode 100644
>> index 0000000..aa7ed17
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
>> @@ -0,0 +1,38 @@
>> +DesignWare HDMI bridge bindings
>> +
>> +Required properities:
> 	
> 	    ^properties
>
>> +- compatibel: platform specific such as "fsl,imx6q-hdmi","fsl,imx6dl-hdmi"
>       ^compatible
   thanks , these will be fixed next.
>> +	      "rockchip,rk3288-dw-hdmi"
> This will need to come in a separate series which adds rk3288 hdmi support..
  we will add rk3288 hdmi platform code soon
>
>> +- reg: physical base address of the controller and length
>> +- ddc-i2c-bus: the ddc i2c bus
>> +- interrupts: The interrupt number to the cpu
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
>>
> Thanks
> ZubairLK
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


