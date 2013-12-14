Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3LNITM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 03:19:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65055 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3LNITK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 03:19:10 -0500
MIME-Version: 1.0
In-Reply-To: <1386271244-3927-7-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
	<1386271244-3927-7-git-send-email-tim.kryger@linaro.org>
Date: Sat, 14 Dec 2013 00:19:08 -0800
Message-ID: <CAEPRUYo+7G2KT_87bA9sY-97MmiNFVdgGHQo2o4cSX=kGf2hfg@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] Documentation: dt: kona-timer: Add clocks property
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 11:20 AM, Tim Kryger <tim.kryger@linaro.org> wrote:
> The frequency for the Kona timer can either be specified through the
> device tree or determined by checking the rate of the clock specified
> in the device tree.  Update the documentation to reflect both ways.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
>  Documentation/devicetree/bindings/arm/bcm/kona-timer.txt | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt b/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
> index 17d88b2..39adf54 100644
> --- a/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
> +++ b/Documentation/devicetree/bindings/arm/bcm/kona-timer.txt
> @@ -8,13 +8,18 @@ Required properties:
>  - DEPRECATED: compatible : "bcm,kona-timer"
>  - reg : Register range for the timer
>  - interrupts : interrupt for the timer
> +- clocks: phandle + clock specifier pair of the external clock
>  - clock-frequency: frequency that the clock operates
>
> +Only one of clocks or clock-frequency should be specified.
> +
> +Refer to clocks/clock-bindings.txt for generic clock consumer properties.
> +
>  Example:
>         timer@35006000 {
>                 compatible = "brcm,kona-timer";
>                 reg = <0x35006000 0x1000>;
>                 interrupts = <0x0 7 0x4>;
> -               clock-frequency = <32768>;
> +               clocks = <&hub_timer_clk>;
>         };
>
> --
> 1.8.0.1
>
Reviewed-by: Christian Daudt <bcm@fixthebug.org>
