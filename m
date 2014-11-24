Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaKXVCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:02:04 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64426 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKXVCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:02:01 -0500
MIME-Version: 1.0
In-Reply-To: <1416837696-28066-1-git-send-email-alban.bedel@avionic-design.de>
References: <1416837696-28066-1-git-send-email-alban.bedel@avionic-design.de>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 24 Nov 2014 15:01:39 -0600
Message-ID: <CAL_JsqLZ+TMPg9np77xEvt-J9GTv1RyYL9zo=xsuRa6RxvRn9g@mail.gmail.com>
Subject: Re: [PATCH 1/2] devicetree: add a binding for GPIOs going though a
 level shifter
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 8:01 AM, Alban Bedel
<alban.bedel@avionic-design.de> wrote:
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
>  .../devicetree/bindings/gpio/gpio-level-shifter.txt       | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt b/Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt
> new file mode 100644
> index 0000000..e108c43
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-level-shifter.txt
> @@ -0,0 +1,15 @@
> +GPIO level shifter
> +
> +This binding allow supporting GPIOs going though a level shifter.
> +
> +Required properties:
> +- compatible : should be "gpio-level-shifter"
> +- data-gpios : list of the data GPIO phandles
> +- #gpio-cells : should be 2
> +- gpio-controller : marks the device node as a GPIO controller
> +
> +Optional properties:
> +- enable-gpio : phandle of the GPIO that control the level shifter enable pin
> +- direction-gpio : phandle of the GPIO that control the level shifter direction

What if you had 2 level shifters with a common enable, but with
different directions? We'd have to support an ORing of the enable
state. That's largely a gpio subsystem problem I guess.

Otherwise, this looks pretty good to me:

Acked-by: Rob Herring <robh@kernel.org>

Rob

> +- vcca-supply : phandle of the regulator for side A of the level shifter
> +- vccb-supply : phandle of the regulator for side B of the level shifter
> --
> 2.1.3
>
