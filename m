Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbaDWRV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:21:58 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48216 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaDWRVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:21:50 -0400
Message-ID: <5357F6AA.1010406@gmail.com>
Date: Wed, 23 Apr 2014 19:21:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] clk: berlin: add berlin clocks DT bindings documentation
References: <1398261667-12621-1-git-send-email-alexandre.belloni@free-electrons.com> <1398261667-12621-3-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1398261667-12621-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:01 PM, Alexandre Belloni wrote:
> Document the newly added berlin clock driver
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Cc: devicetree@vger.kernel.org
>  Documentation/devicetree/bindings/clock/berlin-clock.txt | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/Documentation/devicetree/bindings/clock/berlin-clock.txt
> index 49b7860bffb8..00f0053ef587 100644
> --- a/Documentation/devicetree/bindings/clock/berlin-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/berlin-clock.txt
> @@ -9,6 +9,8 @@ Required properties:
>  	"marvell,berlin2-pll",
>  	"marvell,berlin2q-pll":
>  		CPU PLL and System PLL
> +	"marvell,berlin2-clk":
> +		simple clocks
>  - reg: Address and length of the clock register set.
>  - #clock-cells: from common clock binding; shall be set to 0.
>  - clocks: from common clock binding
> @@ -26,4 +28,9 @@ cpupll: cpupll@ea003c {
>  	reg = <0xea003c 0x8>;
>  };
>  
> -
> +sdio0xinclk: sdio0xinclk@ea023c {

Yuck! ;)

Can't we just simply use "clock@<addr>" for the node name and
have the driver compute the name like simple-bus does?

Sebastian

> +	compatible = "marvell,berlin-clk";
> +	clocks = <&syspll>;
> +	#clock-cells = <0>;
> +	reg = <0xea023c 4>;
> +};
> 

