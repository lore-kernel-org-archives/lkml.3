Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3HEWEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:04:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57573 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3HEWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:04:28 -0400
Message-ID: <52002167.2050504@wwwdotorg.org>
Date: Mon, 05 Aug 2013 16:04:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, ian.campbell@citrix.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        broonie@kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gg@slimlogic.co.uk, kishon@ti.com
Subject: Re: [PATCH V2 3/3] pinctrl: palmas: add pincontrol driver
References: <1375688014-6117-1-git-send-email-ldewangan@nvidia.com> <1375688014-6117-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1375688014-6117-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 01:33 AM, Laxman Dewangan wrote:
> TI Palmas series Power Management IC have multiple pins which can be
> configured for different functionality. This pins can be configured
> for different function. Also their properties like pull up/down,
> open drain enable/disable are configurable.
> 
> Add support for pincontrol driver Palmas series device like TPS65913,
> TPS80036. The driver supports to be register from DT only.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt

> +Required subnode-properties:
> +- pinctrl-pins: An array of strings. Each string contains the name of a pin.
> +  Valid values for these names are listed below.

s/pinctrl-pins/pins/ I think.

> +Optional subnode-properties:
> +- pinctrl-function:  string containing the name of the function to mux to the
> +  pin. Valid values for function names are listed below. Please refer the
> +  datasheet of the device to determine which are valid for each pin.

s/pinctrl-function/function/ I think.

> +The properties "pinctrl-pins" and "pinctrl-function" ara generic pincontrol
> +properties and described in pinctrl-bindings.txt.
> +
> +Following are other valid propeties for Palams pinctrol dt node which are
> +described in pinctrl-bindings.txt.
> +bias-disable, bias-pull-up, bias-pull-down, bias-pull-pin-default
> +drive-open-drain: Value will represent the open drain to be enable/disable
> + of pins.
> +    0: Disable, 1: Enable.

I'd be tempted to replace everything I quoted above with something a
little simpler to avoid any redundancy with pinctrl-bindings.txt:

==========
This binding uses the following generic properties as defined in
pinctrl-bindings.txt:

Required: pins
Options: function, bias-disable, bias-pull-up, bias-pull-down,
bias-pin-default, drive-open-drain.
==========

> +Note that many of these properties are only valid for certain specific pins.
> +See the Palmas device datasheet for complete details regarding which pins
> +support which functionality.
> +
> +Valid values for pin names are:
> +pins: gpio0, gpio1, gpio2, gpio3, gpio4, gpio5, gpio6, gpio7, gpio8, gpio9,

"pins:" is redundant here.

> +	gpio10, gpio11, gpio12, gpio13, gpio14, gpio15, vac, powergood,
> +	nreswarm, pwrdown, gpadc_start, reset_in, nsleep, enable1, enable2,
> +	int.
> +
> +function: gpio, led, pwm, regen, sysen, clk32kgaudio, id, vbus_det, chrg_det,

I think you would want to structure this list the same as the pins list,
so prefix it with "Valid values for function names are:", and delete
"function:" at the start of the list.

> +There is 4 special function: opt0, opt1, opt2 and opt3. If this functions are

s/this/any of these/

> +selected then directly pins register will be written with 0, 1, 2 and 3

s/and/or/

> +repectively if it is valid for that pins.

s/repectively/respectively/

Hmm. I'm not sure I like mixing those functions with the more "semantic"
function names above. I'd prefer the driver support either the semantic
names or the raw names, but not both. It's not really a big deal though
I suppose.

I didn't review the code, just the binding.
