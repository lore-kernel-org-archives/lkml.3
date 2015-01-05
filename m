Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbbAENdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:33:45 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42127 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbAENdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:33:43 -0500
MIME-Version: 1.0
In-Reply-To: <3007073.i0ghnTEhxV@wasted.cogentembedded.com>
References: <3007073.i0ghnTEhxV@wasted.cogentembedded.com>
Date: Mon, 5 Jan 2015 14:33:41 +0100
X-Google-Sender-Auth: DMiYDvG63bPj7bSs4eoTzsz4NWo
Message-ID: <CAMuHMdX7Efi1s1bt+X8rbqN4=J9JHWh1cHpvZmnC6NCkF4JVGA@mail.gmail.com>
Subject: Re: [PATCH v2] clk-rcar-gen2: RCAN clock support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Pavel Kiryukhin <vksavl@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 11:17 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Add the RCAN clock support to the R-Car generation 2 CPG driver.  This clock
> gets derived from  the USB_EXTAL clock, dividing  it by 6.  The layout of the
> RCANCKCR register is similar to those of the clocks supported by the 'clk-div6'
> driver but has no divider field, and so can't be supported by that driver...
>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Sorry, forgot something...

> Index: linux/Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
> ===================================================================
> --- linux.orig/Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
> +++ linux/Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
> @@ -16,7 +16,7 @@ Required Properties:
>    - clocks: Reference to the parent clock

If the "rcan" clock is to be used, there should be two parent clocks.

>    - #clock-cells: Must be 1
>    - clock-output-names: The names of the clocks. Supported clocks are "main",
> -    "pll0", "pll1", "pll3", "lb", "qspi", "sdh", "sd0", "sd1" and "z"
> +    "pll0", "pll1", "pll3", "lb", "qspi", "sdh", "sd0", "sd1", "z", and "rcan"

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
