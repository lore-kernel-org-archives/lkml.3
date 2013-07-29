Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3G2WfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:35:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63233 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3G2WfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
References: <20130618092516.GC18663@ab42.lan>
	<1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
Date: Tue, 30 Jul 2013 00:35:03 +0200
Message-ID: <CACRpkdZvcF3agP=hK6J6hZn-Sx2Mw=P4dR2Mwzo+NoLxtMkbQg@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for taking eternities to look into this.

On Tue, Jun 18, 2013 at 11:29 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
> Used to control the pinmux and is a prerequisite for the GPIO driver.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
(...)
> +The following pin groups are available:
> +  - GPIO ports: gpioa_pins, gpiob_pins, gpioc_pins, gpiod_pins, gpioe_pins,
> +                gpiof_pins, gpiog_pins, gpioh_pins, gpioi_pins, gpioj_pins,
> +                gpiok_pins, gpiol_pins, gpiom_pins, gpion_pins

I would not attempt to define groups for all GPIO pins.

(...)
> +gpioa: gpio@FF140000 {
> +       compatible = "abilis,tb10x-gpio";
> +       reg = <0xFF140000 0x1000>;
> +       gpio-controller;
> +       #gpio-cells = <2>;
> +       ngpio = <3>;
> +       gpio-ranges = <&iomux 0 0>;
> +       gpio-ranges-group-names = "gpioa_pins";

This uses that feature to define GPIO ranges from a group does
it not? I'm not certain about that feature.

I don't see any of the port concept creeping into the device tree
in this version and that is how I think it should be kept:
the "port" particulars is a thing for the driver and not the
device tree.

Yours,
Linus Walleij
