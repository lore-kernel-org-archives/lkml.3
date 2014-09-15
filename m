Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaIOO4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:56:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23408 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaIOO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:56:10 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-8d-5416fe07cd65
Message-id: <1410792966.883.2.camel@AMDC1943>
Subject: Re: [PATCH] ARM: dts: Add Maxim 77693 PMIC to the Trats2 board
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
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
Date: Mon, 15 Sep 2014 16:56:06 +0200
In-reply-to: <CABxcv=mYWDVwOWbvV4xy+xS5tQUrCexCT_LD7hgUO2d3FPe56w@mail.gmail.com>
References: <1410523386-10581-1-git-send-email-k.kozlowski@samsung.com>
 <CABxcv=mYWDVwOWbvV4xy+xS5tQUrCexCT_LD7hgUO2d3FPe56w@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e/4FV32f2IhBs3vbSw2zljPajFp3QEm
	i/lHzrFa9L9ZyGpx7tVKRotrv2ewWfQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uXeS3W
	HrnLbrH0+kUmiwnT17JYtO49wm6xatcfRgdBjzXz1jB6tDT3sHlc7utl8vg7u5XZ4++qF8we
	O2fdZfdYufwLm8emVZ1sHpuX1Hv0bVnF6PF5k1wAdxSXTUpqTmZZapG+XQJXxrrFhQXHhCv2
	rZrL3MC4hauLkZNDQsBE4svLfkYIW0ziwr31bF2MXBxCAksZJa6suwblfGaU2Pr5ChtIFa+A
	rsTpg4+YQGxhAXeJ/6+2s4PYbALGEpuXLwGrEREwkujcdZUFxGYW+MQq0fXJDMRmEVCVmLz3
	BVgNp0CwxMkVJ1khFvQxSpzZsIcVokFdYtK8RcxdjBxAJylLNPa7QewVlPgx+R7UTHmJzWve
	Mk9gFJiFpGMWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJwC87GBcfszrE
	KMDBqMTDu3CHWIgQa2JZcWXuIUYJDmYlEV7eX0Ah3pTEyqrUovz4otKc1OJDjEwcnFINjBtO
	BuXMOGD940Cegjx7csafYpM88U+/5yw9ySzO9fRsdRjbvtVf6vvvvQjUK2lO2JVwMnibtYTu
	Uvnny1R3TmSM2qT630Zxc8iFxN/hS1xTkmryuFJnLflyfnOZnXTley1D4al3DnYv/m5YUJe5
	SvmNjNwK86wG69M1G1TlA2dN+qOb/c6gQ4mlOCPRUIu5qDgRABTxsuOeAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-09-15 at 16:36 +0200, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On Fri, Sep 12, 2014 at 2:03 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > +       i2c_max77693: i2c-gpio-1 {
> > +               compatible = "i2c-gpio";
> > +               gpios = <&gpm2 0 0>, <&gpm2 1 0 >;
> 
> Can you please include <dt-bindings/gpio/gpio.h> and use
> GPIO_ACTIVE_HIGH instead of 0 here for the type/level flags?

Sure!

> 
> > +               i2c-gpio,delay-us = <2>;
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +               status = "okay";
> > +
> > +               max77693@66 {
> > +                       compatible = "maxim,max77693";
> > +                       interrupt-parent = <&gpx1>;
> > +                       interrupts = <5 2>;
> > +                       reg = <0x66>;
> > +
> > +                       regulators {
> > +                               esafeout1_reg: esafeout@1 {
> > +                                       regulator-compatible = "ESAFEOUT1";
> 
> According to Documentation/devicetree/bindings/regulator/regulator.txt,
> the "regulator-compatible" DT property has been deprecated in favor of
> just using the regulator node's name.

OK

> 
> > +                                       regulator-name = "ESAFEOUT1";
> > +                               };
> > +                               esafeout2_reg: esafeout@2 {
> > +                                       regulator-compatible = "ESAFEOUT2";
> > +                                       regulator-name = "ESAFEOUT2";
> > +                               };
> > +                               charger_reg: charger@0 {
> > +                                       regulator-compatible = "CHARGER";
> > +                                       regulator-name = "CHARGER";
> > +                                       regulator-min-microamp = <60000>;
> > +                                       regulator-max-microamp = <2580000>;
> > +                               };
> > +                       };
> > +               };
> > +       };
> > +
> >         mmc@12550000 {
> >                 num-slots = <1>;
> >                 supports-highspeed;
> >
> 
> Once those two issues are addressed, feel free to add my
> 
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Thank you for feedback!

Best regards,
Krzysztof

> 
> Best regards,
> Javier

