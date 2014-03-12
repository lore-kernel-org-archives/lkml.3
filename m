Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaCLO2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:28:48 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:37438 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaCLO2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <2194340.F9etmr5mIo@phil>
References: <12569216.pGctOhkhxz@phil>
	<2194340.F9etmr5mIo@phil>
Date: Wed, 12 Mar 2014 09:28:46 -0500
Message-ID: <CAL_JsqKoOhHpJ_OL23WbitQbiJJKLpWrtezT824FP0qtZ2xrEg@mail.gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: document gpio-charger bindings
From: Rob Herring <robherring2@gmail.com>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 8:46 AM, Heiko Stübner <heiko@sntech.de> wrote:
> From: Heiko Stuebner <heiko.stuebner@bq.com>
>
> This documents the binding for the gpio-charger power-supply.

How does this relate to what's documented in power_supply.txt and
charger-manager.txt? Both have references to USB charging. Doesn't
this need some connection to a battery node?

Rob

>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
> ---
>  .../bindings/power_supply/gpio-charger.txt         | 23 ++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/gpio-charger.txt
>
> diff --git a/Documentation/devicetree/bindings/power_supply/gpio-charger.txt b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
> new file mode 100644
> index 0000000..fad87a4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/gpio-charger.txt
> @@ -0,0 +1,23 @@
> +gpio-charger
> +
> +Required properties :
> + - compatible : "gpio-charger"
> + - gpios : GPIO indicating the charger presence.
> +   See GPIO binding in bindings/gpio/gpio.txt .
> + - charger-type : power supply type, one of
> +     unknown
> +     battery
> +     ups
> +     mains
> +     usb-sdp (USB standard downstream port)
> +     usb-dcp (USB dedicated charging port)
> +     usb-cdp (USB charging downstream port)
> +     usb-aca (USB accessory charger adapter)
> +
> +Example:
> +
> +       charger {
> +               compatible = "gpio-charger";
> +               charger-type = "usb-sdp";
> +               gpios = <&gpf0 2 0 0 0>;
> +       }
> --
> 1.8.5.3
>
>
