Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3FERNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:13:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40045 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab3FERNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:13:50 -0400
Message-ID: <51AF71CA.8060808@wwwdotorg.org>
Date: Wed, 05 Jun 2013 11:13:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, sameo@linux.intel.com, wim@iguana.be,
        lgirdwood@gmail.com, gg@slimlogic.co.uk, t-kristo@ti.com,
        lee.jones@linaro.org, Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH v2] mfd: DT bindings for the palmas family MFD
References: <1370335309-6319-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1370335309-6319-1-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 02:41 AM, J Keerthy wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> Add the various binding files for the palmas family of chips. There is a
> top level MFD binding then a seperate binding for regulators IP blocks on chips.

> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt

> +Optional properties:
> +  ti,mux_padX : set the pad register X (1-2) to the correct muxing for the
> +  		hardware, if not set will use muxing in OTP.
> +
> +Example:
...
> +	ti,mux-pad1 = <0>;
> +	ti,mux-pad2 = <0>;

Use of - vs. _ is inconsistent there. It should be -.

> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt

> +Optional nodes:
> +- regulators : should contain the constrains and init information for the
> +	       regulators. It should contain a subnode per regulator from the
> +	       list.

I would re-phrase that as:

Must contain a sub-node per regulator from the list below. Each sub-node
should contain the constraints and initialization information for that
regulator. See regulator.txt for a description of standard properties
for these sub-nodes. Additional custom properties  are listed below.

> +	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
> +	       smps45, smps457, smps7 depending on varient, smps6, smps[8-10],

typo: s/varient/variant/.

> +	       ldo[1-9], ldoln, ldousb

nit: s/$/./ ?

> +
> +	       optional chip specific regulator fields :-

Perhaps "Optional sub-node properties:"?

> +pmic {
> +	compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
> +	interrupt-parent = <&palmas>;
> +	interrupts = <14 IRQ_TYPE_NONE>;
> +	interrupt-name = "short-irq";

If those are required, shouldn't they be listed in a "Required
properties" section above? In particular, the order of entries in the
interrupts property must be defined, as well as the expected nameds in
the interrupt-name property.

Oh, and it's interrupt-names not interrupt-name.

Oh, one question though: How does the regulator driver determine the
register address of the regulator sub-device within the overall PMIC?
Presumably if these are pluggable independent modules, that could change
depending on which overall chip the PMIC device is plugged into. don't
you need a reg property to specify that?

Aside from those comments, this all looks reasonable to me.
