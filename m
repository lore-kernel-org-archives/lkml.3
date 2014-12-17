Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaLQInf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:43:35 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35838 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaLQInd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <1418422051-9471-3-git-send-email-bparrot@ti.com>
References: <1418422051-9471-1-git-send-email-bparrot@ti.com> <1418422051-9471-3-git-send-email-bparrot@ti.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 17 Dec 2014 17:43:12 +0900
Message-ID: <CAAVeFuK2o8nCcQSOWf2pO-0hk33CyUsw0SErqq+CdbYZhRgLmA@mail.gmail.com>
Subject: Re: [Patch v4 2/2] gpio: Document GPIO hogging mechanism
To: Benoit Parrot <bparrot@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few nits:

On Sat, Dec 13, 2014 at 7:07 AM, Benoit Parrot <bparrot@ti.com> wrote:
> Add GPIO hogging documentation to gpio.txt
>
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
> Changes since v3:
>  * Renamed the "direction" DT properties to "state".
>
>  Documentation/devicetree/bindings/gpio/gpio.txt | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
> index 3fb8f53..a38da91 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio.txt
> @@ -103,6 +103,22 @@ Every GPIO controller node must contain both an empty "gpio-controller"
>  property, and a #gpio-cells integer property, which indicates the number of
>  cells in a gpio-specifier.
>
> +The GPIO chip may contain GPIO hog definitions. GPIO hogging is a mechanism
> +providing automatic GPIO request and configuration as part of the
> +gpio-controller's driver probe function.
> +
> +Each GPIO hog definition is represented as a child node of the GPIO controller.
> +Required properties:
> +- gpio-hog:  A property specifying that this child node represent a gpio-hog.

... represent a GPIO hog.

> +- gpios:     Store the gpio information (id, flags, ...). Shall contain the
> +            number of cells specified in its parent node (GPIO controller
> +            node).
> +- state:     A property specifying the direction/value needed. This property
> +            can take the folowing values: input, output-high, output-low.

s/folowing/following

This aside,

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
