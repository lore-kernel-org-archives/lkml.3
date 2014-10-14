Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaJNCaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:30:10 -0400
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:9475
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754275AbaJNCaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:30:07 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mfd: syscon: binding: Add syscon endianness support.
Thread-Topic: [PATCH] mfd: syscon: binding: Add syscon endianness support.
Thread-Index: AQHP0xINjD22MhFkwkuN+h/5uZLojZwvAi+A
Date: Tue, 14 Oct 2014 02:30:04 +0000
Message-ID: <a6a3c9cf91444ac9a50f85b8ee2d4635@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1411025249-34333-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1411025249-34333-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
x-forefront-prvs: 03648EFF89
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(199003)(189002)(13464003)(51704005)(66066001)(64706001)(20776003)(92566001)(74316001)(97736003)(2501002)(40100003)(76576001)(105586002)(107046002)(106356001)(95666004)(86362001)(99286002)(99396003)(54356999)(106116001)(80022003)(76176999)(50986999)(46102003)(19580405001)(19580395003)(21056001)(77096002)(120916001)(101416001)(4396001)(108616004)(76482002)(85852003)(33646002)(85306004)(122556002)(87936001)(31966008)(2656002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi DT guys,

Could someone help me review or ack this patch?

Thanks very much.

BRs
Xiubo



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Thursday, September 18, 2014 3:27 PM
> To: Dong Aisheng-B29396; pankaj.dubey@samsung.com; robh+dt@kernel.org;
> pawel.moll@arm.com; mark.rutland@arm.com; ijc+devicetree@hellion.org.uk;
> galak@codeaurora.org; sameo@linux.intel.com; lee.jones@linaro.org;
> devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCH] mfd: syscon: binding: Add syscon endianness support.
> 
> For many drivers which will support rich endianness of Devices
> need define DT properties by itself with the binding support.
> 
> The regmap core has already support endianness of the following
> case:
> Index      Device     DT properties needed
> ------------------------------------------
> 1          BE         'big-endian'
> 2          LE         'little-endian'
> 
> Please see the regmap binding for more detail information of
> the endianness support.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> 
> 
> This patch hasn't any dependency with Pankaj Dubey's:
>     mfd: syscon: Decouple syscon interface from platform devices
> 
> 
> 
>  Documentation/devicetree/bindings/mfd/syscon.txt | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt
> b/Documentation/devicetree/bindings/mfd/syscon.txt
> index fe8150b..7c33178 100644
> --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> @@ -10,11 +10,22 @@ OS driver) to determine the location of the registers, and
> access the
>  registers directly.
> 
>  Required properties:
> -- compatible: Should contain "syscon".
> -- reg: the register region can be accessed from syscon
> +- compatible:		Should contain "syscon".
> +- reg:			The register region can be accessed from syscon
> 
> -Examples:
> +Optional property:
> +- {big,little}-endian:	Boolean property. Please see ../regmap/regmap.txt
> +			for more information.
> +
> +Example 1:
>  gpr: iomuxc-gpr@020e0000 {
>  	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
>  	reg = <0x020e0000 0x38>;
>  };
> +
> +Example 2:
> +dcfg: dcfg@1ee0000 {
> +	compatible = "fsl,ls1021a-dcfg", "syscon";
> +	reg = <0x0 0x1ee0000 0x0 0x10000>;
> +	big-endian;
> +};
> --
> 2.1.0.27.g96db324

