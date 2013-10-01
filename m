Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3JAUaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:30:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51204 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3JAUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:30:31 -0400
Message-ID: <524B30E2.4000704@wwwdotorg.org>
Date: Tue, 01 Oct 2013 14:30:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, broonie@kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        rtc-linux@googlegroups.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, pawel.moll@arm.com, rob@landley.net,
        ijc+devicetree@hellion.org.uk, grant.likely@linaro.org
Subject: Re: [PATCH V4 2/3] pincntrl: add support for AMS AS3722 pin control
 driver
References: <1380044845-7734-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1380044845-7734-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 11:47 AM, Laxman Dewangan wrote:
> The AS3722 is a compact system PMU suitable for mobile phones, tablets etc.
> 
> Add a driver to support accessing the GPIO, pinmux and pin configuration
> of 8 GPIO pins found on the AMS AS3722 through pin control driver and
> gpiolib.
> 
> The driver will register itself as the pincontrol driver and gpio driver.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-as3722.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-as3722.txt

> +AMS AS3722 Pincontrol

This binding document doesn't appear to define any compatible value. I
think there should be one binding document per compatible value, rather
than splitting up the documentation of a particular binding into lots of
different files. As such, shouldn't this documentation all be part of
Documentation/devicetree/bindings/regulator/as3722-regulator.txt?

> +DT node contains the different subnode for pin control to represent

Which "DT node"? This paragraph doesn't make much sense...

> +different states. Each of these subnodes represents some desired
> +configuration for a list of pins. This configuration can include the
> +mux function to select on those pin(s), and various pin configuration
> +parameters, such as pull-up, open drain.

I think that paragraph is meant to say the following, as part of
as3722-regulator.txt:

==========
Optional sub-nodes:

- pinmux: Represents the pinmux configuration of the AS3722 GPIO pins.
This node contains pin configuration nodes, as defined by
pinctrl-bindings.txt
==========

(and then go on to describe the required/optional properties within the
pin configuration nodes)

> +Valid values for pin names are:

I would say "pin property" rather than "pin names" here, to make it
obvious where these values are used.

> +	gpio0, gpio1, gpio2, gpio3, gpio4, gpio5, gpio6, gpio7
> +
> +Valid value of function names are:

Similarly, "function property" here. (and values for not value of).

Other than that, this binding looks reasonable.
