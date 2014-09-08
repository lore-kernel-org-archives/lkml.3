Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaIHWoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:44:16 -0400
Received: from relmlor4.renesas.com ([210.160.252.174]:39834 "EHLO
	relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754665AbaIHWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:44:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,488,1406559600"; 
   d="scan'208";a="169661402"
Message-ID: <540E313B.8000305@renesas.com>
Date: Tue, 09 Sep 2014 07:44:11 +0900
From: Khiem Nguyen <khiem.nguyen.xt@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, khiem.nguyen.xt@renesas.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/5] PM / Domains: Add DT bindings for the R-Mobile
 System Controller
References: <1410183344-14756-1-git-send-email-geert+renesas@glider.be> <1410183344-14756-3-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1410183344-14756-3-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert, 

Thanks for your patch.

On 9/8/2014 10:35 PM, Geert Uytterhoeven wrote:
> A.o., the Renesas R-Mobile System Controller provides power management
> support, following the generic PM domain bindings in
> Documentation/devicetree/bindings/power/power_domain.txt.
> 
> For now this supports the R-Mobile A1 (r8a7740) only, but it should be
> sufficiently generic to handle other members of the SH-Mobile/R-Mobile
> family in the future.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../bindings/power/renesas,sysc-rmobile.txt        | 106 +++++++++++++++++++++
>  1 file changed, 106 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
> 
> diff --git a/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt b/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
> new file mode 100644
> index 000000000000..8d9d64df0088
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
> @@ -0,0 +1,106 @@
> +DT bindings for the Renesas R-Mobile System Controller
> +
> +== System Controller Node ==
> +
> +The R-Mobile System Controller provides the following functions:
> +  - Boot mode management,
> +  - Reset generation,
> +  - Power management.
> +
> +Required properties:
> +- compatible: Should be "renesas,sysc-<soctype>", "renesas,sysc-rmobile" as
> +	      fallback.
> +	      Examples with soctypes are:
> +		- "renesas,sysc-r8a7740" (R-Mobile A1)
> +- reg: Two address start and address range blocks for the device:
> +         - The first block refers to the normally accessible registers,
> +         - the second block refers to the registers protected by the HPB
> +	   semaphore.
> +
> +Optional nodes:
> +- pm-domains: This node contains a hierarchy of PM domain nodes, which should
> +  match the Power Area Hierarchy in the Power Domain Specifications section of
> +  the device's datasheet.
> +
> +
> +== PM Domain Nodes ==
> +
> +Each of the PM domain nodes represents a PM domain, as documented by the
> +generic PM domain bindings in
> +Documentation/devicetree/bindings/power/power_domain.txt.
> +
> +The nodes should be named by the real power area names, and thus their names
> +should be unique.
> +
> +Required properties:
> +  - #power-domain-cells: Must be 0.
> +
> +Optional properties:
> +- reg: If the PM domain is not always-on, this property must contain the bit
> +       index number for the corresponding power area in the various Power
> +       Control and Status Registers. The parent's node must contain the
> +       following two properties:
> +	 - #address-cells: Must be 1,
> +	 - #address-cells: Must be 0.

Should it be "#size-cells: Must be 0." ?

> +       If the PM domain is always-on, this property must be omitted.
> +- power-on-latency: Power-on latency of the PM domain, in ns,
> +- power-off-latency: Power-off latency of the PM domain, in ns.
> +
> +
> +Example:
> +
> +This shows a subset of the r8a7740 PM domain hierarchy, containing the
> +C5 "always-on" domain, 2 of its subdomains (A4S and A4SU), and the A3SP domain,
> +which is a subdomain of A4S.
> +
> +	sysc: system-controller@e6180000 {
> +		compatible = "renesas,sysc-r8a7740", "renesas,sysc-rmobile";
> +		reg = <0xe6180000 8000>, <0xe6188000 8000>;
> +
> +		pm-domains {
> +			pd_c5: c5 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				#power-domain-cells = <0>;
> +
> +				pd_a4s: a4s@10 {
> +					reg = <10>;
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					#power-domain-cells = <0>;
> +					power-on-latency = <250000>;
> +					power-off-latency = <250000>;
> +
> +					pd_a3sp: a3sp@11 {
> +						reg = <11>;
> +						#power-domain-cells = <0>;
> +						power-on-latency = <250000>;
> +						power-off-latency = <250000>;
> +					};
> +				};
> +
> +				pd_a4su: a4su@20 {
> +					reg = <20>;
> +					#power-domain-cells = <0>;
> +					power-on-latency = <250000>;
> +					power-off-latency = <250000>;
> +				};
> +			};
> +		};
> +	};
> +
> +
> +== PM Domain Consumers ==
> +
> +Hardware blocks belonging to a PM domain should contain a "power-domains"
> +property that is a phandle pointing to the corresponding PM domain node.
> +
> +Example:
> +
> +	tpu: pwm@e6600000 {
> +		compatible = "renesas,tpu-r8a7740", "renesas,tpu";
> +		reg = <0xe6600000 0x100>;
> +		clocks = <&mstp3_clks R8A7740_CLK_TPU0>;
> +		power-domains = <&pd_a3sp>;
> +		#pwm-cells = <3>;
> +	};
> 

-- 
Best regards,
KHIEM Nguyen
