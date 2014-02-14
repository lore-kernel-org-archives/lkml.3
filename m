Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaBNJTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:19:07 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51908 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaBNJS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <1392339605-20691-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1392339605-20691-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Fri, 14 Feb 2014 10:18:58 +0100
X-Google-Sender-Auth: fhgMskNDLNFYXARsDQg_VsM-r2A
Message-ID: <CAMuHMdUPJ_Wz85AJeYF8vnkOfjd8A7fHb45bL5-B0bAPqNHnhw@mail.gmail.com>
Subject: Re: [PATCH 23/27] clocksource: sh_cmt: Add DT support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 2:00 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> +++ b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
> @@ -0,0 +1,75 @@
> +* Renesas R-Car Compare Match Timer (CMT)
> +
> +The CMT is a multi-channel 16/32/48-bit timer/counter with configurable clock

16-bit is mentioned here ...

> +inputs and programmable compare match.
> +
> +Channels share hadware resources but their counter and compare match value are

hardware

> +independent. A particular CMT instance can implement only a subset of the
> +channels supported by the CMT model. Channels indices start from 0 and are

Channel indices

> +consecutive.
> +
> +Required Properties:
> +
> +  - compatible: must contain one of the following.

... why not add "renesas,cmt-16" here (and one extra line in the actual driver),
while you're at it?

> +    - "renesas,cmt-32" for the 32-bit CMT
> +               (CMT0 on sh7372, sh73a0 and r8a7740)
> +    - "renesas,cmt-32-fast" for the 32-bit CMT with fast clock support
> +               (CMT[234] on sh7372, sh73a0 and r8a7740)
> +    - "renasas,cmt-48" for the 48-bit CMT
> +               (CMT1 on sh7372, sh73a0 and r8a7740)
> +    - "renesas,cmt-48-gen2" for the second generation 48-bit CMT
> +               (CMT[01] on r8a73a4, r8a7790 and r8a7791)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
