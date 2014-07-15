Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaGOE3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:29:22 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:6592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751675AbaGOE3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:29:18 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2014 00:29:18 EDT
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv5 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Thread-Topic: [PATCHv5 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Thread-Index: AQHPn+RfYtg5Qf3PJES9i85hJRoxvJugilYw
Date: Tue, 15 Jul 2014 04:29:15 +0000
Message-ID: <6d7c67f283d54f2582de098f12ba66cc@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1405397904-31202-1-git-send-email-Li.Xiubo@freescale.com>
 <1405397904-31202-3-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1405397904-31202-3-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 027367F73D
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(377454003)(13464003)(164054003)(189002)(199002)(54356999)(101416001)(106356001)(95666004)(85306003)(76576001)(81542001)(83322001)(64706001)(81342001)(77096002)(66066001)(33646002)(19580395003)(31966008)(83072002)(4396001)(87936001)(106116001)(76176999)(85852003)(107046002)(50986999)(99396002)(86362001)(99286002)(80022001)(2656002)(19580405001)(76482001)(74662001)(74316001)(2201001)(46102001)(21056001)(20776003)(105586002)(77982001)(92566001)(74502001)(79102001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please ignore this V5 patch series.

Thanks,

BRs




> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Tuesday, July 15, 2014 12:18 PM
> To: broonie@kernel.org; mark.rutland@arm.com
> Cc: robh+dt@kernel.org; pawel.moll@arm.com; ijc+devicetree@hellion.org.uk;
> galak@codeaurora.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv5 2/2] dt/bindings: Add the DT binding documentation for
> endianness
> 
> Device-Tree binding for device endianness
> Index     Device     Endianness properties
> ---------------------------------------------------
> 1         BE         'big-endian'
> 2         LE         'little-endian'
> 
> For one device driver, which will run in different scenarios above
> on different SoCs using the devicetree, we need one way to simplify
> this.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/regmap/regmap.txt          | 48
> ++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt
> 
> diff --git a/Documentation/devicetree/bindings/regmap/regmap.txt
> b/Documentation/devicetree/bindings/regmap/regmap.txt
> new file mode 100644
> index 0000000..cc5f7f8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regmap/regmap.txt
> @@ -0,0 +1,48 @@
> +Device-Tree binding for device endianness
> +
> +The endianness mode of CPU & Device scenarios:
> +Index    CPU       Device     Endianness properties
> +------------------------------------------------------------
> +1        LE        LE         -
> +2        LE        BE         'big-endian{,-*}'
> +3        BE        BE         -
> +4        BE        LE         'little-endian{,-*}'
> +
> +For one device driver, which will run in different scenarios above
> +on different SoCs using the devicetree, we need one way to simplify
> +this.
> +
> +Required properties:
> +- {big,little}-endian{,-*}: these are boolean properties, if absent
> +  meaning that the CPU and the Device are in the same endianness mode.
> +
> +Examples:
> +Scenario 1 : CPU in LE mode & device in LE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +};
> +
> +Scenario 2 : CPU in LE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      big-endian{,-*};
> +};
> +
> +Scenario 3 : CPU in BE mode & device in BE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +};
> +
> +Scenario 4 : CPU in BE mode & device in LE mode.
> +dev: dev@40031000 {
> +	      compatible = "name";
> +	      reg = <0x40031000 0x1000>;
> +	      ...
> +	      little-endian{,-*};
> +};
> --
> 1.8.5

