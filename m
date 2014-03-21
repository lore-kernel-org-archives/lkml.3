Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617AbaCUMK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:10:59 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56300 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCUMK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:10:56 -0400
Message-ID: <532C2D9D.4050901@gmail.com>
Date: Fri, 21 Mar 2014 13:16:29 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] clk: berlin: add berlin clocks DT bindings documentation
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com> <1395402220-23503-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395402220-23503-3-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 12:43 PM, Alexandre Belloni wrote:
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   .../devicetree/bindings/clock/berlin-clock.txt     | 29 ++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/clock/berlin-clock.txt
>
> diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/Documentation/devicetree/bindings/clock/berlin-clock.txt
> new file mode 100644
> index 000000000000..ebc78f9b93a9
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
> +- compatible : shall be one of the following:
> +	"marvell,berlin2-pll" or

nit: just use a comma instead of "or" otherwise that "or" will
be pushed to the new last compatible every time we add a compatible.

> +	"marvell,berlin2q-pll":
> +		CPU PLL and System PLL
> +- reg : Address and length of the clock register set.
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : shall be the input parent clock phandle for the clock.
> +
> +smclk: sysmgr-clock {
> +	compatible = "fixed-clock";
> +	#clock-cells = <0>;
> +	clock-frequency = <25000000>;
> +};
> +
> +cpupll: cpupll {

Reminder: Should receive an update when you change the corresponding
nodes to cpupll: pll@foo

> +	compatible = "marvell,berlin2-pll";
> +	clocks = <&smclk>;
> +	#clock-cells = <0>;
> +	reg = <0xf7ea003c 8>;
> +};
> +
> +
>

