Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3JQQhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:37:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:62317 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3JQQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:37:51 -0400
Message-ID: <52601259.2010308@atmel.com>
Date: Thu, 17 Oct 2013 18:37:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mike Turquette" <mturquette@linaro.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 15/17] clk: at91: add PMC clk device tree binding doc.
References: <1381477081-6041-1-git-send-email-b.brezillon@overkiz.com> <1381491532-14738-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1381491532-14738-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 13:38, Boris BREZILLON :
> This patch adds new at91 clks dt bindings documentation.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

It seems good

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   .../devicetree/bindings/clock/at91-clock.txt       |  328 ++++++++++++++++++++
>   1 file changed, 328 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/at91-clock.txt
>
> diff --git a/Documentation/devicetree/bindings/clock/at91-clock.txt b/Documentation/devicetree/bindings/clock/at91-clock.txt
> new file mode 100644
> index 0000000..360d8fe
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/at91-clock.txt
> @@ -0,0 +1,328 @@
> +Device Tree Clock bindings for arch-at91
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Required properties:
> +- compatible : shall be one of the following:
> +	"atmel,at91rm9200-pmc" or
> +	"atmel,at91sam9g45-pmc" or
> +	"atmel,at91sam9n12-pmc" or
> +	"atmel,at91sam9x5-pmc" or
> +	"atmel,sama5d3-pmc":
> +		at91 PMC (Power Management Controller)
> +		All at91 specific clocks (clocks defined below) must be child
> +		node of the PMC node.
> +
> +	"atmel,at91rm9200-clk-main":
> +		at91 main oscillator
> +
> +	"atmel,at91rm9200-clk-master" or
> +	"atmel,at91sam9x5-clk-master":
> +		at91 master clock
> +
> +	"atmel,at91sam9x5-clk-peripheral" or
> +	"atmel,at91rm9200-clk-peripheral":
> +		at91 peripheral clocks
> +
> +	"atmel,at91rm9200-clk-pll" or
> +	"atmel,at91sam9g45-clk-pll" or
> +	"atmel,at91sam9g20-clk-pllb" or
> +	"atmel,sama5d3-clk-pll":
> +		at91 pll clocks
> +
> +	"atmel,at91sam9x5-clk-plldiv":
> +		at91 plla divisor
> +
> +	"atmel,at91rm9200-clk-programmable" or
> +	"atmel,at91sam9g45-clk-programmable" or
> +	"atmel,at91sam9x5-clk-programmable":
> +		at91 programmable clocks
> +
> +	"atmel,at91sam9x5-clk-smd":
> +		at91 SMD (Soft Modem) clock
> +
> +	"atmel,at91rm9200-clk-system":
> +		at91 system clocks
> +
> +	"atmel,at91rm9200-clk-usb" or
> +	"atmel,at91sam9x5-clk-usb" or
> +	"atmel,at91sam9n12-clk-usb":
> +		at91 usb clock
> +
> +	"atmel,at91sam9x5-clk-utmi":
> +		at91 utmi clock
> +
> +Required properties for PMC node:
> +- reg : defines the IO memory reserved for the PMC.
> +- interrupts : shall be set to PMC interrupt line.
> +- interrupt-controller : tell that the PMC is an interrupt controller.
> +- #interrupt-cells : must be set to 1. The first cell encodes the interrupt id,
> +	and reflect the bit position in the PMC_ER/DR/SR registers.
> +	You can use the dt macros defined in dt-bindings/clk/at91.h.
> +	0 (AT91_PMC_MOSCS) -> main oscillator ready
> +	1 (AT91_PMC_LOCKA) -> PLL A ready
> +	2 (AT91_PMC_LOCKB) -> PLL B ready
> +	3 (AT91_PMC_MCKRDY) -> master clock ready
> +	6 (AT91_PMC_LOCKU) -> UTMI PLL clock ready
> +	8 .. 15 (AT91_PMC_PCKRDY(id)) -> programmable clock ready
> +	16 (AT91_PMC_MOSCSELS) -> main oscillator selected
> +	17 (AT91_PMC_MOSCRCS) -> RC main oscillator stabilized
> +	18 (AT91_PMC_CFDEV) -> clock failure detected
> +
> +For example:
> + 	pmc: pmc@fffffc00 {
> +		compatible = "atmel,sama5d3-pmc";
> +		interrupts = <1 4 7>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +
> +		/* put at91 clocks here */
> +	};
> +
> +Required properties for main clock:
> +- interrupt-parent : must reference the PMC node.
> +- interrupts : shall be set to "<0>".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks (optional if clock-frequency is provided) : shall be the slow clock
> +	phandle. This clock is used to calculate the main clock rate if
> +	"clock-frequency" is not provided.
> +- clock-frequency : the main oscillator frequency.Prefer the use of
> +	"clock-frequency" over automatic clock rate calculation.
> +
> +For example:
> +	main: mainck {
> +		compatible = "atmel,at91rm9200-clk-main";
> +		interrupt-parent = <&pmc>;
> +		interrupts = <0>;
> +		#clock-cells = <0>;
> +		clocks = <&ck32k>;
> +		clock-frequency = <18432000>;
> +	};
> +
> +Required properties for master clock:
> +- interrupt-parent : must reference the PMC node.
> +- interrupts : shall be set to "<3>".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : shall be the master clock sources (see atmel datasheet) phandles.
> +	e.g. "<&ck32k>, <&main>, <&plla>, <&pllb>".
> +- atmel,clk-output-range : minimum and maximum clock frequency (two u32
> +			   fields).
> +	   e.g. output = <0 133000000>; <=> 0 to 133MHz.
> +- atmel,clk-divisors : master clock divisors table (four u32 fields).
> +		0 <=> reserved value.
> +		e.g. divisors = <1 2 4 6>;
> +- atmel,master-clk-have-div3-pres : some SoC use the reserved value 7 in the
> +				    PRES field as CLOCK_DIV3 (e.g sam9x5).
> +
> +For example:
> +	mck: mck {
> +		compatible = "atmel,at91rm9200-clk-master";
> +		interrupt-parent = <&pmc>;
> +		interrupts = <3>;
> +		#clock-cells = <0>;
> +		atmel,clk-output-range = <0 133000000>;
> +		atmel,clk-divisors = <1 2 4 0>;
> +	};
> +
> +Required properties for peripheral clocks:
> +- #clock-cells : from common clock binding; shall be set to 1. The second cell
> +	is used to encode the peripheral id. Peripheral ids are defined in
> +	atmel's SoC datasheets.
> +- clocks : shall be the master clock phandle.
> +	e.g. clocks = <&mck>;
> +- name: device tree node describing a specific system clock.
> +	* atmel,clk-id: peripheral id. See Atmel's datasheets to get a full
> +	  list of peripheral ids.
> +	* atmel,clk-default-divisor (optional, only available for
> +	  "atmel,at91sam9x5-clk-peripheral"): sam9x5 and sama5d3 SoC provides
> +	  configurable peripheral clock divisor. If you define this property
> +	  (u32), the default divisor will be applied when enabling
> +	  peripheral clock. If not provided the peripheral clock is not
> +	  divided.
> +
> +For example:
> +	periph: periphck {
> +		compatible = "atmel,at91sam9x5-clk-peripheral";
> +		#clock-cells = <1>;
> +		clocks = <&mck>;
> +
> +		pioAB_clk {
> +			atmel,clk-id = <2>;
> +			atmel,clk-default-divisor = <1>;
> +		};
> +
> +		pioCD_clk {
> +			atmel,clk-id = <3>;
> +			atmel,clk-default-divisor = <2>;
> +		};
> +	};
> +
> +
> +Required properties for pll clocks:
> +- interrupt-parent : must reference the PMC node.
> +- interrupts : shall be set to "<1>".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : shall be the main clock phandle.
> +- atmel,clk-id : pll id.
> +	0 -> PLL A
> +	1 -> PLL B
> +- atmel,clk-input-range : minimum and maximum source clock frequency (two u32
> +			  fields).
> +	  e.g. input = <1 32000000>; <=> 1 to 32MHz.
> +- #atmel,pll-clk-output-range-cells : number of cells reserved for pll output
> +				      range description. Sould be set to 2, 3
> +				      or 4.
> +	* 1st and 2nd cells represent the frequency range (min-max).
> +	* 3rd cell is optional and represents the OUT field value for the given
> +	  range.
> +	* 4th cell is optional and represents the ICPLL field (PLLICPR
> +	  register)
> +- atmel,pll-clk-output-ranges : pll output frequency ranges + optional parameter
> +				depending on #atmel,pll-output-range-cells
> +				property value.
> +
> +For example:
> +	plla: pllack {
> +		compatible = "atmel,at91sam9g45-clk-pll";
> +		interrupt-parent = <&pmc>;
> +		interrupts = <1>;
> +		#clock-cells = <0>;
> +		clocks = <&main>;
> +		atmel,clk-id = <0>;
> +		atmel,clk-input-range = <2000000 32000000>;
> +		#atmel,pll-clk-output-range-cells = <4>;
> +		atmel,pll-clk-output-ranges = <74500000 800000000 0 0
> +					       69500000 750000000 1 0
> +					       64500000 700000000 2 0
> +					       59500000 650000000 3 0
> +					       54500000 600000000 0 1
> +					       49500000 550000000 1 1
> +					       44500000 500000000 2 1
> +					       40000000 450000000 3 1>;
> +	};
> +
> +Required properties for plldiv clocks (plldiv = pll / 2):
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : shall be the plla clock phandle.
> +
> +The pll divisor is equal to 2 and cannot be changed.
> +
> +For example:
> +	plladiv: plladivck {
> +		compatible = "atmel,at91sam9x5-clk-plldiv";
> +		#clock-cells = <0>;
> +		clocks = <&plla>;
> +	};
> +
> +Required properties for programmable clocks:
> +- interrupt-parent : must reference the PMC node.
> +- #clock-cells : from common clock binding; shall be set to 1. The second cell
> +	is used to encode the programmable clock id.
> +	Peripheral ids are in atmel's SoC
> +	datasheets.
> +- clocks : shall be the programmable clock source phandles.
> +	e.g. clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
> +- name: device tree node describing a specific prog clock.
> +	* atmel,clk-id : programmable clock id (register offset from  PCKx
> +			 register).
> +	* interrupts : shall be set to "<(8 + id)>".
> +
> +For example:
> +	prog: progck {
> +		compatible = "atmel,at91sam9g45-clk-programmable";
> +		interrupt-parent = <&pmc>;
> +		#clock-cells = <1>;
> +		clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
> +
> +		prog0 {
> +			atmel,clk-id = <0>;
> +			interrupts = <8>;
> +		};
> +
> +		prog1 {
> +			atmel,clk-id = <1>;
> +			interrupts = <9>;
> +		};
> +	};
> +
> +
> +Required properties for smd clock:
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : shall be the smd clock source phandles.
> +	e.g. clocks = <&plladiv>, <&utmi>;
> +
> +For example:
> +	smd: smdck {
> +		compatible = "atmel,at91sam9x5-clk-smd";
> +		#clock-cells = <0>;
> +		clocks = <&plladiv>, <&utmi>;
> +	};
> +
> +Required properties for system clocks:
> +- #clock-cells : from common clock binding; shall be set to 1. The second cell
> +	is used to encode the system clock id (bit used in SCER/SCDR register).
> +- name: device tree node describing a specific system clock.
> +	* id: system clock id (bit position in SCER/SCDR/SCSR registers).
> +	      See Atmel's datasheet to get a full list of system clock ids.
> +
> +For example:
> +	system: systemck {
> +		compatible = "atmel,at91rm9200-clk-system";
> +		#clock-cells = <1>;
> +
> +		ddrck {
> +			atmel,clk-id = <2>;
> +			clocks = <&mck>;
> +		};
> +
> +		uhpck {
> +			atmel,clk-id = <6>;
> +			clocks = <&usb>;
> +		};
> +
> +		udpck {
> +			atmel,clk-id = <7>;
> +			clocks = <&usb>;
> +		};
> +	};
> +
> +
> +Required properties for usb clock:
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : shall be the smd clock source phandles.
> +	e.g. clocks = <&pllb>;
> +- atmel,clk-divisors (only available for "atmel,at91rm9200-clk-usb"):
> +	usb clock divisor table.
> +	e.g. divisors = <1 2 4 0>;
> +
> +For example:
> +	usb: usbck {
> +		compatible = "atmel,at91sam9x5-clk-usb";
> +		#clock-cells = <0>;
> +		clocks = <&plladiv>, <&utmi>;
> +	};
> +
> +	usb: usbck {
> +		compatible = "atmel,at91rm9200-clk-usb";
> +		#clock-cells = <0>;
> +		clocks = <&pllb>;
> +		atmel,clk-divisors = <1 2 4 0>;
> +	};
> +
> +
> +Required properties for utmi clock:
> +- interrupt-parent : must reference the PMC node.
> +- interrupts : shall be set to "<AT91_PMC_LOCKU IRQ_TYPE_LEVEL_HIGH>".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : shall be the main clock source phandle.
> +
> +For example:
> +	utmi: utmick {
> +		compatible = "atmel,at91sam9x5-clk-utmi";
> +		interrupt-parent = <&pmc>;
> +		interrupts = <AT91_PMC_LOCKU IRQ_TYPE_LEVEL_HIGH>;
> +		#clock-cells = <0>;
> +		clocks = <&main>;
> +	};
>


-- 
Nicolas Ferre
