Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaBYArl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:47:41 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:45422 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaBYAri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:47:38 -0500
MIME-Version: 1.0
In-Reply-To: <1393199401-27197-2-git-send-email-sre@debian.org>
References: <1393199401-27197-1-git-send-email-sre@debian.org>
	<1393199401-27197-2-git-send-email-sre@debian.org>
Date: Mon, 24 Feb 2014 18:47:37 -0600
Message-ID: <CAL_JsqJ5eHLSztBgjvi1TAEVeM6dfwnLwm4ygLnD+H0xrNXMfA@mail.gmail.com>
Subject: Re: [PATCHv1 1/6] HSI: add Device Tree support for HSI clients
From: Rob Herring <robherring2@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        =?windows-1251?B?yOLg6evuIMTo7Ojy8O7i?= <freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 5:49 PM, Sebastian Reichel <sre@debian.org> wrote:
> Add new method hsi_add_clients_from_dt, which can be used
> to initialize HSI clients from a device tree node.
>
> The patch also documents the DT binding for trivial HSI
> clients.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  .../devicetree/bindings/hsi/trivial-devices.txt    | 36 +++++++++++
>  drivers/hsi/hsi.c                                  | 70 +++++++++++++++++++++-
>  include/dt-bindings/hsi/hsi.h                      | 17 ++++++
>  include/linux/hsi/hsi.h                            |  2 +
>  4 files changed, 124 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/hsi/trivial-devices.txt
>  create mode 100644 include/dt-bindings/hsi/hsi.h
>
> diff --git a/Documentation/devicetree/bindings/hsi/trivial-devices.txt b/Documentation/devicetree/bindings/hsi/trivial-devices.txt
> new file mode 100644
> index 0000000..1ace14a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hsi/trivial-devices.txt
> @@ -0,0 +1,36 @@
> +This is a list of trivial hsi client devices that have simple
> +device tree bindings, consisting only of a compatible field
> +and the optional hsi configuration.
> +
> +If a device needs more specific bindings, such as properties to
> +describe some aspect of it, there needs to be a specific binding
> +document for it just like any other devices.
> +
> +Optional HSI configuration properties:
> +
> +- hsi,mode             Bit transmission mode (STREAM or FRAME)

hsi is not a vendor prefix, so all these properties should be hsi-*.

> +                       The first value is used for RX and the second one for
> +                       TX configuration. If only one value is provided it will
> +                       be used for RX and TX.
> +                       The assignments may be found in header file
> +                       <dt-bindings/hsi/hsi.h>.
> +- hsi,channels         Number of channels to use [1..16]
> +                       The first value is used for RX and the second one for
> +                       TX configuration. If only one value is provided it will
> +                       be used for RX and TX.
> +- hsi,speed            Max bit transmission speed (Kbit/s)

Include the units in the prop name: hsi-speed-kbps

> +                       The first value is used for RX and the second one for
> +                       TX configuration. If only one value is provided it will
> +                       be used for RX and TX.
> +- hsi,flow             RX flow type (SYNCHRONIZED or PIPELINE)
> +                       The assignments may be found in header file
> +                       <dt-bindings/hsi/hsi.h>.
> +- hsi,arb_mode         Arbitration mode for TX frame (Round robin, priority)
> +                       The assignments may be found in header file
> +                       <dt-bindings/hsi/hsi.h>.
> +
> +This is the list of trivial client devices:
> +
> +Compatible             Description
> +==========             =============
> +hsi-char               HSI character device


I've gotten this far and still have no idea what HSI is.

Rob
