Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaKIVe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 16:34:56 -0500
Received: from mail-bl2on0089.outbound.protection.outlook.com ([65.55.169.89]:59810
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751350AbaKIVez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 16:34:55 -0500
Date: Sun, 9 Nov 2014 13:34:48 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Peter Crosthwaite <crosthwaitepeter@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <michals@xilinx.com>, <sorenb@xilinx.com>,
        <steven.wang@digilentinc.com>
Subject: Re: [PATCH 1/2] arm: dts: zynq: Move crystal freq. to board level
References: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21088.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <38537ddd8ce845cd9929db4ffcb33031@BN1AFFO11FD006.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(24454002)(189002)(377424004)(51704005)(1411001)(31966008)(85182001)(106466001)(104016003)(50986999)(33646002)(107046002)(110136001)(23676002)(108616004)(62966003)(74316001)(77156002)(77096003)(4396001)(20776003)(92566001)(53416004)(47776003)(44976005)(95666004)(6806004)(46102003)(86362001)(50466002)(87936001)(21056001)(120916001)(99396003)(83506001)(64706001)(19580405001)(54356999)(19580395003)(102836001)(76176999)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB065;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB065;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB065;
X-Forefront-PRVS: 0390DB4BDA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB065;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
> The fact that all supported boards use the same 33MHz crystal is a
> co-incidence. The Zynq PS support a range of crystal freqs so the
> hardcoded setting should be removed from the dtsi. Re-implement it
> on the board level.
> 
> This prepares support for Zynq boards with different crystal
> frequencies (e.g. the Digilent ZYBO).

Even with the 33MHz in the dtsi you can override it on the board-level.
Just like the 'status' property is overriden in board dts files.

> 
> Signed-off-by: Peter Crosthwaite <crosthwaite.peter@gmail.com>
> 
> ---
> Im guessing long term this should be converted to a fixed clock. But
> I think this at least steps in that direction.

I was against that since it makes juggling with clock names more
difficult. The problem is that the CCF uses a global name space of clock
names. Not having the oscillator as fixed-clock in DT removed that
additional complexity. But it would be possible, I guess.

> ---
>  arch/arm/boot/dts/zynq-7000.dtsi      | 1 -
>  arch/arm/boot/dts/zynq-parallella.dts | 4 ++++
>  arch/arm/boot/dts/zynq-zc702.dts      | 4 ++++
>  arch/arm/boot/dts/zynq-zc706.dts      | 4 ++++
>  arch/arm/boot/dts/zynq-zed.dts        | 4 ++++
>  5 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index ce2ef5b..ee3e5d6 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -243,7 +243,6 @@
>  			clkc: clkc@100 {
>  				#clock-cells = <1>;
>  				compatible = "xlnx,ps7-clkc";
> -				ps-clk-frequency = <33333333>;
>  				fclk-enable = <0>;
>  				clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
>  						"cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
> index e1f51ca..cd84d45 100644
> --- a/arch/arm/boot/dts/zynq-parallella.dts
> +++ b/arch/arm/boot/dts/zynq-parallella.dts
> @@ -83,3 +83,7 @@
>  &uart1 {
>  	status = "okay";
>  };
> +
> +&clkc {
> +	ps-clk-frequency = <33333333>;
> +};
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
> index 94e2cda..24dcece 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> @@ -135,3 +135,7 @@
>  &uart1 {
>  	status = "okay";
>  };
> +
> +&clkc {
> +	ps-clk-frequency = <33333333>;
> +};
> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
> index a8bbdfb..7b88399 100644
> --- a/arch/arm/boot/dts/zynq-zc706.dts
> +++ b/arch/arm/boot/dts/zynq-zc706.dts
> @@ -114,3 +114,7 @@
>  &uart1 {
>  	status = "okay";
>  };
> +
> +&clkc {
> +	ps-clk-frequency = <33333333>;
> +};
> diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
> index 697779a..4662da2 100644
> --- a/arch/arm/boot/dts/zynq-zed.dts
> +++ b/arch/arm/boot/dts/zynq-zed.dts
> @@ -46,3 +46,7 @@
>  &uart1 {
>  	status = "okay";
>  };
> +
> +&clkc {
> +	ps-clk-frequency = <33333333>;
> +};

I think we currently have the nodes more or less in alphabetical order.
I'd prefer if we maintained that.

Other than that:
Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Soren
