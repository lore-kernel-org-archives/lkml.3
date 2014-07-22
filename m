Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaGVJ51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:57:27 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:59643 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbaGVJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:57:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jul 2014 11:57:31 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: peter.chen@freescale.com, s.hauer@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ARM: dts: vf610: add USB PHY and controller
In-Reply-To: <20140722022232.GR8537@dragon>
References: <cover.1405702442.git.stefan@agner.ch>
 <839af70e8acf139bc0f7bbdb4dd68dd146b5d6a8.1405702442.git.stefan@agner.ch>
 <20140722022232.GR8537@dragon>
Message-ID: <64fa5f4fcf6d1331796d2fd7899e3cbd@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-22 04:22, schrieb Shawn Guo:
> On Fri, Jul 18, 2014 at 07:01:37PM +0200, Stefan Agner wrote:
>> This adds USB PHY and USB controller nodes. Vybrid SoCs have two
>> independent USB cores which each supports DR (dual role). However,
>> real OTG is not supported since the OTG ID pin is not available.
>>
>> The PHYs are located within the anadig register range, hence we need
>> to change the length of the anadig registers.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  arch/arm/boot/dts/vf610.dtsi | 46 +++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 43 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
>> index 6a6190c..f6c3f02 100644
>> --- a/arch/arm/boot/dts/vf610.dtsi
>> +++ b/arch/arm/boot/dts/vf610.dtsi
>> @@ -25,6 +25,8 @@
>>  		gpio2 = &gpio3;
>>  		gpio3 = &gpio4;
>>  		gpio4 = &gpio5;
>> +		usbphy0 = &usbphy0;
>> +		usbphy1 = &usbphy1;
>>  	};
>>
>>  	cpus {
>> @@ -285,9 +287,25 @@
>>  				gpio-ranges = <&iomuxc 0 128 7>;
>>  			};
>>
>> -			anatop@40050000 {
>> -				compatible = "fsl,vf610-anatop";
>> -				reg = <0x40050000 0x1000>;
>> +			anatop: anatop@40050000 {
>> +				compatible = "fsl,vf610-anatop", "syscon";
>> +				reg = <0x40050000 0x400>;
>> +			};
>> +
>> +			usbphy0: usbphy@40050800 {
>> +				compatible = "fsl,vf610-usbphy", "fsl,imx23-usbphy";
> 
> Since phy driver will match "fsl,vf610-usbphy" anyway, we do not need
> "fsl,imx23-usbphy" here.

<snip>

>> @@ -309,6 +327,18 @@
>>  				reg = <0x4006b000 0x1000>;
>>  				#clock-cells = <1>;
>>  			};
>> +
>> +			usbdev0: usb@40034000 {
>> +				compatible = "fsl,imx6q-usb", "fsl,imx27-usb";
> 
> It doesn't really make any sense to have "fsl,imx6q-usb" here.  The
> following one should be less confusing.
> 
> 	compatible = "fsl,vf610-usb", "fsl,imx27-usb";


I don't quite understand the rule here, when do we drop compatible you
suggest in fsl,imx23-usbphy and when do we keep the "fallback" as we do
for the USB controller?

Documentation/devicetree/bindings/usb/mxs-phy.txt says:
> "fsl,imx23-usbphy" is still a fallback for other strings


And Documentation/devicetree/bindings/usb/ci-hdrc-imx.txt says:
> - compatible: Should be "fsl,imx27-usb"

--
Stefan

