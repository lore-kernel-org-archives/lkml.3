Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaEZGDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:03:46 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:16563
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751586AbaEZGDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:03:45 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cosminstefan.stoica@freescale.com" 
	<cosminstefan.stoica@freescale.com>,
        Shawn Guo <Shawn.Guo@freescale.com>
Subject: RE: linux-next: manual merge of the clockevents tree with the
 arm-soc tree
Thread-Topic: linux-next: manual merge of the clockevents tree with the
 arm-soc tree
Thread-Index: AQHPeKV0wlyS0ArKs0KlDb/ybYfCx5tSXjeQ
Date: Mon, 26 May 2014 06:03:38 +0000
Message-ID: <8c52af4f7de64210bb4e37e265e9e827@DM2PR03MB509.namprd03.prod.outlook.com>
References: <20140526154331.7fc6b30c@canb.auug.org.au>
In-Reply-To: <20140526154331.7fc6b30c@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 02234DBFF6
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(164054003)(51704005)(189002)(199002)(83072002)(86362001)(54356999)(46102001)(50986999)(77096999)(81342001)(79102001)(76482001)(19580395003)(92566001)(76176999)(4396001)(20776003)(31966008)(19580405001)(77982001)(74502001)(101416001)(87936001)(80022001)(81542001)(74316001)(66066001)(85852003)(83322001)(33646001)(99396002)(99286001)(76576001)(74662001)(64706001)(2656002)(21056001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB400;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: linux-next: manual merge of the clockevents tree with the arm-soc
> tree
> 
> Hi Daniel,
> 
> Today's linux-next merge of the clockevents tree got a conflict in
> arch/arm/boot/dts/vf610.dtsi between commit 0517fe6aa880 ("ARM: dts:
> vf610-twr: Add support for sdhc1") from the arm-soc tree and commit
> 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer
> node") from the clockevents tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Acked-by: Xiubo Li <Li.Xiubo@freescale.com>

Thanks,

BRs
Xiubo

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/boot/dts/vf610.dtsi
> index 73355ddc5186,3c91b84066a1..000000000000
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@@ -360,17 -347,19 +360,30 @@@
>   				status = "disabled";
>   			};
> 
>  +			esdhc1: esdhc@400b2000 {
>  +				compatible = "fsl,imx53-esdhc";
>  +				reg = <0x400b2000 0x4000>;
>  +				interrupts = <0 28 0x04>;
>  +				clocks = <&clks VF610_CLK_IPG_BUS>,
>  +					<&clks VF610_CLK_PLATFORM_BUS>,
>  +					<&clks VF610_CLK_ESDHC1>;
>  +				clock-names = "ipg", "ahb", "per";
>  +				status = "disabled";
>  +			};
>  +
> + 			ftm: ftm@400b8000 {
> + 				compatible = "fsl,ftm-timer";
> + 				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
> + 				interrupts = <0 44 IRQ_TYPE_LEVEL_HIGH>;
> + 				clock-names = "ftm-evt", "ftm-src",
> + 					"ftm-evt-counter-en", "ftm-src-counter-en";
> + 				clocks = <&clks VF610_CLK_FTM2>,
> + 					<&clks VF610_CLK_FTM3>,
> + 					<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
> + 					<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
> + 				status = "disabled";
> + 			};
> +
>   			fec0: ethernet@400d0000 {
>   				compatible = "fsl,mvf600-fec";
>   				reg = <0x400d0000 0x1000>;
