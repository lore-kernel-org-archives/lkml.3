Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbaFQUXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:23:49 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42932 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:23:47 -0400
Date: Tue, 17 Jun 2014 21:23:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RESEND: PATCH 1/2] mfd: tc3589x: Add device tree bindings
Message-ID: <20140617202340.GW29841@lee--X1>
References: <1397028480-15413-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397028480-15413-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Apr 2014, Linus Walleij wrote:

> This defines the device tree bindings for the Toshiba TC3589x
> series of multi-purpose expanders. Only the stuff I can test
> is defined: GPIO and keypad. Others may implement more
> subdevices further down the road.
> 
> This is to complement
> commit a435ae1d51e2f18414f2a87219fdbe068231e692
> "mfd: Enable the tc3589x for Device Tree" which left off
> the definition of the device tree bindings.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Fix the keys/rows bindings to be u32 rather than
>   /bits/ 8, inconsistency noted by Mark Rutland.
> ChangeLog v1->v2:
> - Include a verbose example in the DT bindings.
> - Explain why this is a stand-alone bindings patch.
> ---
>  Documentation/devicetree/bindings/mfd/tc3589x.txt | 107 ++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/tc3589x.txt

Looks about right, been on the list for ages and doesn't add any new
properties.  Applied, thanks.

> diff --git a/Documentation/devicetree/bindings/mfd/tc3589x.txt b/Documentation/devicetree/bindings/mfd/tc3589x.txt
> new file mode 100644
> index 000000000000..c6ac5bd2ce51
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/tc3589x.txt
> @@ -0,0 +1,107 @@
> +* Toshiba TC3589x multi-purpose expander
> +
> +The Toshiba TC3589x series are I2C-based MFD devices which may expose the
> +following built-in devices: gpio, keypad, rotator (vibrator), PWM (for
> +e.g. LEDs or vibrators) The included models are:
> +
> +- TC35890
> +- TC35892
> +- TC35893
> +- TC35894
> +- TC35895
> +- TC35896
> +
> +Required properties:
> + - compatible : must be "toshiba,tc35890", "toshiba,tc35892", "toshiba,tc35893",
> +   "toshiba,tc35894", "toshiba,tc35895" or "toshiba,tc35896"
> + - reg : I2C address of the device
> + - interrupt-parent : specifies which IRQ controller we're connected to
> + - interrupts : the interrupt on the parent the controller is connected to
> + - interrupt-controller : marks the device node as an interrupt controller
> + - #interrupt-cells : should be <1>, the first cell is the IRQ offset on this
> +   TC3589x interrupt controller.
> +
> +Optional nodes:
> +
> +- GPIO
> +  This GPIO module inside the TC3589x has 24 (TC35890, TC35892) or 20
> +  (other models) GPIO lines.
> + - compatible : must be "toshiba,tc3589x-gpio"
> + - interrupts : interrupt on the parent, which must be the tc3589x MFD device
> + - interrupt-controller : marks the device node as an interrupt controller
> + - #interrupt-cells : should be <2>, the first cell is the IRQ offset on this
> +   TC3589x GPIO interrupt controller, the second cell is the interrupt flags
> +   in accordance with <dt-bindings/interrupt-controller/irq.h>. The following
> +   flags are valid:
> +   - IRQ_TYPE_LEVEL_LOW
> +   - IRQ_TYPE_LEVEL_HIGH
> +   - IRQ_TYPE_EDGE_RISING
> +   - IRQ_TYPE_EDGE_FALLING
> +   - IRQ_TYPE_EDGE_BOTH
> + - gpio-controller : marks the device node as a GPIO controller
> + - #gpio-cells : should be <2>, the first cell is the GPIO offset on this
> +   GPIO controller, the second cell is the flags.
> +
> +- Keypad
> +  This keypad is the same on all variants, supporting up to 96 different
> +  keys. The linux-specific properties are modeled on those already existing
> +  in other input drivers.
> + - compatible : must be "toshiba,tc3589x-keypad"
> + - debounce-delay-ms : debounce interval in milliseconds
> + - keypad,num-rows : number of rows in the matrix, see
> +   bindings/input/matrix-keymap.txt
> + - keypad,num-columns : number of columns in the matrix, see
> +   bindings/input/matrix-keymap.txt
> + - linux,keymap: the definition can be found in
> +   bindings/input/matrix-keymap.txt
> + - linux,no-autorepeat: do no enable autorepeat feature.
> + - linux,wakeup: use any event on keypad as wakeup event.
> +
> +Example:
> +
> +tc35893@44 {
> +	compatible = "toshiba,tc35893";
> +	reg = <0x44>;
> +	interrupt-parent = <&gpio6>;
> +	interrupts = <26 IRQ_TYPE_EDGE_RISING>;
> +
> +	interrupt-controller;
> +	#interrupt-cells = <1>;
> +
> +	tc3589x_gpio {
> +		compatible = "toshiba,tc3589x-gpio";
> +		interrupts = <0>;
> +
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +	tc3589x_keypad {
> +		compatible = "toshiba,tc3589x-keypad";
> +		interrupts = <6>;
> +		debounce-delay-ms = <4>;
> +		keypad,num-columns = <8>;
> +		keypad,num-rows = <8>;
> +		linux,no-autorepeat;
> +		linux,wakeup;
> +		linux,keymap = <0x0301006b
> +			        0x04010066
> +				0x06040072
> +				0x040200d7
> +				0x0303006a
> +				0x0205000e
> +				0x0607008b
> +				0x0500001c
> +				0x0403000b
> +				0x03040034
> +				0x05020067
> +				0x0305006c
> +				0x040500e7
> +				0x0005009e
> +				0x06020073
> +				0x01030039
> +				0x07060069
> +				0x050500d9>;
> +	};
> +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
