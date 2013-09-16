Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3IPQef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:34:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35639 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3IPQed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:34:33 -0400
Message-ID: <52373314.5070806@wwwdotorg.org>
Date: Mon, 16 Sep 2013 10:34:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH] clk: si570: Add a driver for SI570 oscillators
References: <1379033737-30015-1-git-send-email-soren.brinkmann@xilinx.com> <1379033737-30015-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1379033737-30015-2-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 06:55 PM, Soren Brinkmann wrote:
> Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> The devices generate low-jitter clock signals and are reprogrammable via
> an I2C interface.

> diff --git a/Documentation/devicetree/bindings/clock/silabs,si570.txt b/Documentation/devicetree/bindings/clock/silabs,si570.txt

> +Required properties:
> + - compatible: Shall be one of "silabs,si57x", "silabs,si59x".
> + - reg: I2C device address.
> + - #clock-cells: From common clock bindings: Shall be 0.
> + - factory-fout: Factory set default frequency

So, there's no way to query this from the device at all? Looking at the
data-sheet, all the frequency generation parameters are in registers,
and the device supports I2C read commands. As such, I'm not convinced
this property is necessary.

> +Optional properties:
> + - initial-fout: Initial output frequency to set during probe

"probe" is a Linux-specific concept. This property should be removed. If
the driver is asked to set a specific frequency, it should do so, but I
don't think it should program something pro-actively just because it
starts up.

If this property is acceptable, it'd be better to describe it more along
the lines of the following:

initial-fout: The frequency at which the system requires the clock to
operate.

> + - temperature-stability-7ppm: Indicate a device with a temperature stability
> +			       of 7ppm
> +
> +Example:
> +	si570: clock-generator@5d {
> +		#clock-cells = <0>;
> +		compatible = "silabs,si570";
> +		reg = <0x5d>;
> +		factory-fout = <156250000>;
> +	};

