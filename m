Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaDVDoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:44:30 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51854 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaDVDo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:44:26 -0400
Date: Tue, 22 Apr 2014 06:44:17 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: xuwei5@hisilicon.com, linus.walleij@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] gpio: pl061: get gpio base from alias id
Message-ID: <20140422034417.GA4652@tarshish>
References: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian Zhuang,

On Tue, Apr 22, 2014 at 09:35:42AM +0800, Haojian Zhuang wrote:
> If gpio base number isn't specified, the gpio base will be find from
> the end of gpio number. In order to keep with schematics, use alias
> to get the ID of gpio chip.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
> ---
>  .../devicetree/bindings/gpio/gpio-pl061.txt        | 31 ++++++++++++++++++++++

Binding documentation should be done in a separate patch.

>  drivers/gpio/gpio-pl061.c                          | 14 +++++++++-
>  2 files changed, 44 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pl061.txt
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-pl061.txt b/Documentation/devicetree/bindings/gpio/gpio-pl061.txt
> new file mode 100644
> index 0000000..164b5ba
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-pl061.txt
> @@ -0,0 +1,31 @@
> +PL061 GPIO controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "arm,pl061", "arm,primecell".
> +- #gpio-cells : Should be two.
> +  - first cell is the gpio pin number
> +  - second cell is used to specify the gpio polarity:
> +      0 = active high
> +      1 = active low
> +- gpio-controller : Marks the device node as a GPIO controller.
> +- interrupt-controller : Marks the device node as an interrupt controller.
> +- #interrupt-cells : Should be two.
> +  - first cell is the hw irq number
> +  - second cell is used to specify the interrupt type:
> +      0 = default, unspecified type
> +      1 = rising edge triggered
> +      2 = falling edge triggered
> +      4 = high level triggered
> +      8 = low level triggered
> +
> +Example:
> +	gpio0: gpio@fc806000 {
> +		compatible = "arm,pl061", "arm,primecell";
> +		reg = <0xfc806000 0x1000>;
> +		interrupts = <0 64 0x4>;

The "interrupts" property should be mentioned above.

> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +	};

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
