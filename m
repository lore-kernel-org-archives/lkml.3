Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab3KSN5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:57:05 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45444 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab3KSN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:56:59 -0500
Date: Tue, 19 Nov 2013 13:56:54 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Subject: Re: [PATCH 1/5] Documentation: dt: Add kona-pwm binding
Message-ID: <20131119135654.GL5914@e106331-lin.cambridge.arm.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
 <1384800901-21711-2-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384800901-21711-2-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 06:54:57PM +0000, Tim Kryger wrote:
> Add the binding description for the kona-pwm block found on Broadcom's
> mobile SoCs.
> 
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  .../devicetree/bindings/pwm/bcm-kona-pwm.txt       | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
> 
> diff --git a/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
> new file mode 100644
> index 0000000..5c3ea1b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
> @@ -0,0 +1,24 @@
> +Broadcom's PWM Controller Device Tree bindings
> +
> +Broadcom's Kona PWM Controller has 6 channels
> +
> +Required Properties :
> +- compatible: should be "brcm,kona-pwm"
> +- reg: physical base address and length of the controller's registers
> +- clocks: clock specifier for the kona pwm external clock

Minor nit: phandle + clock-specifier pair

> +- #pwm-cells: should be 2.  The first cell specifies the per-chip index
> +  of the PWM to use and the second cell is the period in nanoseconds.
> +
> +Refer to pwm/pwm.txt for generic pwm controller node properties.
> +
> +Refer to clocks/clock-bindings.txt for generic clock consumer
> +properties
> +
> +Example:
> +
> +pwm: pwm@3e01a000 {
> +	compatible = "brcm,bcm11351-pwm", "brcm,kona-pwm";
> +	reg = <0x3e01a000 0xc4>;
> +	clocks = <&pwm_clk>;
> +	#pwm-cells = <2>;
> +};

Otherwise this looks fine.

Mark.
