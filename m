Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549Ab3FSMDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:03:06 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39644 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934286Ab3FSMDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <1371547751-13873-1-git-send-email-christian.ruppert@abilis.com>
References: <20130618092516.GC18663@ab42.lan>
	<1371547751-13873-1-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 19 Jun 2013 14:03:02 +0200
Message-ID: <CACRpkdbhTsRAGSkxQURd01_yd5arw7=ktVXAmeEo22gFg4U38Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:29 AM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> This patch adds the infrastructure required to register non-linear gpio
> ranges through gpiolib and the standard GPIO device tree bindings.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

I'm basically fine with this, but would like Stephen's ACK if possible.

> +In addition, named groups of pins can be mapped to pin groups of a given
> +pin controller:
> +
> +       gpio_pio_g: gpio-controller@1480 {
> +               #gpio-cells = <2>;
> +               compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> +               reg = <0x1480 0x18>;
> +               gpio-controller;
> +               gpio-ranges = <&pinctrl1 0 0 0>, <&pinctrl2 3 0 0>;
> +               gpio-ranges-group-names = "foo", "bar";
> +       };
> +
> +where,
> +   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.
> +
> +   The following value specifies the base GPIO offset of the pin range with
> +   respect to the GPIO controller's base. The remaining two values must be
> +   0 to indicate that a named pin group should be used for the respective
> +   range. The number of pins in the range is the number of pins in the pin
> +   group.

So while this works, these zeroes seem a bit awkward, but maybe
it's the only way?

I'm not good enough on device tree conventions, but isn't this possible:

              gpio-ranges = <&pinctrl1 0>, <&pinctrl2 3>;
              gpio-ranges-group-names = "foo", "bar";

Since we don't have any #gpio-ranges-cells or anything like that I
guess we can define this to have a flexible number of cells
depending on use case?

In the mixed case the blank groups does not look
good eitherm, wouldn't this be possible:


        gpio-ranges =           <&pinctrl1 0 20 10>,
                                        <&pinctrl2 10>,
                                        <&pinctrl1 15 0 10>,
                                        <&pinctrl2 25>;
        // Matches the two ranges without pins
        gpio-ranges-group-names = "foo", "bar";

Or is this just making things complicated?

Yours,
Linus Walleij
