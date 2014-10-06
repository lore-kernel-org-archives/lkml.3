Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaJFQFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:05:15 -0400
Received: from mail-bn1bon0076.outbound.protection.outlook.com ([157.56.111.76]:64503
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752968AbaJFQFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:05:12 -0400
Date: Mon, 6 Oct 2014 09:04:57 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>,
        <monstr@monstr.eu>, Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Andy Gross <agross@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] ARM: zynq: Add OCM controller driver
References: <e65e39088e0f571ee4905172f2f6c84dbc037805.1412599051.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e65e39088e0f571ee4905172f2f6c84dbc037805.1412599051.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20998.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <2819cd94109f4192a6f6d68e90bc7b2c@BL2FFO11FD039.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(199003)(24454002)(51704005)(189002)(19580395003)(53416004)(108616004)(4396001)(102836001)(85306004)(19580405001)(6806004)(77096002)(44976005)(110136001)(10300001)(104016003)(99396003)(83506001)(64706001)(74316001)(47776003)(20776003)(107046002)(50466002)(95666004)(23676002)(50986999)(54356999)(76176999)(46102003)(80022003)(21056001)(106466001)(87936001)(85182001)(85202003)(120916001)(85852003)(86362001)(76482002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB063;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB063;
X-Forefront-PRVS: 03569407CC
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 02:38PM +0200, Michal Simek wrote:
> The driver provide memory allocator which can
> be used by others drivers to allocate memory inside OCM.
> All location for 64kB blocks are supported
> and driver is trying to allocate the largest continuous
> block of memory.
> 
> Checking mpcore addressing filterring is not done here
> but could be added in future.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
[...]
> diff --git a/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt
> new file mode 100644
> index 000000000000..8ddbd1e5ffc1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt
> @@ -0,0 +1,17 @@
> +Device tree bindings for Zynq's OCM controller
> +
> +The OCM is divided to 4 64kB segments which can be separately configured
> +to low or high location. Location is controlled via SLCR.
> +
> +Required properties:
> + compatible: Compatibility string. Must be "xlnx,zynq-ocmc-1.0".
> + reg: Specify the base and size of the OCMC registers in the memory map.
> +      E.g.: reg = <0xf800c000 0x1000>;
> +
> +Example:
> +ocmc: ocmc@f800c000 {

memory-controller@...

> +	compatible =  "xlnx,zynq-ocmc-1.0";
> +	interrupt-parent = <&intc>;
> +	interrupts = <0 3 4>;
> +	reg = <0xf800c000 0x1000>;
> +} ;

	Sören
