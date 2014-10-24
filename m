Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaJXLxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:53:43 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:52336 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbaJXLx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <1412717576-19737-3-git-send-email-b.galvani@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
	<1412717576-19737-3-git-send-email-b.galvani@gmail.com>
Date: Fri, 24 Oct 2014 13:53:28 +0200
Message-ID: <CACRpkdb4WLX+FeEAuh=YZteaNPzq0WMN0PTTpHnMWmwTts6=Bg@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: meson: add device tree bindings documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 11:32 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:

> Add device tree bindings documentation for Amlogic Meson pinmux and
> GPIO controller.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
(...)
> +Required properties for gpio sub-nodes:
> + - reg: should contain address and size for mux, pull-enable, pull and
> +   gpio register sets
> + - reg-names: an array of strings describing the "reg" entries. Must
> +   contain "mux", "pull" and "gpio". "pull-enable" is optional and
> +   when it is missing the "pull" registers are used instead

So it seems segmenting the registers is done to sort of control the
hardware versioning.

I think it's better to use the compatible string to indicate different
versions of the hardware and then have just have one big
regs to cover all registers.

> +Valid gpio sub-nodes name are:
> + - "banks" for the standard banks
> + - "ao-bank" for the AO bank which belong to the special always-on
> +   power domain

I think it's unnecessary to split up banks, the compatible property
should be enough to know how many banks this controller has
and where they are located in relation to the base offset.

> +Required properties for configuration nodes:
> + - pins: the name of a pin group. The list of all available groups can
> +   be found in driver sources.
> + - function: the name of a function to activate for the specified set
> +   of groups. The list of all available functions can be found in
> +   driver sources.

This is interesting. I have established that for controllers mapping
functions to groups we use
"function" and "groups".

So for per-pin configuration, "function" and "pins" would be
apropriate.

Yours,
Linus Walleij
