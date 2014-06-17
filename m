Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaFQDjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:39:49 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:52581 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbaFQDjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VaK3PR4exCsYbaYwEK=_cuK+=PK9QqK_uD-cT_Y7m7UQ@mail.gmail.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-4-git-send-email-tushar.b@samsung.com>
	<CAD=FV=XqqP7+xDOAKCixivzgaO0xvJX7L+CCN+unAEuf-6aUbQ@mail.gmail.com>
	<539ED2C0.8030405@gmail.com>
	<CAD=FV=UaaRQVq3TmXMTv9OkER+zORC89YfPNjwZwfCQKmuavrw@mail.gmail.com>
	<20140616165123.GA21661@sirena.org.uk>
	<CAD=FV=VaK3PR4exCsYbaYwEK=_cuK+=PK9QqK_uD-cT_Y7m7UQ@mail.gmail.com>
Date: Tue, 17 Jun 2014 09:09:45 +0530
Message-ID: <CAC5m3BzJ0308OuLUxhf16sk5YDCWcV73HGekzFcxZQjwnNk0zA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dts: Enable audio support for Peach-pi board
From: Tushar Behera <trblinux@gmail.com>
To: Doug Anderson <dianders@google.com>
Cc: Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:32 PM, Doug Anderson <dianders@google.com> wrote:
> Mark,
>
> On Mon, Jun 16, 2014 at 9:51 AM, Mark Brown <broonie@kernel.org> wrote:
>> On Mon, Jun 16, 2014 at 09:49:26AM -0700, Doug Anderson wrote:
>>
>>> Yes please.  I think there's supposed to be some official ordering of
>>> things.  If anyone reading this has a pointer to the official sort
>>> order of things in the device tree I'd love to see it!  ;)
>>
>> Most exact first I believe?
>
> More specifically I'm looking for the ordering between nodes and
> between properties in a node.  For instance:
>
> 1. It appears to be convention to sort children of the "pinctrl" nodes
> by the first pin number in that group.  That is:
>
> ec_spi_cs: ec-spi-cs {
>   samsung,pins = "gpb1-2";
>   ...
> };
>
> ...comes before:
> usb300_vbus_en: usb300-vbus-en {
>   samsung,pins = "gph0-0";
>   ...
> };
>
> ...that's one really good and well-defined ordering.
>
>
> 2. I have no idea how general properties should be sorted.  I tend to
> see "compatible" first but that's above the only rule I've seen.
> Sometimes I've seen "status" first, sometimes last, sometimes
> alphabetically sorted, and sometimes in a random place.  Examples:
>
> usb301_vbus_reg: regulator-usb301 {
>   compatible = "regulator-fixed";
>   regulator-name = "P5.0V_USB3CON1";
>   regulator-min-microvolt = <5000000>;
>   regulator-max-microvolt = <5000000>;
>   gpio = <&gph0 1 0>;
>   pinctrl-names = "default";
>   pinctrl-0 = <&usb301_vbus_en>;
>   enable-active-high;
> };
>
> &hdmi {
>   status = "okay";
>   hpd-gpio = <&gpx3 7 GPIO_ACTIVE_HIGH>;
>   pinctrl-names = "default";
>   pinctrl-0 = <&hdmi_hpd_irq>;
>   ddc = <&i2c_2>;
> };
>
>
> 3. I have no idea how to sort nodes.  In theory you could say that
> they should be sorted by base address:
>
> i2s0: i2s@03830000 {
>   ...
> };
>
> hsi2c_7: i2c@12CD0000 {
>   ...
> };
>
> i2s1: i2s@12D60000 {
>   ...
> };
>
> ...that works until someone argues that all of the "i2s" nodes should
> be together.  It also doesn't work so well with the board convention
> of using aliases to refer to things in the SoC, like:
>
> &i2s0 {
>   status = "okay";
> };
>
> &hsi2c_7 {
>   status = "okay";
> };
>
> ...it's not at all obvious in the board file what the base address in
> the SoC was.
>

In case where we are using only aliases in board file, sorting them
alphabetically would be reasonable. This rule would be easy to
reinforce.

> ---
>
> Anyway, none of this is earth shattering and it doesn't matter all
> that much.  It's just nice to have an official order to make diffing
> easier and also to avoid merge conflicts (unlikely someone changing
> different properties will both add them in the same place in the
> ordering).
>
>
> -Doug



-- 
Tushar Behera
