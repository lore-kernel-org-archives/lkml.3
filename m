Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaICCaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:30:10 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:1180
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751109AbaICCaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:30:06 -0400
Message-ID: <54067D28.20408@opensource.altera.com>
Date: Tue, 2 Sep 2014 21:30:00 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <tthayer@opensource.altera.com>, <robherring2@gmail.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <atull@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings & devicetree
 entries.
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
In-Reply-To: <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BLUPR08CA0053.namprd08.prod.outlook.com (10.141.200.33) To
 DM2PR0301MB1197.namprd03.prod.outlook.com (25.160.217.147)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(24454002)(189002)(199003)(377454003)(479174003)(51704005)(4396001)(105586002)(86362001)(106356001)(31966008)(74662001)(77096002)(77982001)(74502001)(79102001)(575784001)(46102001)(102836001)(42186005)(33656002)(95666004)(64126003)(23756003)(107046002)(87976001)(50466002)(65816999)(92726001)(47776003)(50986999)(21056001)(85306004)(54356999)(76176999)(83322001)(19580405001)(101416001)(65956001)(80022001)(2201001)(81542001)(65806001)(90102001)(76482001)(99396002)(83072002)(85852003)(64706001)(92566001)(81342001)(66066001)(19580395003)(20776003)(1121002)(921003)(83996005)(217873001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB1197;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi DTS maintainers,

If possible, can I please get an Acked-by for this patch?

Many thanks...

Dinh

On 8/11/14, 10:18 AM, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v2: Changes to SoC SDRAM EDAC code.
> 
> v3: Implement code suggestions for SDRAM EDAC code.
> 
> v4: Remove syscon from SDRAM controller bindings.
> 
> v5: No Change, bump version for consistency.
> 
> v6: Only map the ctrlcfg register as syscon.
> 
> v7: No change. Bump for consistency.
> 
> v8: No change. Bump for consistency.
> 
> v9: Changes to support a MFD SDRAM controller with nested EDAC.
> 
> v10: Revert to using syscon based on feedback.
> ---
>  .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |   11 +++++++++++
>  2 files changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> new file mode 100644
> index 0000000..d0ce01d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> @@ -0,0 +1,15 @@
> +Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
> +The EDAC accesses a range of registers in the SDRAM controller.
> +
> +Required properties:
> +- compatible : should contain "altr,sdram-edac";
> +- altr,sdr-syscon : phandle of the sdr module
> +- interrupts : Should contain the SDRAM ECC IRQ in the
> +	appropriate format for the IRQ controller.
> +
> +Example:
> +	sdramedac {
> +		compatible = "altr,sdram-edac";
> +		altr,sdr-syscon = <&sdr>;
> +		interrupts = <0 39 4>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 4676f25..45b361e 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -603,6 +603,17 @@
>  			};
>  		};
>  
> +		sdr: sdr@ffc25000 {
> +			compatible = "syscon";
> +			reg = <0xffc25000 0x1000>;
> +		};
> +
> +		sdramedac {
> +			compatible = "altr,sdram-edac";
> +			altr,sdr-syscon = <&sdr>;
> +			interrupts = <0 39 4>;
> +		};
> +
>  		L2: l2-cache@fffef000 {
>  			compatible = "arm,pl310-cache";
>  			reg = <0xfffef000 0x1000>;
> 
