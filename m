Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaEOO72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:59:28 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:24092
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753245AbaEOO71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:59:27 -0400
X-Greylist: delayed 2797 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 10:59:27 EDT
Date: Thu, 15 May 2014 07:57:35 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>
Subject: Re: [PATCH] ARM: zynq: dt: Add a fixed regulator for CPU voltage
References: <1399064852-19569-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399064852-19569-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <e9675d40-2fd9-4fed-a020-5b465ea1842d@BN1BFFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(24454002)(35774003)(377424004)(199002)(51704005)(189002)(164054003)(46102001)(31966008)(99396002)(74502001)(50986999)(83322001)(54356999)(19580405001)(86362001)(19580395003)(87936001)(85182001)(85852003)(23676002)(76482001)(74662001)(92566001)(44976005)(92726001)(53416003)(77982001)(81342001)(80022001)(47776003)(4396001)(31696002)(20776003)(83072002)(79102001)(85202002)(50466002)(81542001)(83506001)(76176999)(74316001)(102836001)(70736001)(33646001)(23106003);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB063;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping? Any comments?

	Thanks,
	Sören

On Fri, 2014-05-02 at 02:07PM -0700, Soren Brinkmann wrote:
> To silence the warning
> 	cpufreq_cpu0: failed to get cpu0 regulator: -19
> from the cpufreq driver regarding a missing regulator,
> add a fixed regulator to the DT.
> Zynq does not support voltage scaling and the CPU rail should always be
> supplied with 1 V, hence it is added in the SOC-level dtsi.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> 
>  arch/arm/boot/dts/zynq-7000.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index c1176abc34d9..64779f9d5c38 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -25,6 +25,7 @@
>  			reg = <0>;
>  			clocks = <&clkc 3>;
>  			clock-latency = <1000>;
> +			cpu0-supply = <&regulator_vccpint>;
>  			operating-points = <
>  				/* kHz    uV */
>  				666667  1000000
> @@ -48,6 +49,15 @@
>  		reg = < 0xf8891000 0x1000 0xf8893000 0x1000 >;
>  	};
>  
> +	regulator_vccpint: fixedregulator@0 {
> +		compatible = "regulator-fixed";
> +		regulator-name = "VCCPINT";
> +		regulator-min-microvolt = <1000000>;
> +		regulator-max-microvolt = <1000000>;
> +		regulator-boot-on;
> +		regulator-always-on;
> +	};
> +
>  	amba {
>  		compatible = "simple-bus";
>  		#address-cells = <1>;
> -- 
> 1.9.2.1.g06c4abd
> 
> 

