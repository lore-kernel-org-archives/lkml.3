Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab3J2OJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:09:46 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49958 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab3J2OJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:09:43 -0400
Message-ID: <1383055709.2837.17.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v3 06/10] spmi: document the PMIC arbiter SPMI bindings
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Gilad Avidov <gavidov@codeaurora.org>,
        linux-kernel@vger.kernel.org, Michael Bohan <mbohan@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 29 Oct 2013 16:08:29 +0200
In-Reply-To: <043d714725f8b6df1873047164d2d0e78778138b.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
	 <043d714725f8b6df1873047164d2d0e78778138b.1382985169.git.joshc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Josh,

On Mon, 2013-10-28 at 13:12 -0500, Josh Cartwright wrote: 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  .../bindings/spmi/qcom,spmi-pmic-arb.txt           | 42 ++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> 
> diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> new file mode 100644
> index 0000000..68949aa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> @@ -0,0 +1,42 @@
> +Qualcomm SPMI Controller (PMIC Arbiter)
> +
> +The SPMI PMIC Arbiter is found on the Snapdragon 800 Series.  It is an SPMI
> +controller with wrapping arbitration logic to allow for multiple on-chip
> +devices to control a single SPMI master.
> +
> +The PMIC Arbiter can also act as an interrupt controller, providing interrupts
> +to slave devices.
> +
> +See spmi.txt for the generic SPMI controller binding requirements for child
> +nodes.
> +
> +Required properties:
> +- compatible : should be "qcom,spmi-pmic-arb".
> +- reg-names  : should be "core", "intr", "cnfg"
> +- reg : offset and length of the PMIC Arbiter Core register map.
> +- reg : offset and length of the PMIC Arbiter Interrupt controller register map.
> +- reg : offset and length of the PMIC Arbiter Configuration register map.
> +- #address-cells : must be set to 1

This doesn't seem to follow generic set of bindings for the SPMI
controllers. #address-cells : must be set to 2.

Regards,
Ivan

> +- #size-cells : must be set to 0
> +- interrupt-controller : indicates the PMIC arbiter is an interrupt controller
> +- #interrupt-cells = <4>:  interrupts are specified as a 4-tuple:
> +    cell 1: slave ID for the requested interrupt (0-15)
> +    cell 2: peripheral ID for requested interrupt (0-255)
> +    cell 3: the requested peripheral interrupt (0-7)
> +    cell 4: interrupt flags indicating level-sense information, as defined in
> +            dt-bindings/interrupt-controller/irq.h
> +
> +Example:
> +
> +	qcom,spmi@fc4c0000 {
> +		compatible = "qcom,spmi-pmic-arb";
> +		reg-names = "core", "intr", "cnfg";
> +		reg = <0xfc4cf000 0x1000>,
> +		      <0Xfc4cb000 0x1000>,
> +		      <0Xfc4ca000 0x1000>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		interrupt-controller;
> +		#interrupt-cells = <4>;
> +	};


