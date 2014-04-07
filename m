Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaDGQiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:38:11 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63127 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbaDGQiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:38:02 -0400
MIME-Version: 1.0
In-Reply-To: <1396736821-14395-2-git-send-email-sre@kernel.org>
References: <1396736821-14395-1-git-send-email-sre@kernel.org>
	<1396736821-14395-2-git-send-email-sre@kernel.org>
Date: Mon, 7 Apr 2014 11:38:01 -0500
Message-ID: <CAL_Jsq+46bPtgnQc5aAN8bcaw=te6MX=cvMMNP6+6xjG8Drkbg@mail.gmail.com>
Subject: Re: [PATCHv2 1/5] Input: add common DT binding for touchscreens
From: Rob Herring <robherring2@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2014 at 5:26 PM, Sebastian Reichel <sre@kernel.org> wrote:
> Add common DT binding documentation for touchscreen devices and
> implement input_parse_touchscreen_of_params, which parses the common
> properties and configures the input device accordingly.

Good.

>
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> ---
>  .../bindings/input/touchscreen/touchscreen.txt     |  9 ++++++
>  drivers/input/input.c                              | 34 ++++++++++++++++++++++
>  include/linux/input.h                              |  8 +++++
>  3 files changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
>
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
> new file mode 100644
> index 0000000..a2ff0a0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
> @@ -0,0 +1,9 @@
> +General Touchscreen Properties:
> +
> +Optional properties for Touchscreens:
> + - touchscreen-size-x          : horizontal resolution of touchscreen
> + - touchscreen-size-y          : vertical resolution of touchscreen

While I like the consistency, x-size and y-size are already commonly
used. Perhaps the common binding should have both and x-size/y-size be
marked deprecated.

> + - touchscreen-max-pressure    : maximum reported pressure
> + - touchscreen-fuzz-x          : horizontal noise value of the absolute input device
> + - touchscreen-fuzz-y          : vertical noise value of the absolute input device
> + - touchscreen-fuzz-pressure   : pressure noise value of the absolute input device

What are the units or are they just an arbitrary range dependent on
the controller? Several existing bindings appear to be in pixels, but
that seems wrong to me.

There's also these various properties that should have common versions created:

ti,x-plate-resistance and ti,x-plate-ohms (tsc2007)
- rohm,flip-x             : Flip touch coordinates on the X axis
 - rohm,flip-y             : Flip touch coordinates on the Y axis
- x-invert: invert X axis
- y-invert: invert Y axis
- contact-threshold:
- moving-threshold:

Rob
