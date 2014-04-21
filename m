Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaDUQwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:52:17 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50559 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDUQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <1396053110-21639-8-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
	<1396053110-21639-8-git-send-email-sre@kernel.org>
Date: Mon, 21 Apr 2014 11:52:11 -0500
Message-ID: <CAL_JsqLMAj7LewzkOk+tSyaZcS8CXyeozY5zMAY=iTWueuVuVA@mail.gmail.com>
Subject: Re: [PATCHv3 07/14] HSI: Add common DT binding for HSI client devices
From: Rob Herring <robherring2@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 7:31 PM, Sebastian Reichel <sre@kernel.org> wrote:
> Implement and document generic DT bindings for HSI clients.
>
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

Seems pretty reasonable although I know little about HSI.

> ---
>  .../devicetree/bindings/hsi/client-devices.txt     |  44 +++++
>  drivers/hsi/hsi.c                                  | 197 ++++++++++++++++++++-
>  include/linux/hsi/hsi.h                            |   2 +
>  3 files changed, 241 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/hsi/client-devices.txt
>
> diff --git a/Documentation/devicetree/bindings/hsi/client-devices.txt b/Documentation/devicetree/bindings/hsi/client-devices.txt
> new file mode 100644
> index 0000000..7504cb1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hsi/client-devices.txt
> @@ -0,0 +1,44 @@
> +Each HSI port is supposed to have one child node, which
> +symbols the remote device connected to the HSI port. The
> +following properties are standardized for HSI clients:
> +
> +Required HSI configuration properties:
> +
> +- reg:                 A list of channel ids
> +
> +- hsi-rx-mode:         Receiver Bit transmission mode ("stream" or "frame")
> +- hsi-tx-mode:         Transmitter Bit transmission mode ("stream" or "frame")
> +- hsi-mode:            May be used instead hsi-rx-mode and hsi-tx-mode if
> +                       the transmission mode is the same for receiver and
> +                       transmitter
> +- hsi-speed-kbps:      Max bit transmission speed in kbit/s
> +- hsi-flow:            RX flow type ("synchronized" or "pipeline")
> +- hsi-arb-mode:                Arbitration mode for TX frame ("round-robin", "priority")
> +
> +Optional HSI configuration properties:
> +
> +- reg-names:           A list with one name per channel specified in the
> +                       reg property
> +
> +
> +Device Tree node example for an HSI client:
> +
> +hsi-controller {
> +       hsi-port {
> +               modem: hsi-client {
> +                       compatible = "nokia,n900-modem";

Is there only 1 version of HSI? If not, then perhaps you need to know
what version a client is.

> +
> +                       reg = <0>, <1>, <2>, <3>;

Where do these numbers get defined? Are they always 0-N?

I don't see much advantage to using reg. Perhaps something like
hsi-channel-ids would be better.

Rob
