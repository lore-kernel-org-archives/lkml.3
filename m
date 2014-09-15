Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaIOOgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:36:31 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47218 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaIOOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:36:29 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <1410523386-10581-1-git-send-email-k.kozlowski@samsung.com>
References: <1410523386-10581-1-git-send-email-k.kozlowski@samsung.com>
Date: Mon, 15 Sep 2014 16:36:27 +0200
Message-ID: <CABxcv=mYWDVwOWbvV4xy+xS5tQUrCexCT_LD7hgUO2d3FPe56w@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add Maxim 77693 PMIC to the Trats2 board
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On Fri, Sep 12, 2014 at 2:03 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> +       i2c_max77693: i2c-gpio-1 {
> +               compatible = "i2c-gpio";
> +               gpios = <&gpm2 0 0>, <&gpm2 1 0 >;

Can you please include <dt-bindings/gpio/gpio.h> and use
GPIO_ACTIVE_HIGH instead of 0 here for the type/level flags?

> +               i2c-gpio,delay-us = <2>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               status = "okay";
> +
> +               max77693@66 {
> +                       compatible = "maxim,max77693";
> +                       interrupt-parent = <&gpx1>;
> +                       interrupts = <5 2>;
> +                       reg = <0x66>;
> +
> +                       regulators {
> +                               esafeout1_reg: esafeout@1 {
> +                                       regulator-compatible = "ESAFEOUT1";

According to Documentation/devicetree/bindings/regulator/regulator.txt,
the "regulator-compatible" DT property has been deprecated in favor of
just using the regulator node's name.

> +                                       regulator-name = "ESAFEOUT1";
> +                               };
> +                               esafeout2_reg: esafeout@2 {
> +                                       regulator-compatible = "ESAFEOUT2";
> +                                       regulator-name = "ESAFEOUT2";
> +                               };
> +                               charger_reg: charger@0 {
> +                                       regulator-compatible = "CHARGER";
> +                                       regulator-name = "CHARGER";
> +                                       regulator-min-microamp = <60000>;
> +                                       regulator-max-microamp = <2580000>;
> +                               };
> +                       };
> +               };
> +       };
> +
>         mmc@12550000 {
>                 num-slots = <1>;
>                 supports-highspeed;
>

Once those two issues are addressed, feel free to add my

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
