Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaIIQGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:06:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45999 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757345AbaIIQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:06:08 -0400
Date: Tue, 9 Sep 2014 17:05:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH V3] pwm: lpc32xx - Add a driver for the motor PWM
Message-ID: <20140909160548.GB3896@leverpostej>
References: <1410277361-26848-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410277361-26848-1-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 04:42:41PM +0100, Alban Bedel wrote:
> The LPC32xx motor PWMs have two output pin, A and B, with B = !A.
> The driver can switch the polarity to allow use either output pin A
> or output pin B.
> 
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
> V3: * Updated to current mainline API
>     * Fixed LPC32xx vs. LPC32XX
>     * Various coding style fix
> V2: * Splitted the DTS to its own patch
> ---
>  .../devicetree/bindings/pwm/lpc32xx-motor-pwm.txt  |  24 +++
>  drivers/pwm/Kconfig                                |  10 +
>  drivers/pwm/Makefile                               |   1 +
>  drivers/pwm/pwm-lpc32xx-motor.c                    | 210 +++++++++++++++++++++
>  4 files changed, 245 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
>  create mode 100644 drivers/pwm/pwm-lpc32xx-motor.c
> 
> diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt b/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
> new file mode 100644
> index 0000000..decc27c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
> @@ -0,0 +1,24 @@
> +LPC32xx Motor PWM controller
> +
> +The LPC32xx motor PWMs have two output pin, A and B, with B = !A.
> +By default, output A should be used, if output B is used the PWM
> +polarity should be inverted using the linux,polarity property.
> +
> +Required properties:
> +- compatible: should be "nxp,lpc3220-motor-pwm"
> +- reg: physical base address and length of the controller's registers
> +
> +Optional properties:
> +- linux,polarity: Bit mask of the polarity to use for each output,
> +      a bit set to 0 indicate the default polarity, a bit set to 1
> +      indicate an inverted polarity. In other word this set if output
> +      pin A or output pin B has the correct polarity.

What exactly does linux have to do with the choice of pin? Why should
this be "linux,polarity"?

> +
> +Examples:
> +
> +mpwm@400e8000 {
> +	compatible = "nxp,lpc3220-motor-pwm";
> +	reg = <0x400E8000 0x78>;
> +	linux,polarity = <0x5>; /* Use outputs B0, A1 and B2 */

This doesn't match the description of there being two output pins. I
take it the description above is somewhat misleading?

> +	#pwm-cells = <2>;

The format of these cells should be described.

Wouldn't it make more sense to describe the polarity in the
pwm-specifier? It seems like a property of the connection rather than
the PWM controller itself.

[...]

> +	lpc32xx->clk = devm_clk_get(&pdev->dev, NULL);

No clock was described in the binding.

Is there only the one clock feeding the pwm? (rather than separate
interface and pwm clocks).

Please describe clocks in the binding. If the clock inputs are named,
please use clock-names.

Thanks,
Mark.
