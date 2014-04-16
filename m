Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaDPEBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:01:06 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:21466
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751262AbaDPEBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:01:03 -0400
X-Greylist: delayed 2536 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 00:01:03 EDT
From: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: RE: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Topic: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer
 Module timer node.
Thread-Index: AQHPWSBajvnD7Sg41U6A5qHQzMG9AJsTnlPA
Date: Wed, 16 Apr 2014 04:00:59 +0000
Message-ID: <a7aeb70fae2c480198b413f581f76846@BN1PR03MB188.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1397614787-8300-2-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(199002)(377454003)(13464003)(76482001)(99396002)(87936001)(2656002)(81542001)(99286001)(20776003)(74316001)(46102001)(80022001)(76576001)(86362001)(31966008)(66066001)(77982001)(74662001)(83322001)(19580395003)(80976001)(19580405001)(74502001)(50986999)(76176999)(54356999)(33646001)(2201001)(4396001)(81342001)(92566001)(83072002)(79102001)(85852003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB466;H:BN1PR03MB188.namprd03.prod.outlook.com;FPR:E05DCF76.3BA0AD5E.FEED6BB3.9CEE1A9E.2021C;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Wednesday, April 16, 2014 10:20 AM
> To: daniel.lezcano@linaro.org; tglx@linutronix.de; shawn.guo@linaro.org; Lu
> Jingchang-B35083; Jin Zhengxiong-R64188; Wang Dongsheng-B40534
> Cc: devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [RFC][PATCH 1/3] ARM: dts: vf610: Add Freescale FlexTimer Module timer
> node.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Jingchang Lu <b35083@freescale.com>
> ---
>  arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 107e2c0..c3a276f 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -153,6 +153,19 @@
>  				clock-names = "pit";
>  			};
> 
> +			ftm0: ftm@40038000 {
> +				compatible = "fsl,vf610-ftm-timer";
> +				reg = <0x40038000 0x2000>;
> +				interrupts = <0 42 IRQ_TYPE_LEVEL_HIGH>;
> +				clock-names = "ftm0", "ftm1",
> +					"ftm0_counter_en", "ftm1_counter_en";
> +				clocks = <&clks VF610_CLK_FTM0>,
> +					<&clks VF610_CLK_FTM1>,
> +					<&clks VF610_CLK_FTM0_EXT_FIX_EN>,
> +					<&clks VF610_CLK_FTM1_EXT_FIX_EN>;
> +				status = "disabled";
> +			};
> +

They need to be separated. ftm0, ftm1.

>  			wdog@4003e000 {
>  				compatible = "fsl,vf610-wdt", "fsl,imx21-wdt";
>  				reg = <0x4003e000 0x1000>;
> --
> 1.8.4
> 

