Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaCUVbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:31:19 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64582 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaCUVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:31:14 -0400
Message-ID: <532CAF9D.3020303@gmail.com>
Date: Fri, 21 Mar 2014 22:31:09 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/5] clk: berlin: add berlin clocks DT bindings documentation
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com> <1395432521-11055-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395432521-11055-3-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:08 PM, Alexandre Belloni wrote:
> Document the device tree bindings for the PLLs found on the Marvell Berlin SoCs.
>
> Cc: devicetree@vger.kernel.org

You forgot to add Mark Rutland's Reviewed-by. He didn't mentioned it
explicitly but his "Otherwise this looks fine to me" on v1, is as good
as a Reviewed-by. But, no need to resend, I'll fix it up.

Also, everything above the '---' will be part of your commit log. While
the Signed-off-by and Reviewed-by should be in there, Cc's really don't
need to.

You can add another '---' to separate commit message and some stuff
you want to have early in you email with:

Blablabla commit message.

Signed-off-by: ...
Reviewed-by: ...
---
Changelog:
- blabla

Cc: cc-me-recipient
...
---
    .../devicetree/bindings/clock/berlin-clock.txt     | 29 
++++++++++++++++++++++
    1 file changed, 29 insertions(+)
    create mode 100644 
Documentation/devicetree/bindings/clock/berlin-clock.txt

  diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt 
b/Documentation/devicetree/bindings/clock/berlin-clock.txt
...

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   .../devicetree/bindings/clock/berlin-clock.txt     | 29 ++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/berlin-clock.txt
>
> diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/Documentation/devicetree/bindings/clock/berlin-clock.txt
> new file mode 100644
> index 000000000000..49b7860bffb8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/berlin-clock.txt
> @@ -0,0 +1,29 @@
> +Device Tree Clock bindings for Marvell Berlin clocks
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Required properties:
> +- compatible: shall be one of the following:
> +	"marvell,berlin2-pll",
> +	"marvell,berlin2q-pll":
> +		CPU PLL and System PLL
> +- reg: Address and length of the clock register set.
> +- #clock-cells: from common clock binding; shall be set to 0.
> +- clocks: from common clock binding
> +
> +smclk: sysmgr-clock {
> +	compatible = "fixed-clock";
> +	#clock-cells = <0>;
> +	clock-frequency = <25000000>;
> +};
> +
> +cpupll: cpupll@ea003c {
> +	compatible = "marvell,berlin2-pll";
> +	clocks = <&smclk>;
> +	#clock-cells = <0>;
> +	reg = <0xea003c 0x8>;
> +};
> +
> +
>

