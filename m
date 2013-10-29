Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3J2OTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:19:50 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:51017 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab3J2OTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:19:49 -0400
Message-ID: <1383056315.2837.22.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v3 09/10] mfd: pm8x41: document device tree bindings
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Date: Tue, 29 Oct 2013 16:18:35 +0200
In-Reply-To: <88997d3863f72f8553fcaf66cf67fbf3289df04f.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
	 <88997d3863f72f8553fcaf66cf67fbf3289df04f.1382985169.git.joshc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Josh,

On Mon, 2013-10-28 at 13:12 -0500, Josh Cartwright wrote: 
> Document the bindings used to describe the Qualcomm 8x41 PMICs.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/mfd/pm8x41.txt | 33 ++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/pm8x41.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/pm8x41.txt b/Documentation/devicetree/bindings/mfd/pm8x41.txt
> new file mode 100644
> index 0000000..6afd4ce
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/pm8x41.txt
> @@ -0,0 +1,33 @@
> +Qualcomm PM8841 and PM8941 PMIC multi-function devices
> +
> +The PM8x41 PMICs are used with the Qualcomm Snapdragon 800 series SoCs, and are
> +interfaced to the chip via the SPMI (System Power Management Interface) bus.
> +Support for  multiple independent functions are implemented by splitting the
> +16-bit SPMI slave address space into 256 smaller fixed-size regions, 256 bytes
> +each.  A function can consume one or more of these fixed-size register regions.
> +
> +Required properties:
> +- compatible: Must be one of:
> +     "qcom,pm8841"
> +     "qcom,pm8941"
> +- reg: Specifies the SPMI USID slave address for this device
> +- #address-cells = <1>
> +- #size-cells = <0>
> +
> +Each child node represents a function of the PM8x41.  Each child 'reg' entry
> +describes an offset within the USID slave address where the region starts.
> +
> +Example:
> +
> +pm8941@0 {
> +	compatible = "qcom,pm8941";
> +	reg = <0x0>;
> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	rtc {
> +		compatible = "qcom,pm8941-rtc";
> +		reg = <0x6000 0x6100>;

This doesn't look right. Probably #size-cells have to be <1>?

Regards,
Ivan


> +	};
> +}


