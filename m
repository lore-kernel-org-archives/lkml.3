Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab3JHUi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:38:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53814 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3JHUix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:38:53 -0400
Message-ID: <52546D56.2040607@wwwdotorg.org>
Date: Tue, 08 Oct 2013 14:38:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, lee.jones@linaro.org,
        sameo@linux.intel.com, broonie@kernel.org, linus.walleij@linaro.org,
        akpm@linux-foundation.org
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        rtc-linux@googlegroups.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, pawel.moll@arm.com, rob@landley.net,
        ijc+devicetree@hellion.org.uk, grant.likely@linaro.org,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V4 1/3] mfd: add support for ams AS3722 PMIC
References: <1380729030-25896-1-git-send-email-ldewangan@nvidia.com> <1380729030-25896-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1380729030-25896-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 09:50 AM, Laxman Dewangan wrote:
> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
> controller, 11 LDOs, RTC, automatic battery, temperature and
> over-current monitoring, 8 GPIOs, ADC and a watchdog.

> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt

> +  The first cell is the IRQ number.

Which IRQ number exist? Perhaps the IRQ IDs match some specific HW register?

> +Pinmux and GPIO:

> +- pinctrl-names: A pinctrl state named "default" must be defined, using the
> +		bindings in pinctrl/pinctrl-binding.txt.

Why is the DT required to define a default state? If the board doesn't
need to set up any pinctrl settings, surely it shouldn't have to define
the default state.

> +- pinctrl[0...n]: Nodes for pin control to represents state 0 to state n.

These aren't nodes. Those are properties that contain phandles that
refer to nodes.

> +	Each of these nodes contains different subnodes to represents
> +	some desired configuration for a list of pins. This configuration can
> +	include the mux function to select on those pin(s), and various pin
> +	configuration parameters, such as pull-up, open drain.

What contains "these nodes"?

> +
> +Each subnode have following properties:
> +Required properties:
> +	pins: List of pins. Valid options for pins properties are
> +		gpio0, gpio1, gpio2, gpio3, gpio4, gpio5, gpio6, gpio7
> +
> +Optional properties:
> +	Optional properties are

Why repeat that?

> +		function, bias-disable, bias-pull-up, bias-pull-down,
> +		bias-high-impedance, drive-open-drain.
> +
> +		Valid options for funtion properties are:

s/funtion/function/

I would say "values" not "options", as I think I pointed out before, but
I supopse I don't care.

> +Optional sub nodes:

The following might make it clear where these optional nodes sit:

Optional sub nodes of "regulators":
-----------------------------------

> +	Additional custom properties  are listed below.

Required or optional?

