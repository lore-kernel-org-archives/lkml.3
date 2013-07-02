Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3GBLp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:45:59 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58751 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3GBLp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <51D2BB05.9040201@free-electrons.com>
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1372094699-3832-3-git-send-email-alexandre.belloni@free-electrons.com>
	<CAOMZO5CLcT=OXYd=ggxpDzUqFxoXSaanqUPGugYLT2Og-VgzCA@mail.gmail.com>
	<51D2BB05.9040201@free-electrons.com>
Date: Tue, 2 Jul 2013 08:45:56 -0300
Message-ID: <CAOMZO5DZufiOjguOCEbe5n0j=w9B5ezBYh0Rejv3zF5Xht5_qQ@mail.gmail.com>
Subject: Re: [PATCHv3 2/3] ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
From: Fabio Estevam <festevam@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        brian@crystalfontz.com, linux-doc@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jimwall@q.com, Rob Herring <rob.herring@calxeda.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Lucas Stach <l.stach@pengutronix.de>, Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 8:35 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> mxs-i2c 8005a000.i2c: Failed to get PIO reg. write descriptor.
>
> That is the one line 243. I'm open to any suggestion.
>
> BTW, I also tested PIO mode with and without touchscreen support as that
> seemed to toggle the issue on your side. It is also worse than what it
> was in 3.9. Trying to read the nau7802 ADC never returns.
>
> The excerpt from my DT:
>
> i2c1: i2c@8005a000 {
>         pinctrl-names = "default";
>         pinctrl-0 = <&i2c1_pins_a>;
>         status = "okay";
> };
>
> i2cmux {
>         compatible = "i2c-mux-gpio";
>         #address-cells = <1>;
>         #size-cells = <0>;
>         pinctrl-names = "default";
>         pinctrl-0 = <&i2cmux_pins_cfa10049>;
>         mux-gpios = <&gpio1 22 0 &gpio1 23 0>;
>         i2c-parent = <&i2c1>;
>
>         i2c@0 {
>                 reg = <0>;

Shouldn't this be

         i2c@1 {
                 reg = <1>; ?
