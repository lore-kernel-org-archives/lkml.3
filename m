Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaJBOAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:00:35 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51507 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaJBOAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:00:33 -0400
MIME-Version: 1.0
In-Reply-To: <1411443545-24951-4-git-send-email-srv_hongzhou.yang@mediatek.com>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
	<1411443545-24951-4-git-send-email-srv_hongzhou.yang@mediatek.com>
Date: Thu, 2 Oct 2014 16:00:32 +0200
Message-ID: <CACRpkdbiKSvX2dipnq3oyc6YSGWFgCk69onzF=-B9UWLjAYNWQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: Add pinctrl bindings for mt65xx/mt81xx.
From: Linus Walleij <linus.walleij@linaro.org>
To: "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dandan.he@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 5:39 AM, Hongzhou.Yang
<srv_hongzhou.yang@mediatek.com> wrote:

> From: Hongzhou Yang <hongzhou.yang@mediatek.com>
>
> Add devicetree bindings for Mediatek SoC pinctrl driver.
>
> Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>

I have worked on generic pin control bindings a bit because it
is getting out of hand with all these custom bindings.

See:
http://marc.info/?l=devicetree&m=141223584006648&w=2

Especially.

> +- mediatek,pinfunc: List of gpio number and function to mux.

A "GPIO number" and a "pin number" is not the same thing at all,
this is very confusing. Those are two separate number spaces.
This is likely about the pin numbers.

> +The mediatek,pinfunc can use defines directly,
> +which are already defind in boot/dts/mt8135-pinfunc.h.
> +
> +Optional subnode-properties:
> +- generic pin configuration option to use, bias-disable, bias-pull-down,
> +  bias-pull,up, output-low and output-high are valid.
> +  Example :
> +       i2c0_pins_a {
> +               mediatek,pinfunc = <MT8135_PIN_195_SDA1__FUNC_SDA1>;
> +               bias-disable;
> +       };

I don't like this approach at all.

I prefer that pins are put into groups named by strings, like "i2c0-pos0"
inside the driver and then connected to function with a certain
device-related name, such as "i2c0".

Then put the pin configuration (bias etc) in a separate node in the same
state definition like that:

i2c0_pins_a {
         function = "i2c0";
         groups = "i2c0-pos0";
};
i2c0_pins_b {
         bias-disable;
};

Yours,
Linus Walleij
