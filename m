Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3JAUjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:39:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37476 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3JAUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:39:51 -0400
Message-ID: <524B3311.7070006@wwwdotorg.org>
Date: Tue, 01 Oct 2013 14:39:45 -0600
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
        ijc+devicetree@hellion.org.uk, grant.likely@linaro.org,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V3 1/3] mfd: add support for AMS AS3722 PMIC
References: <1380023921-29867-1-git-send-email-ldewangan@nvidia.com> <1380023921-29867-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1380023921-29867-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 05:58 AM, Laxman Dewangan wrote:
> The AMS AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
> controller, 11 LDOs, RTC, automatic battery, temperature and
> over-current monitoring, 8 GPIOs, ADC and watchdog.
> 
> Add MFD core driver for the AS3722 to support core functionality.

> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt

> +Required properties:
> +-------------------
> +- compatible : Must be "ams,as3722".
> +- reg:  I2C device address.
> +- interrupt-controller : AS3722 has its own internal IRQs

You should at least specify that the property is a Boolean.

That description a justification for why that property should be
present, not a description of the property.

If the device only has *internal* IRQs, you shouldn't need any of the
IRQ properties in DT. Rather, I believe you need the IRQ properties
because the device has *external* IRQ inputs via the "gpio-in-interrupt"
GPIO mux function.

> +- interrupt-parent : The parent interrupt controller.

While that property is allowed, it's not required. It's also unusual to
mention it in individual bindings, since it's a system-defined property.

> +Optional properties:
> +-------------------

> +- pinctrl-names: It is define in the
> +	Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt

You need to specify which values must be present in this property.

Why is the property optional?

If you're going to mention pinctrl-names, shouldn't you also mention
pinctrl-$n?

Instead, I would simply say:

==========
Optional properties:

A pinctrl state named "default" must be defined, using the bindings in
../pinctrl/pinctrl-binding.txt.
==========

Oh, and don't use an absolute file-name within the Linux kernel source
tree, since that path name will change after the binding docs are moved
out of the kernel source tree.

As I mentioned when reviewing the pinmux binding, that binding should be
described here.

In the example, I see a regulators binding. That should be here too.
