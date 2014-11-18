Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbaKRU4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:56:22 -0500
Received: from mail-bn1on0085.outbound.protection.outlook.com ([157.56.110.85]:32648
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753867AbaKRU4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:56:18 -0500
Message-ID: <546BB27A.20405@opensource.altera.com>
Date: Tue, 18 Nov 2014 14:56:26 -0600
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: <bp@alien8.de>, <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>
Subject: [RESEND PATCHv5 5/5] arm: dts: Add Altera L2 Cache and OCRAM EDAC
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com> <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com>
In-Reply-To: <1415751263-1830-6-git-send-email-tthayer@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0004.namprd00.prod.outlook.com (25.160.102.14) To
 BN1PR03MB122.namprd03.prod.outlook.com (10.255.201.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB122;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB122;
X-Forefront-PRVS: 039975700A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(199003)(24454002)(164054003)(189002)(51704005)(377454003)(479174003)(53754006)(229853001)(65956001)(66066001)(23746002)(99396003)(107046002)(120916001)(65806001)(19300405004)(21056001)(122386002)(105586002)(106356001)(31966008)(95666004)(101416001)(64126003)(97736003)(4396001)(92726001)(92566001)(2201001)(42186005)(47776003)(20776003)(64706001)(86362001)(77156002)(77096003)(62966003)(15202345003)(83506001)(15975445006)(102836001)(33656002)(40100003)(19580405001)(65816999)(54356999)(50466002)(76176999)(19580395003)(50986999)(46102003)(87976001)(1121002)(921003)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB122;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB122;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 11/11/2014 06:14 PM, tthayer@opensource.altera.com wrote:
> From: Thor Thayer<tthayer@opensource.altera.com>
>
> Adding the device tree entries and bindings needed to support
> the Altera L2 cache and On-Chip RAM EDAC. This patch relies upon
> an earlier patch to declare and setup On-chip RAM properly.
> http://www.spinics.net/lists/devicetree/msg51117.html

Any comments on these devicetree additions?

Thanks,
Thor
> Signed-off-by: Thor Thayer<tthayer@opensource.altera.com>
> ---
> v2: Remove OCRAM declaration and reference prior patch.
>
> v3-5: No Change
> ---
>   .../bindings/arm/altera/socfpga-l2-edac.txt        |   15 +++++++++++++++
>   .../bindings/arm/altera/socfpga-ocram-edac.txt     |   16 ++++++++++++++++
>   arch/arm/boot/dts/socfpga.dtsi                     |   15 ++++++++++++++-
>   3 files changed, 45 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
>   create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
>
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
> new file mode 100644
> index 0000000..35b19e3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-l2-edac.txt
> @@ -0,0 +1,15 @@
> +Altera SoCFPGA L2 cache Error Detection and Correction [EDAC]
> +
> +Required Properties:
> +- compatible : Should be "altr,l2-edac"
> +- reg : Address and size for ECC error interrupt clear registers.
> +- interrupts : Should be single bit error interrupt, then double bit error
> +	interrupt. Note the rising edge type.
> +
> +Example:
> +
> +	l2edac@ffd08140 {
> +		compatible = "altr,l2-edac";
> +		reg = <0xffd08140 0x4>;
> +		interrupts = <0 36 1>, <0 37 1>;
> +	};
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
> new file mode 100644
> index 0000000..31ab205
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-ocram-edac.txt
> @@ -0,0 +1,16 @@
> +Altera SoCFPGA On-Chip RAM Error Detection and Correction [EDAC]
> +
> +OCRAM ECC Required Properties:
> +- compatible : Should be "altr,ocram-edac"
> +- reg : Address and size for ECC error interrupt clear registers.
> +- iram : phandle to On-Chip RAM definition.
> +- interrupts : Should be single bit error interrupt, then double bit error
> +	interrupt. Note the rising edge type.
> +
> +Example:
> +	ocramedac@ffd08144 {
> +		compatible = "altr,ocram-edac";
> +		reg = <0xffd08144 0x4>;
> +		iram = <&ocram>;
> +		interrupts = <0 178 1>, <0 179 1>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 6af96ed..32c63a3 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -618,8 +618,21 @@
>   			interrupts = <0 39 4>;
>   		};
>   
> +		l2edac@ffd08140 {
> +			compatible = "altr,l2-edac";
> +			reg = <0xffd08140 0x4>;
> +			interrupts = <0 36 1>, <0 37 1>;
> +		};
> +
> +		ocramedac@ffd08144 {
> +			compatible = "altr,ocram-edac";
> +			reg = <0xffd08144 0x4>;
> +			iram = <&ocram>;
> +			interrupts = <0 178 1>, <0 179 1>;
> +		};
> +
>   		L2: l2-cache@fffef000 {
> -			compatible = "arm,pl310-cache";
> +			compatible = "arm,pl310-cache", "syscon";
>   			reg = <0xfffef000 0x1000>;
>   			interrupts = <0 38 0x04>;
>   			cache-unified;

